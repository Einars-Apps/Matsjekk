#!/usr/bin/env python3
"""Fetch farm shop POIs from OpenStreetMap (Overpass) and write JSON feed.

Resilience features:
- short connect timeout so an unreachable Overpass host fails in seconds
- rate limits (HTTP 429/406/503) cool that endpoint down instead of retrying for hours
- a small retry budget only while an endpoint is still healthy
- multiple Overpass endpoints
- an overall fetch deadline; remaining countries keep stored data
- bounded Lokalmat pagination
- fallback to last successful country slice from existing output
- optional country subset via FARMSHOP_COUNTRIES env (codes or names, comma separated)
"""
import json
import os
import random
import re
import sys
import time
from pathlib import Path
from urllib.parse import urlparse

import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

COUNTRIES = {
    'Norway': 'NO',
    'Sweden': 'SE',
    'Denmark': 'DK',
    'Finland': 'FI',
    'Germany': 'DE',
    'Netherlands': 'NL',
    'Belgium': 'BE',
    'France': 'FR',
    'Italy': 'IT',
    'Portugal': 'PT',
    'Spain': 'ES',
    'United Kingdom': 'GB',
    'Ireland': 'IE',
    'Austria': 'AT',
    'Switzerland': 'CH',
    'Liechtenstein': 'LI',
    'Luxembourg': 'LU',
}

ROOT = Path(__file__).resolve().parents[1]
OUT_FILE = ROOT / 'docs' / 'data' / 'farmshops.json'
OUT_BY_COUNTRY_DIR = ROOT / 'docs' / 'data' / 'farmshops_by_country'
ARCHIVE_FILE = ROOT / 'docs' / 'data' / 'farmshops_country_archive.json'

OVERPASS_ENDPOINTS = [
    'https://overpass-api.de/api/interpreter',
    'https://lz4.overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
]

MAX_RETRIES = 2
BASE_BACKOFF_SECONDS = 2.0
CONNECT_TIMEOUT_SECONDS = 10
READ_TIMEOUT_SECONDS = 75
REQUEST_TIMEOUT = (CONNECT_TIMEOUT_SECONDS, READ_TIMEOUT_SECONDS)
RATE_LIMIT_COOLDOWN_SECONDS = 120
CONNECT_FAILURE_COOLDOWN_SECONDS = 600
DEFAULT_FETCH_DEADLINE_SECONDS = 20 * 60
LOKALMAT_MAX_PAGES = 40
MAX_ARCHIVE_ITEMS_PER_COUNTRY = 7000

_endpoint_disabled_until = {}
_fetch_deadline_at = None


class FetchDeadlineReached(RuntimeError):
    """The nightly fetch budget is spent; callers should keep stored data."""


class OverpassUnavailable(RuntimeError):
    """An Overpass endpoint should be skipped for cooldown_seconds."""

    def __init__(self, message, cooldown_seconds):
        super().__init__(message)
        self.cooldown_seconds = cooldown_seconds


def _build_session():
    # urllib3's default redirect/connect handling otherwise spends minutes
    # on a dead host and reports "Max retries exceeded".
    session = requests.Session()
    retry = Retry(total=0, connect=0, read=0, redirect=0, status=0, other=0)
    adapter = HTTPAdapter(max_retries=retry)
    session.mount('https://', adapter)
    session.mount('http://', adapter)
    return session


SESSION = _build_session()


def _reset_fetch_runtime_state():
    global _fetch_deadline_at
    _endpoint_disabled_until.clear()
    _fetch_deadline_at = None


def _ensure_deadline():
    global _fetch_deadline_at
    if _fetch_deadline_at is not None:
        return
    raw = os.getenv('FARMSHOP_FETCH_DEADLINE_SECONDS', '').strip()
    try:
        seconds = int(raw) if raw else DEFAULT_FETCH_DEADLINE_SECONDS
    except ValueError:
        seconds = DEFAULT_FETCH_DEADLINE_SECONDS
    _fetch_deadline_at = time.monotonic() + max(seconds, 1)


def _past_deadline():
    _ensure_deadline()
    return time.monotonic() >= _fetch_deadline_at


def _endpoint_available(endpoint):
    return time.monotonic() >= _endpoint_disabled_until.get(endpoint, 0)


def _disable_endpoint(endpoint, seconds):
    cooldown = max(int(seconds), 1)
    _endpoint_disabled_until[endpoint] = max(
        _endpoint_disabled_until.get(endpoint, 0),
        time.monotonic() + cooldown,
    )


def _retry_after_seconds(response):
    raw = (response.headers.get('Retry-After') or '').strip()
    if not raw:
        return 0
    try:
        return max(0, int(float(raw)))
    except ValueError:
        return 0

COUNTRY_NAME_BY_CODE = {code: name for name, code in COUNTRIES.items()}

LOKALMAT_API_BASE = 'https://api.lokalmat.no/producers'
LOKALMAT_PAGE_SIZE = 200
LOKALMAT_MODE_LIST = 1
LOKALMAT_MODE_MAP = 3

COUNTRY_KEYWORD_REGEX = {
    'DE': r'hofladen|bauernladen|landladen|direktvermarkt',
    'FR': r'vente directe|magasin de ferme|producteur|ferme',
    'IT': r'vendita diretta|fattoria|azienda agricola|spaccio agricolo',
    'ES': r'venta directa|tienda de granja|granja|agricola',
    'GB': r'farm shop|farmshop|farm store|pick your own',
}

NORWAY_MUNICIPALITY_ALIASES = {
    'hurum': 'Asker',
    'røyken': 'Asker',
    'royken': 'Asker',
    'røyken kommune': 'Asker',
    'royken kommune': 'Asker',
    'hurum kommune': 'Asker',
}

NORWAY_LOCKED_MUNICIPALITIES = {'Ulvik', 'Voss', 'Asker'}

NORWAY_NAME_OVERRIDES = {
    'ulvik frukt & cideri': {'municipality': 'Ulvik', 'region': 'Vestland'},
    'ulvik frukt&cideri': {'municipality': 'Ulvik', 'region': 'Vestland'},
    'smalahovetunet': {'municipality': 'Voss', 'region': 'Vestland'},
    'voss gardsslakteri (selheim gard)': {'municipality': 'Voss', 'region': 'Vestland'},
    'voss gardsmat': {'municipality': 'Voss', 'region': 'Vestland'},
    'kjærland gårdsbutikk': {'municipality': 'Voss', 'region': 'Vestland'},
    'kjerland gardsbutikk': {'municipality': 'Voss', 'region': 'Vestland'},
    'een gard': {'municipality': 'Voss', 'region': 'Vestland'},
    'gronnsletta gard': {'municipality': 'Asker', 'region': 'Akershus'},
    'grønnsletta gård': {'municipality': 'Asker', 'region': 'Akershus'},
    'vaerby gard': {'municipality': 'Asker', 'region': 'Akershus'},
    'værby gård': {'municipality': 'Asker', 'region': 'Akershus'},
    'bergsmyrene': {'municipality': 'Asker', 'region': 'Akershus'},
    'biffgarden': {'municipality': 'Asker', 'region': 'Akershus'},
    'biffgården': {'municipality': 'Asker', 'region': 'Akershus'},
    'thor graff': {'municipality': 'Asker', 'region': 'Akershus'},
    'hyggen eplemost': {'municipality': 'Asker', 'region': 'Akershus', 'name': 'Hyggen eplemost'},
    'bonden jens': {'municipality': 'Asker', 'region': 'Akershus'},
    'jordbær fra nedre gjerdal gård': {'municipality': 'Asker', 'region': 'Akershus'},
    'jordbaer fra nedre gjerdal gard': {'municipality': 'Asker', 'region': 'Akershus'},
    'hurum hjort': {'municipality': 'Asker', 'region': 'Akershus'},
    'eplegården as': {'municipality': 'Asker', 'region': 'Akershus'},
    'eplegarden as': {'municipality': 'Asker', 'region': 'Akershus'},
    'bryggerhuset på frøtvedt': {'municipality': 'Asker', 'region': 'Akershus'},
    'bryggerhuset pa frotvedt': {'municipality': 'Asker', 'region': 'Akershus'},
    'aaby gård': {'municipality': 'Asker', 'region': 'Akershus'},
    'aaby gard': {'municipality': 'Asker', 'region': 'Akershus'},
    'grisehuset gårdsutsalg': {'municipality': 'Asker', 'region': 'Akershus'},
    'grisehuset gardsutsalg': {'municipality': 'Asker', 'region': 'Akershus'},
    'sand gård': {'municipality': 'Asker', 'region': 'Akershus', 'name': 'Sand Gård'},
    'sand gard': {'municipality': 'Asker', 'region': 'Akershus', 'name': 'Sand Gård'},
    'vinnulstad gård': {'municipality': 'Asker', 'region': 'Akershus'},
    'vinnulstad gard': {'municipality': 'Asker', 'region': 'Akershus'},
    'wettre bryggeri': {'municipality': 'Asker', 'region': 'Akershus'},
    'wettre bryggeri as': {'municipality': 'Asker', 'region': 'Akershus'},
}

NORWAY_ASKER_ALLOWED_NAMES = {
    'gronnsletta gard',
    'grønnsletta gård',
    'vaerby gard',
    'værby gård',
    'bergsmyrene',
    'biffgarden',
    'biffgården',
    'thor graff',
    'hyggen eplemost',
    'bonden jens',
    'jordbær fra nedre gjerdal gård',
    'jordbaer fra nedre gjerdal gard',
    'hurum hjort',
    'eplegården as',
    'eplegarden as',
    'bryggerhuset på frøtvedt',
    'bryggerhuset pa frotvedt',
    'aaby gård',
    'aaby gard',
    'grisehuset gårdsutsalg',
    'grisehuset gardsutsalg',
    'sand gård',
    'sand gard',
    'vinnulstad gård',
    'vinnulstad gard',
    'wettre bryggeri',
    'wettre bryggeri as',
}

NORWAY_MANUAL_SEEDS = [
    {
        'id': 'manual_smalahovetunet_voss',
        'name': 'Smalahovetunet',
        'country': 'Norway',
        'region': 'Vestland',
        'municipality': 'Voss',
        'products': [],
        'website': None,
        'lat': 60.692962,
        'lon': 6.472726,
        'address': None,
        'source': 'https://www.hanen.no/bedrift/ivar-lone-as-smalahovetunet-voss/',
    },
    {
        'id': 'manual_voss_gardsslakteri_selheim_gard',
        'name': 'Voss Gardsslakteri (Selheim gard)',
        'country': 'Norway',
        'region': 'Vestland',
        'municipality': 'Voss',
        'products': [],
        'website': None,
        'lat': 60.6612556,
        'lon': 6.5453055,
        'address': None,
        'source': 'https://www.lokalmat.no/produsenter/voss-gardsslakteri/',
    },
    {
        'id': 'manual_voss_gardsmat',
        'name': 'Voss gardsmat',
        'country': 'Norway',
        'region': 'Vestland',
        'municipality': 'Voss',
        'products': [],
        'website': None,
        'lat': 60.6000992,
        'lon': 6.3502497,
        'address': None,
        'source': 'https://www.lokalmat.no/produsenter/voss-gardsmat/',
    },
    {
        'id': 'manual_kjaerland_gardsbutikk',
        'name': 'Kjærland gårdsbutikk',
        'country': 'Norway',
        'region': 'Vestland',
        'municipality': 'Voss',
        'products': [],
        'website': None,
        'lat': 60.5307238,
        'lon': 6.734827,
        'address': None,
        'source': None,
    },
    {
        'id': 'manual_een_gard_voss',
        'name': 'Een gard',
        'country': 'Norway',
        'region': 'Vestland',
        'municipality': 'Voss',
        'products': [],
        'website': None,
        'lat': 60.6000992,
        'lon': 6.3502497,
        'address': None,
        'source': 'https://www.lokalmat.no/produsenter/voss-gardsmat/',
    },
    {
        'id': 'manual_asker_gronnsletta_gard',
        'name': 'Grønnsletta Gård',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.5553052,
        'lon': 10.5049039,
        'address': None,
        'source': 'https://www.google.com/maps/place/Gr%C3%B8nnsletta+G%C3%A5rd/',
    },
    {
        'id': 'manual_asker_vaerby_gard',
        'name': 'Værby gård',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.5445009,
        'lon': 10.4801604,
        'address': None,
        'source': 'https://www.google.com/maps/place/V%C3%A6rby+g%C3%A5rd/',
    },
    {
        'id': 'manual_asker_bergsmyrene',
        'name': 'Bergsmyrene',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.5502616,
        'lon': 10.4556426,
        'address': None,
        'source': 'https://www.google.com/maps/place/Bergsmyrene/',
    },
    {
        'id': 'manual_asker_biffgarden',
        'name': 'Biffgården',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.538206,
        'lon': 10.4433703,
        'address': None,
        'source': 'https://www.google.com/maps/place/Biffg%C3%A5rden/',
    },
    {
        'id': 'manual_asker_thor_graff',
        'name': 'Thor Graff',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.7301368,
        'lon': 10.4432877,
        'address': None,
        'source': 'https://www.google.com/maps/place/Thor+Graff/',
    },
    {
        'id': 'manual_asker_hyggen_eplemost',
        'name': 'Hyggen eplemost',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.7148197,
        'lon': 10.3500528,
        'address': None,
        'source': 'https://www.google.com/maps/place/Hyggen+eplemost/',
    },
    {
        'id': 'manual_asker_bonden_jens',
        'name': 'Bonden Jens',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.7290416,
        'lon': 10.4415312,
        'address': None,
        'source': 'https://www.google.com/maps/place/Bonden+Jens/',
    },
    {
        'id': 'manual_asker_nedre_gjerdal',
        'name': 'Jordbær fra Nedre Gjerdal Gård',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.7461658,
        'lon': 10.434421,
        'address': None,
        'source': 'https://www.google.com/maps/place/Jordb%C3%A6r+fra+Nedre+Gjerdal+G%C3%A5rd/',
    },
    {
        'id': 'manual_asker_hurum_hjort',
        'name': 'Hurum hjort',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.594239,
        'lon': 10.6028242,
        'address': None,
        'source': 'https://www.google.com/maps/place/Hurum+hjort/',
    },
    {
        'id': 'manual_asker_eplegarden_as',
        'name': 'Eplegården AS',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.6498675,
        'lon': 10.5972649,
        'address': None,
        'source': 'https://www.google.com/maps/place/Epleg%C3%A5rden+AS/',
    },
    {
        'id': 'manual_asker_bryggerhuset_frotvedt',
        'name': 'Bryggerhuset på Frøtvedt',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.710323,
        'lon': 10.4954476,
        'address': None,
        'source': 'https://www.google.com/maps/place/Bryggerhuset+p%C3%A5+Fr%C3%B8tvedt/',
    },
    {
        'id': 'manual_asker_aaby_gard',
        'name': 'Aaby Gård',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.8208933,
        'lon': 10.4644799,
        'address': None,
        'source': 'https://www.google.com/maps/place/Aaby+G%C3%A5rd/',
    },
    {
        'id': 'manual_asker_grisehuset_gardsutsalg',
        'name': 'Grisehuset gårdsutsalg',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.8262596,
        'lon': 10.4794243,
        'address': None,
        'source': 'https://www.google.com/maps/place/Grisehuset+g%C3%A5rdsutsalg/',
    },
    {
        'id': 'manual_asker_sand_gard',
        'name': 'Sand Gård',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.5636043,
        'lon': 10.4641891,
        'address': None,
        'source': 'https://www.google.com/maps/place/Sand+G%C3%A5rd/',
    },
    {
        'id': 'manual_asker_vinnulstad_gard',
        'name': 'Vinnulstad Gård',
        'country': 'Norway',
        'region': 'Akershus',
        'municipality': 'Asker',
        'products': [],
        'website': None,
        'lat': 59.8016602,
        'lon': 10.4261885,
        'address': None,
        'source': 'https://www.google.com/maps/place/Vinnulstad+G%C3%A5rd/',
    },
]

ITALY_MANUAL_SEEDS = [
    {
        'id': 'manual_it_issue_47_podere_il_casale',
        'name': 'Podere Il Casale',
        'country': 'Italy',
        'region': 'Toscana',
        'municipality': 'Siena',
        'products': [],
        'website': None,
        'lat': 43.0808567,
        'lon': 11.711632,
        'address': None,
        'source': 'https://github.com/Einars-Apps/Matsjekk/issues/47',
    },
    {
        'id': 'manual_it_issue_48_bottega_poggio_stenti',
        'name': 'Bottega Poggio Stenti',
        'country': 'Italy',
        'region': 'Toscana',
        'municipality': 'Siena',
        'products': [],
        'website': None,
        'lat': 42.9656985,
        'lon': 11.4266678,
        'address': None,
        'source': 'https://github.com/Einars-Apps/Matsjekk/issues/48',
    },
    {
        'id': 'manual_it_issue_49_consorzio_agrario_siena',
        'name': 'Consorzio Agrario',
        'country': 'Italy',
        'region': 'Toscana',
        'municipality': 'Siena',
        'products': [],
        'website': None,
        'lat': 43.3212108,
        'lon': 11.3299305,
        'address': None,
        'source': 'https://github.com/Einars-Apps/Matsjekk/issues/49',
    },
]

HANEN_MAP_API_URL = 'https://kart.hanen.no/api/kart/data'
HANEN_CATEGORY_TEXT_RE = re.compile(r'gårdsbutikk|gardsbutikk|gårdsutsalg|gardsutsalg', re.I)


def country_specific_overpass_clauses(cc):
    keyword = COUNTRY_KEYWORD_REGEX.get(cc)
    if not keyword:
        return ''

    return f"""
    node["name"~"{keyword}",i](area.searchArea);
    way["name"~"{keyword}",i](area.searchArea);
    relation["name"~"{keyword}",i](area.searchArea);
    node["description"~"{keyword}",i](area.searchArea);
    way["description"~"{keyword}",i](area.searchArea);
    relation["description"~"{keyword}",i](area.searchArea);
"""


def build_zero_hit_query(cc):
    keyword = COUNTRY_KEYWORD_REGEX.get(cc)
    if not keyword:
        return ''

    return f"""
[out:json][timeout:60];
area["ISO3166-1"="{cc}"]->.searchArea;
(
    node["name"~"{keyword}",i](area.searchArea);
    way["name"~"{keyword}",i](area.searchArea);
    relation["name"~"{keyword}",i](area.searchArea);
    node["description"~"{keyword}",i](area.searchArea);
    way["description"~"{keyword}",i](area.searchArea);
    relation["description"~"{keyword}",i](area.searchArea);
    node["operator"~"{keyword}",i](area.searchArea);
    way["operator"~"{keyword}",i](area.searchArea);
    relation["operator"~"{keyword}",i](area.searchArea);
    node["brand"~"{keyword}",i](area.searchArea);
    way["brand"~"{keyword}",i](area.searchArea);
    relation["brand"~"{keyword}",i](area.searchArea);
);
out center;"""


def build_zero_hit_queries(cc):
    keyword = COUNTRY_KEYWORD_REGEX.get(cc)
    if not keyword:
        return []

    queries = []
    for field in ('name', 'description', 'operator', 'brand'):
        queries.append(
            f"""
[out:json][timeout:60];
area["ISO3166-1"="{cc}"][admin_level=2]->.searchArea;
(
    node["{field}"~"{keyword}",i](area.searchArea);
    way["{field}"~"{keyword}",i](area.searchArea);
    relation["{field}"~"{keyword}",i](area.searchArea);
);
out center;"""
        )
    return queries

def build_query(cc):
    # Primary query: keep it light to reduce timeouts on large countries.
    return f"""
[out:json][timeout:60];
area["ISO3166-1"="{cc}"][admin_level=2]->.searchArea;
(
    node["shop"~"farm|farm_shop"](area.searchArea);
    way["shop"~"farm|farm_shop"](area.searchArea);
    relation["shop"~"farm|farm_shop"](area.searchArea);
    node["produce"](area.searchArea);
    way["produce"](area.searchArea);
    relation["produce"](area.searchArea);
);
out center;"""


def build_relief_queries(cc):
    if cc not in {'DE', 'FR'}:
        return []

    return [
        f"""
[out:json][timeout:60];
area["ISO3166-1"="{cc}"][admin_level=2]->.searchArea;
(
    node["shop"~"farm|farm_shop"](area.searchArea);
    node["produce"](area.searchArea);
);
out center 5000;""",
        f"""
[out:json][timeout:60];
area["ISO3166-1"="{cc}"][admin_level=2]->.searchArea;
(
    way["shop"~"farm|farm_shop"](area.searchArea);
    relation["shop"~"farm|farm_shop"](area.searchArea);
    way["produce"](area.searchArea);
    relation["produce"](area.searchArea);
);
out center 5000;""",
    ]


def normalize_token(value):
    return (value or '').strip().lower()


def selected_countries():
    raw = os.getenv('FARMSHOP_COUNTRIES', '').strip()
    if not raw:
        return list(COUNTRIES.items())

    requested = [token.strip() for token in raw.split(',') if token.strip()]
    selected_codes = set()
    for token in requested:
        upper = token.upper()
        if upper in COUNTRY_NAME_BY_CODE:
            selected_codes.add(upper)
            continue
        token_norm = normalize_token(token)
        match = next((code for name, code in COUNTRIES.items() if normalize_token(name) == token_norm), None)
        if match:
            selected_codes.add(match)

    if not selected_codes:
        return list(COUNTRIES.items())

    return [(COUNTRY_NAME_BY_CODE[code], code) for code in COUNTRY_NAME_BY_CODE if code in selected_codes]


def load_previous_items_by_code():
    if not OUT_FILE.exists():
        return {}
    try:
        payload = json.loads(OUT_FILE.read_text(encoding='utf-8'))
    except Exception:
        return {}

    grouped = {}
    for item in payload if isinstance(payload, list) else []:
        country_name = (item.get('country') or '').strip()
        code = COUNTRIES.get(country_name)
        if not code:
            continue
        grouped.setdefault(code, []).append(item)
    return grouped


def load_archive_items_by_code():
    if not ARCHIVE_FILE.exists():
        return {}
    try:
        payload = json.loads(ARCHIVE_FILE.read_text(encoding='utf-8'))
    except Exception:
        return {}

    grouped = {}
    if isinstance(payload, dict):
        for code, items in payload.items():
            if code not in COUNTRY_NAME_BY_CODE:
                continue
            if isinstance(items, list):
                expected_country_name = COUNTRY_NAME_BY_CODE[code]
                grouped[code] = [
                    item for item in items
                    if isinstance(item, dict) and (item.get('country') or '').strip() == expected_country_name
                ]
    return grouped


def save_archive_items_by_code(grouped):
    ARCHIVE_FILE.parent.mkdir(parents=True, exist_ok=True)
    serializable = {
        code: dedupe(items)[:MAX_ARCHIVE_ITEMS_PER_COUNTRY]
        for code, items in grouped.items()
        if code in COUNTRY_NAME_BY_CODE and isinstance(items, list)
    }
    ARCHIVE_FILE.write_text(json.dumps(serializable, ensure_ascii=False, indent=2), encoding='utf-8')

def extract_elem(e):
    tags = e.get('tags', {})
    lat = e.get('lat') or (e.get('center') and e['center'].get('lat'))
    lon = e.get('lon') or (e.get('center') and e['center'].get('lon'))
    shop_tag = (tags.get('shop') or '').strip().lower()
    amenity_tag = (tags.get('amenity') or '').strip().lower()
    produce_tag = (tags.get('produce') or '').strip().lower()

    name = tags.get('name')
    if not name:
        named_hints = [
            tags.get('official_name'),
            tags.get('brand'),
            tags.get('operator'),
            tags.get('contact:company'),
            tags.get('addr:housename'),
        ]
        named_hints = [value.strip() for value in named_hints if isinstance(value, str) and value.strip()]

        if named_hints:
            name = named_hints[0]

    return {
        'id': e.get('id'),
        'name': name,
        'country': tags.get('addr:country') or None,
        'region': tags.get('addr:state') or tags.get('region') or None,
        'municipality': tags.get('addr:city') or tags.get('addr:municipality') or None,
        'products': tags.get('products','').split(';') if tags.get('products') else [],
        'website': tags.get('website') or tags.get('contact:website') or None,
        'lat': lat,
        'lon': lon,
        'address': tags.get('addr:street') or None,
    }


def _post_overpass(endpoint, query):
    try:
        response = SESSION.post(
            endpoint,
            data={'data': query},
            timeout=REQUEST_TIMEOUT,
        )
    except (requests.Timeout, requests.ConnectionError) as error:
        raise OverpassUnavailable(
            f'{endpoint}: {error}',
            CONNECT_FAILURE_COOLDOWN_SECONDS,
        ) from error

    if response.status_code in (429, 503, 406):
        hinted = _retry_after_seconds(response)
        cooldown = max(hinted, RATE_LIMIT_COOLDOWN_SECONDS)
        raise OverpassUnavailable(
            f'{response.status_code} from {endpoint}',
            cooldown,
        )

    response.raise_for_status()

    content_type = (response.headers.get('content-type') or '').lower()
    if 'json' not in content_type:
        snippet = (response.text or '')[:200].replace('\n', ' ')
        raise RuntimeError(f'Non-JSON Overpass response from {endpoint}: {snippet}')

    payload = response.json()
    if not isinstance(payload, dict):
        raise RuntimeError(f'Invalid Overpass payload type from {endpoint}: {type(payload)}')

    elements = payload.get('elements', [])
    if not isinstance(elements, list):
        raise RuntimeError(f'Invalid Overpass elements payload from {endpoint}')

    remark = (payload.get('remark') or '').strip()
    if remark:
        lowered = remark.lower()
        severe = (
            'timeout' in lowered
            or 'timed out' in lowered
            or 'runtime error' in lowered
            or 'too many requests' in lowered
            or 'rate limit' in lowered
            or 'quota' in lowered
            or 'busy' in lowered
        )
        if severe and not elements:
            message = f'Overpass remark from {endpoint}: {remark}'
            rate_limited = any(
                token in lowered
                for token in ('too many requests', 'rate limit', 'quota', 'busy')
            )
            if rate_limited:
                raise OverpassUnavailable(message, RATE_LIMIT_COOLDOWN_SECONDS)
            raise RuntimeError(message)

    return elements


def _fetch_overpass_filtered(query, cc):
    _ensure_deadline()
    if _past_deadline():
        raise FetchDeadlineReached(f'Fetch deadline reached before querying {cc}')

    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        if _past_deadline():
            raise FetchDeadlineReached(f'Fetch deadline reached while querying {cc}')

        available = [endpoint for endpoint in OVERPASS_ENDPOINTS if _endpoint_available(endpoint)]
        if not available:
            break

        for endpoint in available:
            try:
                elements = _post_overpass(endpoint, query)
                print(f'  OK {cc} via {endpoint} on attempt {attempt}')
                out = []
                for e in elements:
                    item = extract_elem(e)
                    if item['name'] and item['lat'] and item['lon']:
                        out.append(item)
                return out
            except OverpassUnavailable as error:
                last_error = error
                _disable_endpoint(endpoint, error.cooldown_seconds)
                print(
                    f'  SKIP {cc} via {endpoint} for {error.cooldown_seconds}s ({error})',
                    file=sys.stderr,
                )
            except Exception as error:
                last_error = error
                print(f'  RETRY {cc} via {endpoint} failed ({error})', file=sys.stderr)

        if attempt < MAX_RETRIES and any(_endpoint_available(endpoint) for endpoint in OVERPASS_ENDPOINTS):
            time.sleep(BASE_BACKOFF_SECONDS)

    raise RuntimeError(f'All endpoints failed for {cc}: {last_error}')


def fetch_for_country(cc):
    print('Querying', cc)

    relief_collected = []
    for idx, query in enumerate(build_relief_queries(cc), start=1):
        print(f'  RELIEF query tier {idx} for {cc}')
        try:
            tier_items = _fetch_overpass_filtered(query, cc)
        except FetchDeadlineReached:
            raise
        except Exception as error:
            print(f'  Relief tier {idx} failed for {cc}: {error}', file=sys.stderr)
            continue
        if tier_items:
            relief_collected = dedupe(relief_collected + tier_items)

    if relief_collected:
        return relief_collected

    primary = _fetch_overpass_filtered(build_query(cc), cc)
    if primary:
        return primary

    # Keep legacy combined fallback query as a first backup.
    secondary_query = build_zero_hit_query(cc)
    if secondary_query:
        print(f'  ZERO-HIT fallback query (combined) for {cc}')
        try:
            secondary = _fetch_overpass_filtered(secondary_query, cc)
            if secondary:
                return secondary
        except FetchDeadlineReached:
            raise
        except Exception as error:
            print(f'  Combined fallback failed for {cc}: {error}', file=sys.stderr)

    # Tiered fallback queries: smaller query blocks are more resilient on large countries.
    collected = []
    for idx, query in enumerate(build_zero_hit_queries(cc), start=1):
        print(f'  ZERO-HIT fallback query tier {idx} for {cc}')
        try:
            tier_items = _fetch_overpass_filtered(query, cc)
        except FetchDeadlineReached:
            raise
        except Exception as error:
            print(f'  Tier {idx} failed for {cc}: {error}', file=sys.stderr)
            continue

        if tier_items:
            collected = dedupe(collected + tier_items)
            if len(collected) >= 30:
                break

    if collected:
        return collected

    return primary


def tag_country(items, country_name):
    out = []
    for item in items:
        tagged = dict(item)
        tagged['country'] = country_name
        out.append(tagged)
    return out


def dedupe(items):
    seen = set()
    out = []
    for item in items:
        key = (item.get('name', '').strip().lower(), item.get('lat'), item.get('lon'))
        if key in seen:
            continue
        seen.add(key)
        out.append(item)
    return out


def _normalized_name(value):
    return (value or '').strip().lower()


def _norway_normalize_municipality(value):
    raw = (value or '').strip()
    if not raw:
        return None
    return NORWAY_MUNICIPALITY_ALIASES.get(raw.lower(), raw)


def _item_identity_key(item):
    name = _normalized_name(item.get('name'))
    lat = _to_float_or_none(item.get('lat'))
    lon = _to_float_or_none(item.get('lon'))
    if lat is None or lon is None:
        return (name, None, None)
    return (name, round(lat, 5), round(lon, 5))


def _is_locked_norway_municipality(value):
    if not value:
        return False
    normalized = _norway_normalize_municipality(value)
    if not normalized:
        return False
    return normalized.lower() in {m.lower() for m in NORWAY_LOCKED_MUNICIPALITIES}


def _normalize_norway_municipalities(items):
    normalized = []
    for item in items:
        out = dict(item)
        out['municipality'] = _norway_normalize_municipality(out.get('municipality'))
        normalized.append(out)
    return normalized


def _apply_norway_name_overrides(items):
    adjusted = []
    for item in items:
        out = dict(item)
        key = _normalized_name(out.get('name'))
        override = NORWAY_NAME_OVERRIDES.get(key)
        if override:
            out['municipality'] = override.get('municipality')
            if override.get('region'):
                out['region'] = override.get('region')
            if override.get('name'):
                out['name'] = override.get('name')
        adjusted.append(out)
    return adjusted


def _cleanup_norway_noise(items):
    cleaned = []
    seen_asker_names = set()
    for item in items:
        name = (item.get('name') or '').strip()
        municipality = (item.get('municipality') or '').strip()
        name_key = _normalized_name(name)

        # Drop synthetic placeholders from earlier runs.
        if name.lower().startswith('farm shop '):
            continue

        # Keep Asker strict: only retain explicitly approved records.
        if municipality == 'Asker' and name_key not in NORWAY_ASKER_ALLOWED_NAMES:
            continue

        # Keep one entry per Asker place-name.
        if municipality == 'Asker':
            if name_key in seen_asker_names:
                continue
            seen_asker_names.add(name_key)

        cleaned.append(item)
    return cleaned


def _apply_norway_municipality_policy(current_items, previous_items, archive_items):
    current = _apply_norway_name_overrides(_normalize_norway_municipalities(current_items))
    previous = _normalize_norway_municipalities(previous_items)
    archive = _normalize_norway_municipalities(archive_items)

    # Lock selected municipality assignments by carrying forward known-good metadata.
    locked_metadata = {}
    locked_seed_items = []
    for source in (previous, archive):
        for item in source:
            municipality = item.get('municipality')
            if not _is_locked_norway_municipality(municipality):
                continue
            key = _item_identity_key(item)
            locked_metadata[key] = {
                'municipality': municipality,
                'region': item.get('region'),
            }
            locked_seed_items.append(item)

    for item in current:
        key = _item_identity_key(item)
        locked = locked_metadata.get(key)
        if not locked:
            continue
        item['municipality'] = locked.get('municipality')
        # Keep previous region if current entry has no region.
        if not item.get('region') and locked.get('region'):
            item['region'] = locked.get('region')

    # Ensure locked municipality items are preserved in final output.
    merged = dedupe(current + locked_seed_items + NORWAY_MANUAL_SEEDS)
    merged = _normalize_norway_municipalities(merged)
    merged = _apply_norway_name_overrides(merged)
    return _cleanup_norway_noise(merged)


def _apply_italy_submission_seeds(items):
    return dedupe(items + ITALY_MANUAL_SEEDS)


def split_by_country_code(items):
    grouped = {}
    for item in items:
        cc = COUNTRIES.get((item.get('country') or '').strip())
        if not cc:
            continue
        grouped.setdefault(cc, []).append(item)
    return {cc: dedupe(group) for cc, group in grouped.items()}


def write_country_slices(items):
    grouped = split_by_country_code(items)
    OUT_BY_COUNTRY_DIR.mkdir(parents=True, exist_ok=True)

    expected_codes = set(COUNTRY_NAME_BY_CODE.keys())
    for existing in OUT_BY_COUNTRY_DIR.glob('*.json'):
        if existing.stem.upper() not in expected_codes:
            continue
        try:
            existing.unlink()
        except OSError:
            pass

    for cc in sorted(expected_codes):
        path = OUT_BY_COUNTRY_DIR / f'{cc.lower()}.json'
        payload = grouped.get(cc, [])
        path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding='utf-8')

    summary = ', '.join([f'{cc}:{len(grouped.get(cc, []))}' for cc in sorted(expected_codes)])
    print('Wrote country slices:', summary)


def _looks_valid_coordinate(value):
    try:
        parsed = float(value)
    except (TypeError, ValueError):
        return False
    return parsed != 0.0


def _to_float_or_none(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _normalize_url(value):
    raw = (value or '').strip()
    if not raw:
        return None
    parsed = urlparse(raw)
    if parsed.scheme:
        return raw
    return f'https://{raw}'


def _extract_county_name(county):
    if isinstance(county, dict):
        return (county.get('name') or '').strip() or None
    if isinstance(county, str):
        return county.strip() or None
    return None


def _extract_products(record):
    products = []
    for category in record.get('productCategoriesData') or []:
        if not isinstance(category, dict):
            continue
        attributes = category.get('attributes') or {}
        name = (attributes.get('name') or '').strip()
        if name:
            products.append(name)
    return products


def _page_fingerprint(data):
    first = data[0].get('id') if isinstance(data[0], dict) else None
    last = data[-1].get('id') if isinstance(data[-1], dict) else None
    return (first, last, len(data))


def _collect_paged_records(fetch_page, max_pages):
    """Collect pages until the API ends, repeats a page, or max_pages is hit."""
    records = []
    page = 0
    total_count = None
    seen = set()
    while page < max_pages:
        if _past_deadline():
            print('  Stopping pagination: fetch deadline reached', file=sys.stderr)
            break
        data, count = fetch_page(page)
        if total_count is None and isinstance(count, int) and count > 0:
            total_count = count
        if not data:
            break
        fingerprint = _page_fingerprint(data)
        if fingerprint in seen:
            print(f'  Stopping pagination: repeated page {page}', file=sys.stderr)
            break
        seen.add(fingerprint)
        records.extend(data)
        if total_count is not None and len(records) >= total_count:
            break
        page += 1
        time.sleep(0.1)
    if page >= max_pages and (total_count is None or len(records) < total_count):
        print(f'  Stopping pagination: reached max pages ({max_pages})', file=sys.stderr)
    return records


def _fetch_lokalmat_page(mode, page):
    params = {
        'mode': mode,
        'page': page,
        'size': LOKALMAT_PAGE_SIZE,
        'orderBy': 'displayName',
        'status[0]': 'approved',
    }
    response = SESSION.get(LOKALMAT_API_BASE, params=params, timeout=REQUEST_TIMEOUT)
    response.raise_for_status()
    payload = response.json()
    result = payload.get('result') if isinstance(payload, dict) else None
    if not isinstance(result, dict):
        return [], 0

    data = result.get('data')
    count = result.get('count')
    if not isinstance(data, list):
        data = []
    if not isinstance(count, int):
        count = 0
    return data, count


def _fetch_all_lokalmat_records(mode):
    return _collect_paged_records(
        lambda page: _fetch_lokalmat_page(mode, page),
        LOKALMAT_MAX_PAGES,
    )


def fetch_lokalmat_producers():
    print('Fetching Lokalmat producers via API')
    list_records = _fetch_all_lokalmat_records(LOKALMAT_MODE_LIST)
    map_records = _fetch_all_lokalmat_records(LOKALMAT_MODE_MAP)

    list_by_id = {}
    for record in list_records:
        producer_id = record.get('id')
        if producer_id is not None:
            list_by_id[producer_id] = record

    map_by_id = {}
    for record in map_records:
        producer_id = record.get('id')
        if producer_id is not None:
            map_by_id[producer_id] = record

    merged = []
    for producer_id, list_record in list_by_id.items():
        map_record = map_by_id.get(producer_id, {})
        name = (list_record.get('displayName') or map_record.get('displayName') or '').strip()
        if not name:
            continue

        latitude = map_record.get('latitude')
        longitude = map_record.get('longitude')
        if not (_looks_valid_coordinate(latitude) and _looks_valid_coordinate(longitude)):
            continue

        visiting_address = list_record.get('addressVisiting') or {}
        if not isinstance(visiting_address, dict):
            visiting_address = {}

        addresses = visiting_address.get('addresses') or []
        address = addresses[0] if isinstance(addresses, list) and addresses else None
        municipality = (visiting_address.get('postalPlace') or '').strip() or None
        county = _extract_county_name(list_record.get('county'))
        slug = (list_record.get('slug') or map_record.get('slug') or '').strip()

        merged.append({
            'id': f'lokalmat_{producer_id}',
            'name': name,
            'country': 'Norway',
            'region': county,
            'municipality': municipality,
            'products': _extract_products(list_record),
            'website': _normalize_url(list_record.get('website')),
            'lat': _to_float_or_none(latitude),
            'lon': _to_float_or_none(longitude),
            'address': address,
            'source': f'https://www.lokalmat.no/produsenter/{slug}/' if slug else None,
        })

    print(f'Fetched {len(merged)} Lokalmat producers with coordinates')
    return merged


def fetch_hanen_gardsbutikker():
    print('Fetching Hanen gardsbutikker via map API')
    response = SESSION.get(
        HANEN_MAP_API_URL,
        timeout=REQUEST_TIMEOUT,
        headers={'User-Agent': 'mat-sjekk-bot/1.0'},
    )
    response.raise_for_status()
    payload = response.json()
    if not isinstance(payload, list):
        return []

    items = []
    for row in payload:
        if not isinstance(row, dict):
            continue

        name = (row.get('name') or row.get('view_name') or '').strip()
        if not name:
            continue

        text_blob = ' '.join([
            name,
            row.get('introduction') or '',
            row.get('html') or '',
        ])
        if not HANEN_CATEGORY_TEXT_RE.search(text_blob):
            continue

        lat = _to_float_or_none(row.get('latitude'))
        lon = _to_float_or_none(row.get('longitude'))
        if not (_looks_valid_coordinate(lat) and _looks_valid_coordinate(lon)):
            continue

        post_url = (row.get('post_url') or '').strip().strip('/')
        source_url = f'https://www.hanen.no/bedrift/{post_url}/' if post_url else None

        items.append({
            'id': f'hanen_{row.get("id")}',
            'name': name,
            'country': 'Norway',
            'region': (row.get('county') or '').strip() or None,
            'municipality': (row.get('shipping_city') or '').strip() or None,
            'products': [],
            'website': _normalize_url(row.get('website')),
            'lat': lat,
            'lon': lon,
            'address': (row.get('shipping_street') or '').strip() or None,
            'source': source_url,
        })

    print(f'Fetched {len(items)} Hanen gardsbutikker with coordinates')
    return items

def _stored_country_items(cc, previous_by_code, archive_by_code, failed_countries, country_name, reason):
    print(f'{reason} for {country_name}', file=sys.stderr)
    fallback_items = previous_by_code.get(cc, [])
    if fallback_items:
        print(f'  Using fallback from previous dataset for {country_name}: {len(fallback_items)} items')
        archive_by_code[cc] = dedupe(archive_by_code.get(cc, []) + fallback_items)
        failed_countries.append(country_name)
        return fallback_items
    archived = dedupe(archive_by_code.get(cc, []))
    if archived:
        print(f'  Using fallback from archive for {country_name}: {len(archived)} items')
        failed_countries.append(country_name)
        return archived
    failed_countries.append(country_name)
    return []


def main():
    _reset_fetch_runtime_state()
    _ensure_deadline()
    previous_by_code = load_previous_items_by_code()
    archive_by_code = load_archive_items_by_code()
    country_list = selected_countries()

    print('Countries selected:', ', '.join([f'{name}({code})' for name, code in country_list]))

    lokalmat_items = []
    hanen_items = []
    if any(cc == 'NO' for _, cc in country_list):
        try:
            lokalmat_items = fetch_lokalmat_producers()
        except Exception as error:
            print(f'Failed to fetch Lokalmat producers: {error}', file=sys.stderr)
        try:
            hanen_items = fetch_hanen_gardsbutikker()
        except Exception as error:
            print(f'Failed to fetch Hanen gardsbutikker: {error}', file=sys.stderr)

    all_items = []
    failed_countries = []
    preserved_countries = []
    restored_from_archive = []
    deadline_hit = False
    for name, cc in country_list:
        if deadline_hit or _past_deadline():
            deadline_hit = True
            all_items.extend(_stored_country_items(
                cc,
                previous_by_code,
                archive_by_code,
                failed_countries,
                name,
                'Fetch deadline reached',
            ))
            continue
        try:
            items = fetch_for_country(cc)
            tagged_current = tag_country(items, name)
            if cc == 'NO' and lokalmat_items:
                tagged_current = dedupe(tagged_current + lokalmat_items)
            if cc == 'NO' and hanen_items:
                tagged_current = dedupe(tagged_current + hanen_items)
            previous_items = previous_by_code.get(cc, [])
            archive_items = archive_by_code.get(cc, [])
            if previous_items:
                merged_country_items = dedupe(tagged_current + previous_items)
                if len(merged_country_items) > len(tagged_current):
                    preserved_countries.append((name, len(tagged_current), len(merged_country_items)))
                if archive_items:
                    merged_country_items = dedupe(merged_country_items + archive_items)
                if cc == 'NO':
                    merged_country_items = _apply_norway_municipality_policy(
                        merged_country_items,
                        previous_items,
                        archive_items,
                    )
                if cc == 'IT':
                    merged_country_items = _apply_italy_submission_seeds(merged_country_items)
                all_items.extend(merged_country_items)
            else:
                merged_country_items = dedupe(tagged_current + archive_items) if archive_items else tagged_current
                if archive_items and len(merged_country_items) > len(tagged_current):
                    restored_from_archive.append((name, len(tagged_current), len(merged_country_items)))
                if cc == 'NO':
                    merged_country_items = _apply_norway_municipality_policy(
                        merged_country_items,
                        previous_items,
                        archive_items,
                    )
                if cc == 'IT':
                    merged_country_items = _apply_italy_submission_seeds(merged_country_items)
                all_items.extend(merged_country_items)

            archive_by_code[cc] = dedupe(archive_by_code.get(cc, []) + merged_country_items)
        except FetchDeadlineReached as error:
            print(error, file=sys.stderr)
            deadline_hit = True
            all_items.extend(_stored_country_items(
                cc,
                previous_by_code,
                archive_by_code,
                failed_countries,
                name,
                'Fetch deadline reached',
            ))
            continue
        except Exception as e:
            print('Error fetching', name, e, file=sys.stderr)
            all_items.extend(_stored_country_items(
                cc,
                previous_by_code,
                archive_by_code,
                failed_countries,
                name,
                'Fetch failed',
            ))

        time.sleep(1.2 + random.uniform(0.0, 0.6))

    all_items = dedupe(all_items)
    print('Fetched', len(all_items), 'items')
    if preserved_countries:
        summary = ', '.join([f'{name}({current}->{merged})' for name, current, merged in preserved_countries])
        print('Countries merged with previous dataset to preserve known hits:', summary)
    if restored_from_archive:
        summary = ', '.join([f'{name}({current}->{merged})' for name, current, merged in restored_from_archive])
        print('Countries restored using long-term archive:', summary)
    if failed_countries:
        print('Countries with fetch failures (fallback used when available):', ', '.join(failed_countries), file=sys.stderr)
    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(all_items, f, ensure_ascii=False, indent=2)
    write_country_slices(all_items)
    save_archive_items_by_code(archive_by_code)
    print('Wrote', OUT_FILE)

if __name__ == '__main__':
    main()
