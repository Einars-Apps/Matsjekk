"""
Clean up no.json:
1. Remove mojibake-encoded duplicate entries
2. Fix outdated municipality names (communes merged since 2020)
3. Remove cross-source near-duplicates (same place from hanen + lokalmat)
"""
import json
import re
import shutil

def quality(s):
    score = 0
    if s.get('lat') and s.get('lon'):
        score += 3
    if s.get('address'):
        score += 2
    if s.get('website'):
        score += 2
    if s.get('region'):
        score += 1
    if s.get('municipality'):
        score += 1
    if s.get('products'):
        score += len(s['products'])
    return score

fpath = 'docs/data/farmshops_by_country/no.json'
shutil.copy(fpath, fpath + '.bak3')

with open(fpath, encoding='utf-8') as f:
    data = json.load(f)

before = len(data)

# 1. Remove mojibake entries (contain Ã — a known mojibake marker for Norwegian chars)
clean = []
for item in data:
    if 'Ã' in json.dumps(item, ensure_ascii=False):
        print(f'  [mojibake] Remove: {item.get("id")} {item.get("name","")[:50]}')
    else:
        clean.append(item)
print(f'Removed {before - len(clean)} mojibake entries\n')

# 2. Fix municipality merges (Norwegian kommunereform 2020)
municipality_merges = {
    'Rygge': 'Moss',
    'Re': 'Tønsberg',
    'Stokke': 'Sandefjord',
    'Andebu': 'Sandefjord',
    'Nøtterøy': 'Færder',
    'Tjøme': 'Færder',
}
fixed_muni = 0
for item in clean:
    old = item.get('municipality') or ''
    if old in municipality_merges:
        item['municipality'] = municipality_merges[old]
        fixed_muni += 1
        print(f'  [muni] {item["name"]}: {old} -> {item["municipality"]}')
print(f'Fixed {fixed_muni} municipality merges\n')

# 3. Remove cross-source near-duplicates
to_remove = set()
for i in range(len(clean)):
    for j in range(i + 1, len(clean)):
        a, b = clean[i], clean[j]
        if a.get('id') in to_remove or b.get('id') in to_remove:
            continue
        if not (a.get('lat') and b.get('lat')):
            continue
        if abs(a['lat'] - b['lat']) < 0.002 and abs(a['lon'] - b['lon']) < 0.002:
            an = re.sub(r'\s+(as|ans|sa)\s*$', '', a['name'].lower().strip())
            bn = re.sub(r'\s+(as|ans|sa)\s*$', '', b['name'].lower().strip())
            if an == bn or an in bn or bn in an:
                qa, qb = quality(a), quality(b)
                if qa >= qb:
                    if not a.get('website') and b.get('website'):
                        a['website'] = b['website']
                    if not a.get('address') and b.get('address'):
                        a['address'] = b['address']
                    to_remove.add(b['id'])
                    print(f'  [dedup] Keep {a["id"]} "{a["name"]}" (q={qa}), remove {b["id"]} "{b["name"]}" (q={qb})')
                else:
                    if not b.get('website') and a.get('website'):
                        b['website'] = a['website']
                    if not b.get('address') and a.get('address'):
                        b['address'] = a['address']
                    to_remove.add(a['id'])
                    print(f'  [dedup] Keep {b["id"]} "{b["name"]}" (q={qb}), remove {a["id"]} "{a["name"]}" (q={qa})')

deduped = [item for item in clean if item.get('id') not in to_remove]
print(f'\nRemoved {len(to_remove)} cross-source duplicates')
print(f'Final: {len(deduped)} entries (was {before})')

with open(fpath, 'w', encoding='utf-8') as f:
    json.dump(deduped, f, ensure_ascii=False, indent=2)
print('Saved no.json')
