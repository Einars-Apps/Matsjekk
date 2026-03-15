#!/usr/bin/env python3
"""
Adds an approved farmshop / immigrant-shop submission directly to the dataset.

Reads ISSUE_BODY env var, parses YAML, deduplicates, appends to the correct
country JSON file, and rebuilds the combined farmshops.json or
immigrant_shops.json.

Writes `add_result=success|duplicate|error` to $GITHUB_OUTPUT when available.

Exit codes:
  0 = success
  1 = parse/config error
  2 = duplicate detected
"""

import os, re, sys, json
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None

# ── country mappings ──────────────────────────────────────────────────────────

# Norwegian and English country names → ISO-3166-1 alpha-2
COUNTRY_NAME_TO_CODE = {
    # Norwegian
    'albania': 'AL', 'argentina': 'AR', 'australia': 'AU', 'belgia': 'BE',
    'bolivia': 'BO', 'bosnia og hercegovina': 'BA', 'brasil': 'BR', 'bulgaria': 'BG',
    'canada': 'CA', 'chile': 'CL', 'colombia': 'CO', 'danmark': 'DK',
    'ecuador': 'EC', 'estland': 'EE', 'finland': 'FI', 'frankrike': 'FR',
    'grønland': 'GL', 'hellas': 'GR', 'irland': 'IE', 'island': 'IS',
    'italia': 'IT', 'kroatia': 'HR', 'kypros': 'CY', 'latvia': 'LV',
    'liechtenstein': 'LI', 'litauen': 'LT', 'luxembourg': 'LU', 'montenegro': 'ME',
    'nederland': 'NL', 'new zealand': 'NZ', 'nord-makedonia': 'MK', 'norge': 'NO',
    'paraguay': 'PY', 'peru': 'PE', 'polen': 'PL', 'portugal': 'PT',
    'romania': 'RO', 'serbia': 'RS', 'slovakia': 'SK', 'slovenia': 'SI',
    'spania': 'ES', 'storbritannia': 'GB', 'sveits': 'CH', 'sverige': 'SE',
    'tsjekkia': 'CZ', 'tyskland': 'DE', 'ungarn': 'HU', 'uruguay': 'UY',
    'usa': 'US', 'venezuela': 'VE', 'østerrike': 'AT',
    # English
    'belgium': 'BE', 'bosnia and herzegovina': 'BA', 'brazil': 'BR',
    'denmark': 'DK', 'estonia': 'EE', 'france': 'FR', 'greenland': 'GL',
    'greece': 'GR', 'ireland': 'IE', 'iceland': 'IS', 'italy': 'IT',
    'croatia': 'HR', 'cyprus': 'CY', 'lithuania': 'LT',
    'netherlands': 'NL', 'north macedonia': 'MK', 'norway': 'NO',
    'poland': 'PL', 'spain': 'ES', 'united kingdom': 'GB', 'great britain': 'GB',
    'switzerland': 'CH', 'sweden': 'SE', 'czech republic': 'CZ', 'czechia': 'CZ',
    'germany': 'DE', 'hungary': 'HU', 'united states': 'US', 'austria': 'AT',
    'albania': 'AL', 'argentina': 'AR', 'australia': 'AU', 'bolivia': 'BO',
    'canada': 'CA', 'chile': 'CL', 'colombia': 'CO', 'ecuador': 'EC',
    'finland': 'FI', 'latvia': 'LV', 'liechtenstein': 'LI', 'luxembourg': 'LU',
    'montenegro': 'ME', 'new zealand': 'NZ', 'paraguay': 'PY', 'peru': 'PE',
    'portugal': 'PT', 'romania': 'RO', 'serbia': 'RS', 'slovakia': 'SK',
    'slovenia': 'SI', 'uruguay': 'UY', 'venezuela': 'VE',
}

# English full names used in existing dataset entries
CODE_TO_COUNTRY_NAME = {
    'AL': 'Albania', 'AR': 'Argentina', 'AU': 'Australia', 'BE': 'Belgium',
    'BO': 'Bolivia', 'BA': 'Bosnia and Herzegovina', 'BR': 'Brazil', 'BG': 'Bulgaria',
    'CA': 'Canada', 'CL': 'Chile', 'CO': 'Colombia', 'DK': 'Denmark',
    'EC': 'Ecuador', 'EE': 'Estonia', 'FI': 'Finland', 'FR': 'France',
    'GL': 'Greenland', 'GR': 'Greece', 'IE': 'Ireland', 'IS': 'Iceland',
    'IT': 'Italy', 'HR': 'Croatia', 'CY': 'Cyprus', 'LV': 'Latvia',
    'LI': 'Liechtenstein', 'LT': 'Lithuania', 'LU': 'Luxembourg', 'ME': 'Montenegro',
    'NL': 'Netherlands', 'NZ': 'New Zealand', 'MK': 'North Macedonia', 'NO': 'Norway',
    'PY': 'Paraguay', 'PE': 'Peru', 'PL': 'Poland', 'PT': 'Portugal',
    'RO': 'Romania', 'RS': 'Serbia', 'SK': 'Slovakia', 'SI': 'Slovenia',
    'ES': 'Spain', 'GB': 'United Kingdom', 'CH': 'Switzerland', 'SE': 'Sweden',
    'CZ': 'Czechia', 'DE': 'Germany', 'HU': 'Hungary', 'UY': 'Uruguay',
    'US': 'United States', 'VE': 'Venezuela', 'AT': 'Austria',
}

# ── helpers ───────────────────────────────────────────────────────────────────

def write_output(key, value):
    out = os.environ.get('GITHUB_OUTPUT', '')
    if out:
        with open(out, 'a') as f:
            f.write(f'{key}={value}\n')


def extract_yaml_block(body):
    m = re.search(r'```yaml\s*(.*?)\s*```', body or '', re.S)
    if m:
        return m.group(1)
    return body or ''


def parse_entry(body):
    yaml_text = extract_yaml_block(body)
    if yaml:
        try:
            result = yaml.safe_load(yaml_text)
            if isinstance(result, dict):
                return result
        except Exception:
            pass
    # Simple fallback parser
    out = {}
    for line in yaml_text.splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if ':' in line:
            k, v = line.split(':', 1)
            k, v = k.strip(), v.strip()
            if (v.startswith('"') and v.endswith('"')) or \
               (v.startswith("'") and v.endswith("'")):
                v = v[1:-1]
            out[k] = v
    return out


def country_to_code(country_str):
    s = (country_str or '').strip()
    # Already a 2-letter code
    if len(s) == 2 and s.upper() in CODE_TO_COUNTRY_NAME:
        return s.upper()
    return COUNTRY_NAME_TO_CODE.get(s.lower())


def is_duplicate(name, existing_shops):
    """Exact name match (case-insensitive, stripped) within already-loaded list."""
    name_l = name.lower().strip()
    return any((s.get('name') or '').lower().strip() == name_l for s in existing_shops)

# ── main ──────────────────────────────────────────────────────────────────────

def main():
    body = os.environ.get('ISSUE_BODY', '')
    issue_number = os.environ.get('ISSUE_NUMBER', '0')

    entry = parse_entry(body)
    if not entry or not entry.get('name'):
        print('ERROR: Could not parse entry or missing name in issue body')
        write_output('add_result', 'error')
        return 1

    shop_name = (entry.get('name') or '').strip()
    is_immigrant = 'innvandrerbutikker' in (entry.get('notes') or '').lower()

    country_str = entry.get('country', '')
    cc = country_to_code(country_str)
    if not cc:
        print(f'ERROR: Unknown country: "{country_str}"')
        write_output('add_result', 'error')
        return 1

    data_dir = Path('docs/data')
    if is_immigrant:
        country_dir = data_dir / 'immigrant_shops_by_country'
        combined_file = data_dir / 'immigrant_shops.json'
    else:
        country_dir = data_dir / 'farmshops_by_country'
        combined_file = data_dir / 'farmshops.json'

    country_dir.mkdir(parents=True, exist_ok=True)
    country_file = country_dir / f'{cc.lower()}.json'

    if country_file.exists():
        with open(country_file, encoding='utf-8') as f:
            shops = json.load(f)
    else:
        shops = []

    # Duplicate check
    if is_duplicate(shop_name, shops):
        print(f'DUPLICATE: "{shop_name}" already exists in {cc}')
        write_output('add_result', 'duplicate')
        return 2

    # Build clean entry
    new_shop = {'name': shop_name, 'country': CODE_TO_COUNTRY_NAME.get(cc, cc)}
    for field in ('region', 'municipality', 'address', 'website'):
        val = (entry.get(field) or '').strip()
        if val:
            new_shop[field] = val

    # If municipality missing, try region
    if 'municipality' not in new_shop and 'region' in new_shop:
        new_shop['municipality'] = new_shop['region']

    # lat/lon if provided
    for k in ('lat', 'lon'):
        try:
            v = float(entry.get(k, ''))
            new_shop[k] = v
        except (ValueError, TypeError):
            pass

    shops.append(new_shop)

    with open(country_file, 'w', encoding='utf-8') as f:
        json.dump(shops, f, ensure_ascii=False, indent=2)

    print(f'Added "{shop_name}" to {country_file} ({len(shops)} entries)')

    # Rebuild combined file
    all_shops = []
    for fp in sorted(country_dir.glob('*.json')):
        try:
            with open(fp, encoding='utf-8') as f:
                all_shops.extend(json.load(f))
        except Exception as e:
            print(f'  Warning: could not read {fp}: {e}')

    with open(combined_file, 'w', encoding='utf-8') as f:
        json.dump(all_shops, f, ensure_ascii=False, separators=(',', ':'))

    print(f'Rebuilt {combined_file}: {len(all_shops)} total entries')
    write_output('add_result', 'success')
    return 0


if __name__ == '__main__':
    sys.exit(main())
