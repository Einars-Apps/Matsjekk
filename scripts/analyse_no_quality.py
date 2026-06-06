"""Analyse region/municipality quality issues in no.json"""
import json
from collections import Counter

with open('docs/data/farmshops_by_country/no.json', encoding='utf-8') as f:
    data = json.load(f)

# NULL region entries - municipality distribution
nulls = [i for i in data if not i.get('region')]
muni_dist = Counter(i.get('municipality') or 'NULL' for i in nulls)
print(f'NULL region entries: {len(nulls)}')
print('Municipality distribution for NULL region:')
for m, c in muni_dist.most_common(40):
    print(f'  {c:3d}  {m}')

print()
# All municipalities - casing and cleanness issues
all_munis = Counter(i.get('municipality') or 'NULL' for i in data)
issues = [(m, c) for m, c in all_munis.items()
          if m and m != 'NULL' and (m != m.strip() or m.upper() == m)]
print(f'Municipalities with ALL-CAPS or whitespace issues: {len(issues)}')
for m, c in sorted(issues)[:40]:
    print(f'  {c:3d}  "{m}"')

print()
# Check old region names
old_names = {'Hordaland', 'Hedmark', 'Oppland', 'Akershus (old)', 'Nord-Trøndelag',
             'Sør-Trøndelag', 'Vest-Agder', 'Aust-Agder', 'Sogn og Fjordane',
             'Viken', 'Vestfold og Telemark', 'Troms og Finnmark'}
found_old = [(r, c) for r, c in Counter(i.get('region') or '' for i in data).items()
             if r in old_names]
print('Old/invalid region names still present:')
for r, c in found_old:
    print(f'  {c:3d}  {r}')
    for i in data:
        if i.get('region') == r:
            print(f'       -> {i["id"]}: {i["name"]} (muni: {i.get("municipality")})')
