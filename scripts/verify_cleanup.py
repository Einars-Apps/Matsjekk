import json
import re

with open('docs/data/farmshops_by_country/no.json.bak2', encoding='utf-8') as f:
    orig = json.load(f)
with open('docs/data/farmshops_by_country/no.json', encoding='utf-8') as f:
    curr = json.load(f)

print(f'Original: {len(orig)}, Current: {len(curr)}, Removed: {len(orig)-len(curr)}')

curr_ids = {str(i.get('id')) for i in curr}
orig_ids = {str(i.get('id')) for i in orig}

only_in_orig = orig_ids - curr_ids
print(f'IDs only in original: {len(only_in_orig)}')

# For each removed id, check if there's a clean near-duplicate in current data
data_loss = []
for oid in only_in_orig:
    entry = next(i for i in orig if str(i.get('id')) == oid)
    name = entry.get('name', '')
    lat, lon = entry.get('lat'), entry.get('lon')
    
    # Check for near-coordinate match in current
    similar = []
    if lat and lon:
        similar = [i for i in curr if i.get('lat') and
                   abs(i['lat'] - lat) < 0.01 and abs(i['lon'] - lon) < 0.01]
    
    # Also check by cleaned name
    name_clean = re.sub(r'[ÃÂ][\xa5\xb8\xa6\xa4\x98\xa7\x86]', '',
                        name.lower().replace('ã', 'a'))
    
    if not similar:
        data_loss.append((oid, name))

print(f'\nEntries with NO coordinate match in current data: {len(data_loss)}')
for oid, name in data_loss[:30]:
    print(f'  {oid}: "{name}"')
