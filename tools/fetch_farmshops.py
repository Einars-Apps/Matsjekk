#!/usr/bin/env python3
"""
Fetch farm shop POIs from OpenStreetMap (Overpass) for West Europe and
write JSON to docs/data/farmshops.json.
"""
import json
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
    'Luxembourg': 'LU',
}

ROOT = Path(__file__).resolve().parents[1]
OUT_FILE = ROOT / 'docs' / 'data' / 'farmshops.json'

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

def fetch_for_country(cc):
    q = build_query(cc)
    url = 'https://overpass-api.de/api/interpreter'
    print('Querying', cc)
    r = requests.post(url, data={'data': q}, timeout=180)
    r.raise_for_status()
    j = r.json()
    elements = j.get('elements', [])
    out = []
    for e in elements:
        item = extract_elem(e)
        if item['name'] and item['lat'] and item['lon']:
            out.append(item)
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
    all_items = []
    for name, cc in COUNTRIES.items():
        try:
            items = fetch_for_country(cc)
            for it in items:
                it['country'] = name
            all_items.extend(items)
        except Exception as e:
            print('Error fetching', name, e, file=sys.stderr)
        time.sleep(1.2)

    all_items = dedupe(all_items)
    print('Fetched', len(all_items), 'items')
    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(all_items, f, ensure_ascii=False, indent=2)
    print('Wrote', OUT_FILE)

if __name__ == '__main__':
    main()
