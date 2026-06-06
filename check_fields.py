import json
with open(r'C:\Users\ebors\mat_sjekk\docs\data\farmshops.json', encoding='utf-8') as f:
    data = json.load(f)
fields = {}
for entry in data:
    for k, v in entry.items():
        if k not in fields:
            fields[k] = [0, 0]
        fields[k][0] += 1
        if v is not None and v != '' and v != []:
            fields[k][1] += 1
print('Total:', len(data))
for k, v in fields.items():
    pct = 100*v[1]//v[0]
    print(k, str(v[1]) + '/' + str(v[0]), str(pct) + '%')

# Sample a few entries with good data
print('\nSample entries with website AND address:')
samples = [d for d in data if d.get('website') and d.get('address') and d.get('lat')][:5]
for s in samples:
    print(' ', s)
