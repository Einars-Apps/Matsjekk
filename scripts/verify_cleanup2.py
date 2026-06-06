import json
import re

with open('scripts/no_orig_check.json', encoding='utf-8-sig') as f:
    orig = json.load(f)
with open('docs/data/farmshops_by_country/no.json', encoding='utf-8') as f:
    curr = json.load(f)

print(f'Orig: {len(orig)}, Curr: {len(curr)}, Diff: {len(orig)-len(curr)}')

orig_by_id = {str(i.get('id')): i for i in orig}
curr_by_id = {str(i.get('id')): i for i in curr}
only_orig = set(orig_by_id.keys()) - set(curr_by_id.keys())

moji_count = 0
clean_removed = []
for oid in only_orig:
    entry = orig_by_id[oid]
    if 'Ã' in json.dumps(entry, ensure_ascii=False):
        moji_count += 1
    else:
        clean_removed.append(entry)

print(f'Mojibake entries removed: {moji_count}')
print(f'Clean entries removed (cross-source dedup): {len(clean_removed)}')

# For clean-removed, check if a matching entry exists at similar location in current
truly_lost = []
for entry in clean_removed:
    lat, lon = entry.get('lat'), entry.get('lon')
    if lat and lon:
        similar = [i for i in curr if i.get('lat') and
                   abs(i['lat'] - lat) < 0.003 and abs(i['lon'] - lon) < 0.003]
    else:
        similar = []
    if not similar:
        truly_lost.append(entry)

print(f'\nPossibly lost entries (no coordinate match): {len(truly_lost)}')
for e in truly_lost[:20]:
    print(f'  {e.get("id")} "{e.get("name")}" lat={e.get("lat")} lon={e.get("lon")} src={e.get("source","")[:60]}')
