#!/usr/bin/env python3
"""
Adds an approved farmshop / immigrant-shop submission directly to the dataset.

Steps:
  1. Parse YAML from issue body
  2. Resolve country code
  3. Enrich with Nominatim (lat/lon, region, municipality, address) if missing
  4. Duplicate check:
       - If already in dataset with EQUAL OR BETTER data → skip (no change)
       - If already in dataset but NEW entry has more info → replace old with new
       - If not duplicate → append
  5. Rebuild combined JSON

Writes `add_result=success|upgraded|skipped_duplicate|error` to $GITHUB_OUTPUT.

Exit codes:  0=success/upgraded  1=error  2=skipped duplicate
"""

import os, re, sys, json, time
import urllib.request, urllib.parse, urllib.error
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None

# ── country mappings ──────────────────────────────────────────────────────────

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

# OSM place types considered valid for a farmshop / local food store
VALID_OSM_TYPES = {
    'farm', 'farmyard', 'dairy', 'cheese', 'beverages', 'wine', 'brewery',
    'butcher', 'bakery', 'deli', 'seafood', 'greengrocer', 'convenience',
    'organic', 'health_food', 'general', 'shop', 'place', 'amenity',
}

# ── helpers ───────────────────────────────────────────────────────────────────

def write_output(key, value):
    out = os.environ.get('GITHUB_OUTPUT', '')
    if out:
        with open(out, 'a') as f:
            f.write(f'{key}={value}\n')


def http_get(url, timeout=12):
    req = urllib.request.Request(url, headers={'User-Agent': 'matsjekk-bot/2.0'})
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read(32768).decode('utf-8', errors='replace')
    except Exception:
        return 0, ''


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
    if len(s) == 2 and s.upper() in CODE_TO_COUNTRY_NAME:
        return s.upper()
    return COUNTRY_NAME_TO_CODE.get(s.lower())


def quality_score(shop):
    """Score how informative a shop entry is. Higher = better."""
    score = 0
    if (shop.get('name') or '').strip():       score += 1
    if (shop.get('country') or '').strip():    score += 1
    if (shop.get('region') or '').strip():     score += 1
    if (shop.get('municipality') or '').strip(): score += 1
    if (shop.get('address') or '').strip():    score += 2
    if (shop.get('website') or '').strip():    score += 2
    try:
        float(shop['lat']); float(shop['lon']); score += 3
    except (KeyError, TypeError, ValueError):
        pass
    return score


# ── Nominatim enrichment ─────────────────────────────────────────────────────

def nominatim_enrich(name, cc):
    """
    Search Nominatim for `name` restricted to country `cc`.
    Returns a dict with any discovered fields:
      lat, lon, region, municipality, address
    or {} if nothing useful found.
    """
    params = urllib.parse.urlencode({
        'q': name,
        'countrycodes': cc.lower(),
        'format': 'json',
        'limit': 5,
        'addressdetails': 1,
    })
    status, body = http_get(f'https://nominatim.openstreetmap.org/search?{params}')
    time.sleep(1)  # respect rate limit

    if status != 200:
        return {}

    try:
        results = json.loads(body)
    except Exception:
        return {}

    if not results:
        return {}

    # Score each result; prefer shops/farms/places of the right type
    best = None
    best_priority = -1
    for r in results:
        osm_type = (r.get('type') or '').lower()
        osm_class = (r.get('class') or '').lower()
        # Priority: shop/farm/amenity types > generic place
        if osm_type in VALID_OSM_TYPES or osm_class in ('shop', 'amenity', 'craft', 'tourism'):
            priority = 2
        elif osm_class in ('place', 'landuse', 'leisure'):
            priority = 1
        else:
            priority = 0

        if priority > best_priority:
            best_priority = priority
            best = r

    if not best:
        best = results[0]

    enriched = {}
    try:
        enriched['lat'] = round(float(best['lat']), 6)
        enriched['lon'] = round(float(best['lon']), 6)
    except (KeyError, ValueError):
        pass

    addr = best.get('address') or {}
    # region: state, county, region (in priority order)
    for key in ('state', 'county', 'region', 'province'):
        val = (addr.get(key) or '').strip()
        if val:
            enriched['region'] = val
            break

    # municipality: city, town, village, municipality
    for key in ('municipality', 'city', 'town', 'village', 'suburb'):
        val = (addr.get(key) or '').strip()
        if val:
            enriched['municipality'] = val
            break

    # address: road + house_number
    road = addr.get('road') or addr.get('street') or ''
    house = addr.get('house_number') or ''
    postcode = addr.get('postcode') or ''
    city = addr.get('city') or addr.get('town') or addr.get('village') or ''
    parts = [p for p in [f'{road} {house}'.strip(), postcode, city] if p]
    if parts:
        enriched['address'] = ', '.join(parts)

    if enriched:
        print(f'  Nominatim: found "{best.get("display_name", "")[:80]}"')
        print(f'  Enriched fields: {list(enriched.keys())}')
    else:
        print(f'  Nominatim: no useful data found for "{name}" in {cc}')

    return enriched


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

    cc = country_to_code(entry.get('country', ''))
    if not cc:
        print(f'ERROR: Unknown country: "{entry.get("country", "")}"')
        write_output('add_result', 'error')
        return 1

    data_dir = Path('docs/data')
    country_dir = data_dir / ('immigrant_shops_by_country' if is_immigrant else 'farmshops_by_country')
    combined_file = data_dir / ('immigrant_shops.json' if is_immigrant else 'farmshops.json')

    country_dir.mkdir(parents=True, exist_ok=True)
    country_file = country_dir / f'{cc.lower()}.json'

    shops = []
    if country_file.exists():
        with open(country_file, encoding='utf-8') as f:
            shops = json.load(f)

    # ── Build new entry from submission ──────────────────────────────────────
    new_shop = {'name': shop_name, 'country': CODE_TO_COUNTRY_NAME.get(cc, cc)}
    for field in ('region', 'municipality', 'address', 'website'):
        val = (entry.get(field) or '').strip()
        if val:
            new_shop[field] = val
    if 'municipality' not in new_shop and 'region' in new_shop:
        new_shop['municipality'] = new_shop['region']
    for k in ('lat', 'lon'):
        try:
            new_shop[k] = round(float(entry.get(k, '')), 6)
        except (ValueError, TypeError):
            pass

    # ── Nominatim enrichment (fill in missing fields) ────────────────────────
    needs_enrichment = not all(k in new_shop for k in ('lat', 'lon', 'region', 'municipality'))
    if needs_enrichment:
        print(f'  Searching Nominatim for "{shop_name}" in {cc}...')
        enriched = nominatim_enrich(shop_name, cc)
        for k, v in enriched.items():
            if k not in new_shop:   # don't overwrite what the submitter provided
                new_shop[k] = v

    # ── Duplicate check: find existing entry with same name ──────────────────
    name_l = shop_name.lower().strip()
    dup_idx = next(
        (i for i, s in enumerate(shops) if (s.get('name') or '').lower().strip() == name_l),
        None
    )

    if dup_idx is not None:
        existing = shops[dup_idx]
        old_score = quality_score(existing)
        new_score = quality_score(new_shop)

        if new_score > old_score:
            print(f'UPGRADE: "{shop_name}" — new entry has more data '
                  f'({new_score} pts vs {old_score} pts). Replacing.')
            shops[dup_idx] = new_shop
            action = 'upgraded'
        else:
            print(f'SKIPPED DUPLICATE: "{shop_name}" — existing entry is equal or '
                  f'better ({old_score} pts vs {new_score} pts). No change.')
            write_output('add_result', 'skipped_duplicate')
            return 2
    else:
        shops.append(new_shop)
        action = 'success'
        print(f'ADDED: "{shop_name}" to {country_file} ({len(shops)} entries)')

    with open(country_file, 'w', encoding='utf-8') as f:
        json.dump(shops, f, ensure_ascii=False, indent=2)

    # ── Rebuild combined file ────────────────────────────────────────────────
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
    write_output('add_result', action)
    return 0


if __name__ == '__main__':
    sys.exit(main())


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
