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

OVERPASS_ENDPOINTS = [
    'https://overpass-api.de/api/interpreter',
    'https://lz4.overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
]

MAX_RETRIES = 4
BASE_BACKOFF_SECONDS = 2.0
REQUEST_TIMEOUT_SECONDS = 180

COUNTRY_NAME_BY_CODE = {code: name for name, code in COUNTRIES.items()}

def build_query(cc):
    # Query nodes/ways/relations with farmshop-like tags.
    return f"""
[out:json][timeout:60];
area["ISO3166-1"="{cc}"]->.searchArea;
(
    node[shop~"farm|farm_shop|greengrocer|organic"](area.searchArea);
    way[shop~"farm|farm_shop|greengrocer|organic"](area.searchArea);
    relation[shop~"farm|farm_shop|greengrocer|organic"](area.searchArea);
  node["shop"="farm"](area.searchArea);
  way["shop"="farm"](area.searchArea);
    relation["shop"="farm"](area.searchArea);
    node["amenity"="marketplace"](area.searchArea);
    way["amenity"="marketplace"](area.searchArea);
    relation["amenity"="marketplace"](area.searchArea);
);
out center;"""


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

def extract_elem(e):
    tags = e.get('tags', {})
    lat = e.get('lat') or (e.get('center') and e['center'].get('lat'))
    lon = e.get('lon') or (e.get('center') and e['center'].get('lon'))
    return {
        'id': e.get('id'),
        'name': tags.get('name'),
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
    payload = response.json()
    return payload.get('elements', []) if isinstance(payload, dict) else []


def fetch_for_country(cc):
    q = build_query(cc)
    print('Querying', cc)

    last_error = None
    for attempt in range(1, MAX_RETRIES + 1):
        for endpoint in OVERPASS_ENDPOINTS:
            try:
                elements = _post_overpass(endpoint, q)
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
    country_list = selected_countries()

    print('Countries selected:', ', '.join([f'{name}({code})' for name, code in country_list]))

    all_items = []
    failed_countries = []
    for name, cc in country_list:
        try:
            items = fetch_for_country(cc)
            all_items.extend(tag_country(items, name))
        except Exception as e:
            print('Error fetching', name, e, file=sys.stderr)
            fallback_items = previous_by_code.get(cc, [])
            if fallback_items:
                print(f'  Using fallback from previous dataset for {name}: {len(fallback_items)} items')
                all_items.extend(fallback_items)
            failed_countries.append(name)

        time.sleep(1.2 + random.uniform(0.0, 0.6))

    all_items = dedupe(all_items)
    print('Fetched', len(all_items), 'items')
    if failed_countries:
        print('Countries with fetch failures (fallback used when available):', ', '.join(failed_countries), file=sys.stderr)
    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(all_items, f, ensure_ascii=False, indent=2)
    print('Wrote', OUT_FILE)

if __name__ == '__main__':
    main()
