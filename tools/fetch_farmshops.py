#!/usr/bin/env python3
"""Fetch farm shop POIs from OpenStreetMap (Overpass) and write JSON feed.

Resilience features:
- retries with exponential backoff
- multiple Overpass endpoints
- fallback to last successful country slice from existing output
- optional country subset via FARMSHOP_COUNTRIES env (codes or names, comma separated)
"""
import json
import os
import random
import sys
import time
from pathlib import Path

import requests

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
ARCHIVE_FILE = ROOT / 'docs' / 'data' / 'farmshops_country_archive.json'

OVERPASS_ENDPOINTS = [
    'https://overpass-api.de/api/interpreter',
    'https://lz4.overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
]

MAX_RETRIES = 4
BASE_BACKOFF_SECONDS = 2.0
REQUEST_TIMEOUT_SECONDS = 180
MAX_ARCHIVE_ITEMS_PER_COUNTRY = 7000

COUNTRY_NAME_BY_CODE = {code: name for name, code in COUNTRIES.items()}

COUNTRY_KEYWORD_REGEX = {
    'DE': r'hofladen|bauernladen|landladen|direktvermarkt',
    'FR': r'vente directe|magasin de ferme|producteur|ferme',
    'IT': r'vendita diretta|fattoria|azienda agricola|spaccio agricolo',
    'ES': r'venta directa|tienda de granja|granja|agricola',
    'GB': r'farm shop|farmshop|farm store|pick your own',
}


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

        is_farm_like = shop_tag in {'farm', 'farm_shop', 'greengrocer', 'organic'} or bool(produce_tag)
        is_generic_market = amenity_tag == 'marketplace' and not is_farm_like

        if named_hints:
            name = named_hints[0]
        elif is_farm_like and not is_generic_market:
            place_hint = (tags.get('addr:city') or tags.get('addr:municipality') or tags.get('addr:state') or '').strip()
            base = 'Farm shop'
            name = f'{base} {place_hint}'.strip() if place_hint else f'{base} {e.get("id")}'

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
    response = requests.post(
        endpoint,
        data={'data': query},
        timeout=REQUEST_TIMEOUT_SECONDS,
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
            raise RuntimeError(f'Overpass remark from {endpoint}: {remark}')

    return elements


def _fetch_overpass_filtered(query, cc):
    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        for endpoint in OVERPASS_ENDPOINTS:
            try:
                elements = _post_overpass(endpoint, query)
                print(f'  OK {cc} via {endpoint} on attempt {attempt}')
                out = []
                for e in elements:
                    item = extract_elem(e)
                    if item['name'] and item['lat'] and item['lon']:
                        out.append(item)
                return out
            except Exception as error:
                last_error = error
                print(f'  RETRY {cc} via {endpoint} failed ({error})', file=sys.stderr)

        if attempt < MAX_RETRIES:
            wait = BASE_BACKOFF_SECONDS * (2 ** (attempt - 1)) + random.uniform(0.0, 1.0)
            time.sleep(wait)

    raise RuntimeError(f'All endpoints failed for {cc}: {last_error}')


def fetch_for_country(cc):
    print('Querying', cc)

    relief_collected = []
    for idx, query in enumerate(build_relief_queries(cc), start=1):
        print(f'  RELIEF query tier {idx} for {cc}')
        try:
            tier_items = _fetch_overpass_filtered(query, cc)
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
        except Exception as error:
            print(f'  Combined fallback failed for {cc}: {error}', file=sys.stderr)

    # Tiered fallback queries: smaller query blocks are more resilient on large countries.
    collected = []
    for idx, query in enumerate(build_zero_hit_queries(cc), start=1):
        print(f'  ZERO-HIT fallback query tier {idx} for {cc}')
        try:
            tier_items = _fetch_overpass_filtered(query, cc)
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

def main():
    previous_by_code = load_previous_items_by_code()
    archive_by_code = load_archive_items_by_code()
    country_list = selected_countries()

    print('Countries selected:', ', '.join([f'{name}({code})' for name, code in country_list]))

    all_items = []
    failed_countries = []
    preserved_countries = []
    restored_from_archive = []
    for name, cc in country_list:
        try:
            items = fetch_for_country(cc)
            tagged_current = tag_country(items, name)
            previous_items = previous_by_code.get(cc, [])
            archive_items = archive_by_code.get(cc, [])
            if previous_items:
                merged_country_items = dedupe(tagged_current + previous_items)
                if len(merged_country_items) > len(tagged_current):
                    preserved_countries.append((name, len(tagged_current), len(merged_country_items)))
                if archive_items:
                    merged_country_items = dedupe(merged_country_items + archive_items)
                all_items.extend(merged_country_items)
            else:
                merged_country_items = dedupe(tagged_current + archive_items) if archive_items else tagged_current
                if archive_items and len(merged_country_items) > len(tagged_current):
                    restored_from_archive.append((name, len(tagged_current), len(merged_country_items)))
                all_items.extend(merged_country_items)

            archive_by_code[cc] = dedupe(archive_by_code.get(cc, []) + merged_country_items)
        except Exception as e:
            print('Error fetching', name, e, file=sys.stderr)
            fallback_items = previous_by_code.get(cc, [])
            if fallback_items:
                print(f'  Using fallback from previous dataset for {name}: {len(fallback_items)} items')
                all_items.extend(fallback_items)
                archive_by_code[cc] = dedupe(archive_by_code.get(cc, []) + fallback_items)
            elif archive_by_code.get(cc):
                archived = dedupe(archive_by_code.get(cc, []))
                print(f'  Using fallback from archive for {name}: {len(archived)} items')
                all_items.extend(archived)
            failed_countries.append(name)

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
    save_archive_items_by_code(archive_by_code)
    print('Wrote', OUT_FILE)

if __name__ == '__main__':
    main()
