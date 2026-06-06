import json, urllib.request
with open('docs/data/farmshops_by_country/no.json', encoding='utf-8') as f:
    data = json.load(f)
sample = next(i for i in data if not i.get('region') and i.get('lat'))
print('Sample:', sample['id'], sample['name'], sample['lat'], sample['lon'])
url = (f"https://nominatim.openstreetmap.org/reverse?"
       f"lat={sample['lat']}&lon={sample['lon']}&zoom=8&addressdetails=1&format=json")
req = urllib.request.Request(url, headers={'User-Agent': 'mat_sjekk/1.0'})
with urllib.request.urlopen(req, timeout=10) as resp:
    result = json.loads(resp.read())
print(json.dumps(result.get('address'), ensure_ascii=False, indent=2))
