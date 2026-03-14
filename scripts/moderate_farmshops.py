#!/usr/bin/env python3
"""
Remove clearly irrelevant entries from farmshops_by_country data,
then rebuild farmshops.json from the cleaned per-country files.

Removes:
  - Hotels, hostels
  - Supermarkets / hipermercados
  - Pure distributors / wholesalers (distribuidora, mayorista)
  - Entries marked as closed (FECHADO, CERRADO, CLOSED in name)

Keeps:
  - Cooperatives (cooperativa) — local producer co-ops
  - Farms, wineries, dairies, even if incorporated (fazenda, vinícola, bodega, etc.)
  - Any entry with clear farm/local keywords

Usage:
    python moderate_farmshops.py              # all countries
    python moderate_farmshops.py BR AR CL     # specific countries
"""

import json, re, sys
from pathlib import Path

COUNTRY_DIR = Path(__file__).parent.parent / "docs" / "data" / "farmshops_by_country"
FARMSHOPS_PATH = Path(__file__).parent.parent / "docs" / "data" / "farmshops.json"

# These patterns in the name → REMOVE (unless a KEEP keyword also matches)
REMOVE_PATTERNS = [
    r'\bhotel\b',
    r'\bhostel\b',
    r'\bsupermercado\b',
    r'\bsupermercados\b',
    r'\bhipermercado\b',
    r'\bsupermarket\b',
    r'\bdistribuidora\b',
    r'\bdistributora\b',
    r'\bdistribuidor\b',
    r'\bdistribuição\b',
    r'\bdistriver\b',
    r'\bmayorista\b',
    r'\bgrossista\b',
    r'\bfechado\b',       # Portuguese: closed
    r'\bcerrado\b',       # Spanish: closed
    r'\bclosed\b',
    r'\(fechado\)',
    r'\(cerrado\)',
    r'\(closed\)',
]

# These keywords in the name → KEEP even if a remove pattern also matched
KEEP_PATTERNS = [
    r'\bcooperativa\b',
    r'\bvinícola\b',
    r'\bvinicola\b',
    r'\bviti[\s\-]', 
    r'\bfazenda\b',
    r'\bbodega\b',
    r'\bchácara\b',
    r'\bchacara\b',
    r'\bquesería\b',
    r'\bqueseria\b',
    r'\bqueijaria\b',
    r'\bqueijo\b',
    r'\bqueso\b',
    r'\blechería\b',
    r'\blecheria\b',
    r'\bfinca\b',
    r'\bhacienda\b',
    r'\bhuerto\b',
    r'\borchard\b',
    r'\bgranja\b',
    r'\bagrícola\b',
    r'\bagricola\b',
    r'\borganic\b',
    r'\becológic',
    r'\borgánico',
]

def should_remove(name):
    if not name:
        return False
    n = name.lower()
    # Check keep patterns first
    for kp in KEEP_PATTERNS:
        if re.search(kp, n):
            return False
    # Check remove patterns
    for rp in REMOVE_PATTERNS:
        if re.search(rp, n):
            return True
    return False

def deduplicate(shops):
    seen = set()
    out = []
    for s in shops:
        key = (
            (s.get('name') or '').lower().strip(),
            (s.get('region') or '').lower().strip(),
            s.get('lat'), s.get('lon')
        )
        if key not in seen:
            seen.add(key)
            out.append(s)
    return out

def process_country(cc):
    p = COUNTRY_DIR / f"{cc.lower()}.json"
    if not p.exists():
        return 0, 0, 0
    data = json.loads(p.read_text(encoding='utf-8'))
    shops = data.get('shops', data) if isinstance(data, dict) else data

    before = len(shops)
    shops = deduplicate(shops)
    dupes = before - len(shops)

    removed = [s for s in shops if should_remove(s.get('name', ''))]
    kept = [s for s in shops if not should_remove(s.get('name', ''))]

    if removed or dupes:
        print(f"  {cc.upper():3}: -{len(removed)} fjernet, -{dupes} duplikat  ({before} → {len(kept)})")
        for s in removed:
            print(f"        ✗ {s.get('name')}  [{s.get('region')}]")

    # Write back
    if isinstance(data, dict):
        data['shops'] = kept
        p.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding='utf-8')
    else:
        p.write_text(json.dumps(kept, ensure_ascii=False, indent=2), encoding='utf-8')

    return before, len(removed) + dupes, len(kept)

def rebuild_farmshops_json():
    """Rebuild the combined farmshops.json from all per-country files."""
    all_shops = []
    for p in sorted(COUNTRY_DIR.glob("*.json")):
        data = json.loads(p.read_text(encoding='utf-8'))
        shops = data.get('shops', data) if isinstance(data, dict) else data
        all_shops.extend(shops)
    FARMSHOPS_PATH.write_text(json.dumps(all_shops, ensure_ascii=False, indent=2), encoding='utf-8')
    return len(all_shops)

def main():
    args = [a.upper() for a in sys.argv[1:]]
    codes = args if args else [p.stem.upper() for p in sorted(COUNTRY_DIR.glob("*.json"))]

    print(f"Modererer {len(codes)} land...\n")
    total_before = total_removed = total_after = 0
    for cc in codes:
        b, r, a = process_country(cc)
        total_before += b
        total_removed += r
        total_after += a

    print(f"\nTotalt fjernet: {total_removed}  ({total_before} → {total_after})")
    print("Bygger om farmshops.json...")
    n = rebuild_farmshops_json()
    print(f"farmshops.json: {n} oppføringer totalt")

if __name__ == '__main__':
    main()
