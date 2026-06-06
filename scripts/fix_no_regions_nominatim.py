"""
Phase 2: Fill remaining NULL-region entries via Nominatim reverse geocoding.
Static fixes (old names, casing, postal codes) were already applied by fix_no_regions.py.
"""
import json
import time
import urllib.request

def nominatim_region(lat, lon):
    url = (f"https://nominatim.openstreetmap.org/reverse?"
           f"lat={lat}&lon={lon}&zoom=8&addressdetails=1&format=json")
    req = urllib.request.Request(url, headers={'User-Agent': 'mat_sjekk-cleanup/1.0'})
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read())
        addr = data.get('address', {})
        county = addr.get('county') or addr.get('state') or ''
        VALID_REGIONS = {
            'Oslo', 'Innlandet', 'Akershus', 'Buskerud', 'Østfold',
            'Telemark', 'Vestfold', 'Agder', 'Rogaland', 'Vestland',
            'Møre og Romsdal', 'Trøndelag', 'Nordland', 'Troms', 'Finnmark',
        }
        for r in VALID_REGIONS:
            if r.lower() in county.lower():
                return r
        return None
    except Exception:
        return None

fpath = 'docs/data/farmshops_by_country/no.json'
with open(fpath, encoding='utf-8') as f:
    data = json.load(f)

no_region = [i for i in data if not i.get('region') and i.get('lat')]
print(f'Entries needing Nominatim: {len(no_region)}')

fixed = 0
failed = 0
for i, item in enumerate(no_region):
    region = nominatim_region(item['lat'], item['lon'])
    if region:
        item['region'] = region
        fixed += 1
        print(f'  [{i+1}/{len(no_region)}] {item["id"]}: {item["name"][:40]} → {region}')
    else:
        failed += 1
        print(f'  [{i+1}/{len(no_region)}] {item["id"]}: {item["name"][:40]} → FAILED (lat={item["lat"]}, lon={item["lon"]})')
    time.sleep(1.1)

print(f'\nFixed: {fixed}, Failed: {failed}')

with open(fpath, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
print('Saved.')
