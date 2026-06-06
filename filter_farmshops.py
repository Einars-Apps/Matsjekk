import json, shutil

TRUSTED_SOURCES = ('lokalmat.no', 'hanen.no')

def is_trusted_source(entry):
    src = entry.get('source') or ''
    return any(t in src for t in TRUSTED_SOURCES)

def has_contact(entry):
    return bool(entry.get('website') or entry.get('address') or entry.get('phone'))

def keep(entry):
    if has_contact(entry):
        return True
    # Keep Norwegian entries from trusted curated sources even without direct contact fields
    if entry.get('country') == 'Norway' and is_trusted_source(entry) and entry.get('lat') is not None:
        return True
    return False

PATH = r'C:\Users\ebors\mat_sjekk\docs\data\farmshops.json'
with open(PATH, encoding='utf-8') as f:
    data = json.load(f)

shutil.copy(PATH, PATH + '.bak2')
filtered = [d for d in data if keep(d)]

with open(PATH, 'w', encoding='utf-8') as f:
    json.dump(filtered, f, ensure_ascii=False, separators=(',', ':'))

print('Before:', len(data))
print('After filter:', len(filtered))
print('Removed:', len(data) - len(filtered))
