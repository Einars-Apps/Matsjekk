#!/usr/bin/env python3
"""
Fetch farm shop POIs from OpenStreetMap (Overpass) for selected countries
and write a JSON file under docs/data/farmshops.json. This is a helper
script — running it is optional and may be rate-limited by Overpass.
"""
import json
import sys
import time
import requests

COUNTRIES = {
    'Norway': 'NO',
    'Sweden': 'SE',
    'Denmark': 'DK',
    'England': 'GB',
    'Netherlands': 'NL',
}

OUT_FILE = 'docs/data/farmshops.json'

def build_query(cc):
    # Query nodes/ways with shop=farm or shop=greengrocer or "farm" in name
    return f"""
[out:json][timeout:60];
area["ISO3166-1"="{cc}"]->.searchArea;
(
  node[shop~"farm|greengrocer|organic"](area.searchArea);
  way[shop~"farm|greengrocer|organic"](area.searchArea);
  node["shop"="farm"](area.searchArea);
  way["shop"="farm"](area.searchArea);
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
    print('Querying',cc)
    r = requests.post(url, data={'data': q}, timeout=120)
    r.raise_for_status()
    j = r.json()
    elements = j.get('elements', [])
    out = []
    for e in elements:
        item = extract_elem(e)
        if item['name'] and item['lat'] and item['lon']:
            # fill country code -> name map
            out.append(item)
    return out

def main():
    all_items = []
    for name,cc in COUNTRIES.items():
        try:
            items = fetch_for_country(cc)
            # set proper country name for these items
            for it in items:
                it['country'] = name
            all_items.extend(items)
        except Exception as e:
            print('Error fetching',name,e, file=sys.stderr)
        time.sleep(1)
    print('Fetched',len(all_items),'items')
    with open(OUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(all_items, f, ensure_ascii=False, indent=2)
    print('Wrote',OUT_FILE)

if __name__ == '__main__':
    main()
