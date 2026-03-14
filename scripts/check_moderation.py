#!/usr/bin/env python3
"""
Scan farmshops_by_country data for potential moderation issues.
Usage:
    python check_moderation.py           # all countries
    python check_moderation.py BR AR CL  # specific countries
"""

import json, sys
from pathlib import Path

COUNTRY_DIR = Path(__file__).parent.parent / "docs" / "data" / "farmshops_by_country"

COMMERCIAL_KEYWORDS = [
    'supermercado', 'supermarket', 'carrefour', 'walmart', 'lidl', 'aldi',
    'tesco', 'metro ', 'dia ', 'cencosud', 'jumbo', 'hipermercado', 'mercadona',
    'mcdonald', 'burger king', 'subway', 'kfc', 'starbucks',
    'farmacia', 'pharmacy', 'apoteke', 'apotheke',
    'banco ', 'bank ', 'hotel ', 'hostel',
    'gasolinera', 'petrol', 'gas station',
]

SUSPICIOUS_KEYWORDS = [
    'import', 'export', 'distribuidora', 'mayorista', 'wholesale',
    's.a.', 's.r.l.', 'ltda.', 'cia.', 'corp.', 'inc.',
]

def load(cc):
    p = COUNTRY_DIR / f"{cc.lower()}.json"
    if not p.exists():
        return []
    data = json.loads(p.read_text(encoding='utf-8'))
    return data.get('shops', data) if isinstance(data, dict) else data

def check(cc):
    shops = load(cc)
    if not shops:
        return

    no_name = [s for s in shops if not (s.get('name') or '').strip()]
    commercial = [s for s in shops if any(
        kw in (s.get('name') or '').lower() for kw in COMMERCIAL_KEYWORDS
    )]
    suspicious = [s for s in shops if any(
        kw in (s.get('name') or '').lower() for kw in SUSPICIOUS_KEYWORDS
    ) and s not in commercial]
    no_coords = [s for s in shops if not s.get('lat') or not s.get('lon')]

    issues = bool(no_name or commercial or suspicious or no_coords)
    if not issues:
        print(f"  {cc.upper():3}: OK ({len(shops)} entries)")
        return

    print(f"\n=== {cc.upper()} ({len(shops)} total) ===")
    if no_name:
        print(f"  Mangler navn ({len(no_name)}):")
        for s in no_name[:5]:
            print(f"    id={s.get('id')}  region={s.get('region')}  lat={s.get('lat')}")

    if commercial:
        print(f"  Ser kommersielle ut ({len(commercial)}):")
        for s in commercial[:10]:
            print(f"    - {s.get('name')}  [{s.get('region')}]")

    if suspicious:
        print(f"  Mistenkelig (firma-navn) ({len(suspicious)}):")
        for s in suspicious[:10]:
            print(f"    - {s.get('name')}  [{s.get('region')}]")

    if no_coords:
        print(f"  Mangler koordinater ({len(no_coords)})")

def main():
    args = [a.upper() for a in sys.argv[1:]]
    if args:
        codes = args
    else:
        codes = [p.stem.upper() for p in sorted(COUNTRY_DIR.glob("*.json"))]

    print(f"Sjekker {len(codes)} land...\n")
    ok_count = 0
    for cc in codes:
        shops = load(cc)
        if not shops:
            print(f"  {cc:3}: (tom)")
            continue
        no_name = [s for s in shops if not (s.get('name') or '').strip()]
        commercial = [s for s in shops if any(kw in (s.get('name') or '').lower() for kw in COMMERCIAL_KEYWORDS)]
        suspicious = [s for s in shops if any(kw in (s.get('name') or '').lower() for kw in SUSPICIOUS_KEYWORDS) and s not in commercial]
        if no_name or commercial or suspicious:
            check(cc)
        else:
            ok_count += 1
            print(f"  {cc:3}: OK ({len(shops)})")

    print(f"\n{ok_count}/{len(codes)} land uten funn.")

if __name__ == '__main__':
    main()
