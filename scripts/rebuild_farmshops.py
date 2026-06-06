"""Rebuild farmshops.json from all country JSON files."""
import json
from pathlib import Path

data_dir = Path('docs/data')
country_dir = data_dir / 'farmshops_by_country'

all_shops = []
for f in sorted(country_dir.glob('*.json')):
    with open(f, encoding='utf-8') as fh:
        shops = json.load(fh)
    all_shops.extend(shops)

combined_file = data_dir / 'farmshops.json'
with open(combined_file, 'w', encoding='utf-8') as f:
    json.dump(all_shops, f, ensure_ascii=False, separators=(',', ':'))

print(f'Rebuilt {combined_file}: {len(all_shops)} total entries')
