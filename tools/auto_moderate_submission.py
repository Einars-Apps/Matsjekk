#!/usr/bin/env python3
"""
Auto-moderation for farmshop/immigrant-shop submissions via GitHub Issues.

Reads the issue body (YAML block), runs a series of checks, then:
  - if all pass  → outputs APPROVE  + label: create-data-pr
  - if any fail  → outputs REJECT   + label: needs-manual-review

Checks performed:
  1. Required fields present (name, country, municipality/region)
  2. Spam patterns (links, gibberish, known spam phrases)
  3. Name plausibility (not just digits/symbols, reasonable length)
  4. Website reachability (HTTP HEAD, if website provided)
  5. Nominatim geo-verification: does a place with this name exist
     in the stated country?

Environment variables (set by GitHub Actions):
  ISSUE_BODY      - raw issue body text
  ISSUE_NUMBER    - issue number
  ISSUE_TITLE     - issue title
  ISSUE_AUTHOR    - submitter GitHub login
  GH_TOKEN        - GitHub token for posting comments / labeling
  GITHUB_REPO     - e.g. "Einars-Apps/Matsjekk"
"""

import os, re, sys, json, time
import urllib.request, urllib.parse, urllib.error

# ── helpers ──────────────────────────────────────────────────────────────────

def http_get(url, timeout=10):
    req = urllib.request.Request(url, headers={'User-Agent': 'matsjekk-modbot/1.0'})
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read(4096).decode('utf-8', errors='replace')
    except urllib.error.HTTPError as e:
        return e.code, ''
    except Exception:
        return 0, ''


def http_head(url, timeout=8):
    req = urllib.request.Request(url, method='HEAD',
                                  headers={'User-Agent': 'matsjekk-modbot/1.0'})
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status
    except urllib.error.HTTPError as e:
        return e.code
    except Exception:
        return 0


def extract_yaml_block(body):
    m = re.search(r'```yaml\s*(.*?)\s*```', body or '', re.S)
    if m:
        return m.group(1)
    return body or ''


def parse_yaml_simple(text):
    out = {}
    for line in text.splitlines():
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


def nominatim_search(name, country):
    """Return list of OSM place results for name in country."""
    params = urllib.parse.urlencode({
        'q': name,
        'countrycodes': country.lower()[:2],
        'format': 'json',
        'limit': 5,
        'addressdetails': 1,
    })
    url = f'https://nominatim.openstreetmap.org/search?{params}'
    status, body = http_get(url, timeout=12)
    if status == 200:
        try:
            return json.loads(body)
        except Exception:
            pass
    return []


def post_github_comment(repo, issue_number, body, token):
    url = f'https://api.github.com/repos/{repo}/issues/{issue_number}/comments'
    payload = json.dumps({'body': body}).encode()
    req = urllib.request.Request(url, data=payload, method='POST', headers={
        'Authorization': f'Bearer {token}',
        'Accept': 'application/vnd.github+json',
        'Content-Type': 'application/json',
        'X-GitHub-Api-Version': '2022-11-28',
    })
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            return r.status
    except Exception as e:
        print(f'  Comment error: {e}')
        return 0


def add_github_label(repo, issue_number, label, token):
    url = f'https://api.github.com/repos/{repo}/issues/{issue_number}/labels'
    payload = json.dumps({'labels': [label]}).encode()
    req = urllib.request.Request(url, data=payload, method='POST', headers={
        'Authorization': f'Bearer {token}',
        'Accept': 'application/vnd.github+json',
        'Content-Type': 'application/json',
        'X-GitHub-Api-Version': '2022-11-28',
    })
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            return r.status
    except Exception as e:
        print(f'  Label error: {e}')
        return 0

# ── spam / quality checks ─────────────────────────────────────────────────────

SPAM_PHRASES = [
    r'buy\s+(cheap|now|online)',
    r'click\s+here',
    r'earn\s+money',
    r'work\s+from\s+home',
    r'casino',
    r'crypto',
    r'bitcoin',
    r'sex\b',
    r'porn',
    r'viagra',
    r'payday\s+loan',
    r'seo\s+service',
    r'backlink',
    r'http[s]?://',  # bare URLs in name
]

# Keywords that should NOT appear in farmshop submissions
FARMSHOP_REMOVE_KEYWORDS = [
    'distribuidora', 'mayorista', 'wholesale', 'grossist',
    'hotel', 'hostel', 'motel',
    'supermercado', 'supermarket', 'hipermercado',
    'pharmacy', 'farmacia', 'apotek',
    'fastfood', 'mcdonalds', 'burger king', 'kfc', 'subway',
]

# For immigrant shops, grossists/wholesalers are acceptable —
# only flag clearly irrelevant types
IMMIGRANT_SHOP_REMOVE_KEYWORDS = [
    'hotel', 'hostel', 'motel',
    'pharmacy', 'farmacia', 'apotek',
    'fastfood', 'mcdonalds', 'burger king', 'kfc', 'subway',
]


def is_immigrant_shop_submission(entry):
    notes = (entry.get('notes') or '').lower()
    return 'innvandrerbutikker' in notes


def check_spam(entry):
    """Returns list of failed checks (empty = OK)."""
    issues = []
    name = (entry.get('name') or '').lower()
    notes = (entry.get('notes') or '').lower()
    combined = name + ' ' + notes

    remove_keywords = (
        IMMIGRANT_SHOP_REMOVE_KEYWORDS
        if is_immigrant_shop_submission(entry)
        else FARMSHOP_REMOVE_KEYWORDS
    )

    # Bare URL in name
    if re.search(r'https?://', name):
        issues.append('Navn inneholder URL')

    # Spam phrases
    for pat in SPAM_PHRASES:
        if re.search(pat, combined, re.I):
            issues.append(f'Spam-mønster funnet: `{pat}`')
            break

    # Known irrelevant business types
    for kw in remove_keywords:
        if kw in name:
            issues.append(f'Ikke relevant type: inneholder "{kw}"')
            break

    # Name too short or too long
    name_raw = (entry.get('name') or '').strip()
    if len(name_raw) < 3:
        issues.append('Navn for kort (< 3 tegn)')
    if len(name_raw) > 120:
        issues.append('Navn for langt (> 120 tegn)')

    # Name is only digits/symbols
    if name_raw and re.fullmatch(r'[\d\s\W]+', name_raw):
        issues.append('Navn inneholder kun tall/symboler')

    return issues


def check_required_fields(entry):
    missing = []
    for field in ('name', 'country', 'municipality'):
        if not (entry.get(field) or entry.get('region')):
            # municipality OR region is acceptable
            if field == 'municipality' and (entry.get('municipality') or entry.get('region')):
                continue
            if field != 'municipality':
                missing.append(field)
    if not entry.get('municipality') and not entry.get('region'):
        missing.append('municipality eller region')
    return missing


def check_website(entry):
    """Returns (ok: bool, message: str)"""
    website = (entry.get('website') or '').strip()
    if not website or website in ('""', "''", '-', 'https://...', 'http://...'):
        return True, '(ingen nettside oppgitt)'
    # normalize
    if not website.startswith('http'):
        website = 'https://' + website
    status = http_head(website)
    if status in (200, 201, 301, 302, 303, 307, 308):
        return True, f'Nettside svarer OK ({status})'
    if status == 0:
        return False, f'Nettside ikke nåbar (timeout/feil): {website}'
    if status in (401, 403):
        # Protected but exists
        return True, f'Nettside svarer {status} (eksisterer, men krever pålogging)'
    return False, f'Nettside svarte med HTTP {status}: {website}'


def check_nominatim(entry):
    """
    Returns (found: bool, message: str)
    Looks up the shop name in the given country via Nominatim.
    A miss is NOT a hard reject — many small farms aren't in OSM.
    """
    name = (entry.get('name') or '').strip()
    country = (entry.get('country') or '').strip()
    if not name or not country:
        return None, 'Kan ikke verifisere — mangler navn eller land'

    # Use 2-letter country code if given, else try to resolve
    cc = country if len(country) == 2 else None
    results = nominatim_search(name, cc or country)
    time.sleep(1)  # Nominatim rate limit

    if results:
        best = results[0]
        display = best.get('display_name', '')
        return True, f'Funnet i OSM: "{display[:80]}"'
    else:
        return None, f'Ikke funnet i Nominatim (kan mangle fra OSM — ikke avgjørende)'


# ── main ──────────────────────────────────────────────────────────────────────

def main():
    body = os.environ.get('ISSUE_BODY', '')
    number = os.environ.get('ISSUE_NUMBER', '0')
    title = os.environ.get('ISSUE_TITLE', '')
    author = os.environ.get('ISSUE_AUTHOR', '')
    token = os.environ.get('GH_TOKEN', '')
    repo = os.environ.get('GITHUB_REPO', '')

    print(f'=== Auto-moderasjon: issue #{number} ===')
    print(f'  Tittel: {title}')
    print(f'  Forfatter: {author}')

    yaml_text = extract_yaml_block(body)
    try:
        import yaml as _yaml
        entry = _yaml.safe_load(yaml_text) or {}
    except Exception:
        entry = parse_yaml_simple(yaml_text)

    if not isinstance(entry, dict):
        entry = {}

    print(f'  Felter: {list(entry.keys())}')

    results = []
    approved = True

    # 1. Required fields
    missing = check_required_fields(entry)
    if missing:
        results.append(('❌', f'Mangler påkrevde felt: {", ".join(missing)}'))
        approved = False
    else:
        results.append(('✅', 'Påkrevde felt til stede'))

    # 2. Spam check
    spam_issues = check_spam(entry)
    if spam_issues:
        for si in spam_issues:
            results.append(('🚫', f'Spam-sjekk: {si}'))
        approved = False
    else:
        results.append(('✅', 'Ingen spam-mønstre funnet'))

    # 3. Website check
    web_ok, web_msg = check_website(entry)
    if not web_ok:
        results.append(('⚠️', f'Nettside: {web_msg}'))
        approved = False
    else:
        results.append(('✅', f'Nettside: {web_msg}'))

    # 4. Nominatim geo check (soft — won't block approval alone)
    nom_found, nom_msg = check_nominatim(entry)
    if nom_found is True:
        results.append(('✅', f'Geo: {nom_msg}'))
    elif nom_found is None:
        results.append(('ℹ️', f'Geo: {nom_msg}'))
    else:
        results.append(('⚠️', f'Geo: {nom_msg}'))

    # ── Build comment ──
    status_line = '## ✅ Auto-godkjent' if approved else '## ⚠️ Sendt til manuell gjennomgang'
    lines = [
        f'### 🤖 Matsjekk Moderasjonsbot',
        '',
        status_line,
        '',
        '| Status | Sjekk |',
        '|--------|-------|',
    ]
    for icon, msg in results:
        lines.append(f'| {icon} | {msg} |')

    lines += [
        '',
        f'**Sendt av:** @{author}',
        f'**Navn:** {entry.get("name", "?")}',
        f'**Land:** {entry.get("country", "?")}',
        f'**Kommune/region:** {entry.get("municipality") or entry.get("region", "?")}',
    ]

    if entry.get('website') and entry['website'] not in ('""', "''", '-'):
        lines.append(f'**Nettside:** {entry["website"]}')

    if approved:
        lines += [
            '',
            '---',
            '_Forslaget er automatisk godkjent og vil bli lagt til i databasen. '
            'Legg til label `create-data-pr` for å opprette PR, eller fjern label `submission` for å avvise._',
        ]
        next_label = 'create-data-pr'
    else:
        lines += [
            '',
            '---',
            '_Forslaget ble ikke automatisk godkjent. En moderator vil se på dette. '
            'Korriger evt. feil og kommenter for ny vurdering._',
        ]
        next_label = 'needs-manual-review'

    comment_body = '\n'.join(lines)
    print(f'\n{"APPROVED" if approved else "NEEDS REVIEW"}\n')
    print(comment_body)

    if token and repo:
        print('\nPoster kommentar på GitHub issue...')
        post_github_comment(repo, number, comment_body, token)
        print(f'Legger til label: {next_label}')
        add_github_label(repo, number, next_label, token)
    else:
        print('\n(Ingen GH_TOKEN/GITHUB_REPO — kjører kun lokalt)')

    return 0 if approved else 1


if __name__ == '__main__':
    sys.exit(main())
