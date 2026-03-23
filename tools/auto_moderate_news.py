#!/usr/bin/env python3
"""
Auto-moderation for news article submissions via GitHub Issues.

CENSORSHIP RESISTANCE POLICY:
  - The bot can NEVER reject or delete a real news article.
  - Only obvious machine-generated spam (casino/crypto/viagra patterns) with
    NO valid article URL is rejected.
  - If a submission has a valid URL pointing to any real website, the worst
    outcome is 'review' (manual check) — NEVER 'reject'.
  - Once approved, articles are permanent and cannot be removed by the bot.
  - This protects against external pressure from organizations (ADL, etc.)
    that attempt to influence moderation of legitimate journalism.

Reads the issue body (YAML block), runs moderation checks, then:
  - if all pass  → AUTO-APPROVE: label + close
  - if topic/source uncertain → NEEDS REVIEW: assign maintainer (email via GitHub)
  - if spam AND no valid URL → REJECT: label + comment + close

Checks performed:
  1. Required fields (url)
  2. Spam patterns (only rejects if URL is also missing/unreachable)
  3. Trusted source domain (mainstream + known alternative + local media)
  4. On-topic (bovaer, insektsmel, GMO fôr, EU GMO import)
  5. URL reachability

Environment variables (set by GitHub Actions):
  ISSUE_BODY      - raw issue body text
  ISSUE_NUMBER    - issue number
  ISSUE_TITLE     - issue title
  ISSUE_AUTHOR    - submitter GitHub login
  GH_TOKEN        - GitHub token
  GITHUB_REPO     - e.g. "Einars-Apps/Matsjekk"
"""

import os
import re
import sys
import json
import urllib.request
import urllib.error

# ── Trusted news domains (mainstream + known alternative + local) ──────────

TRUSTED_NEWS_DOMAINS = [
    # Scandinavia – mainstream
    'nrk.no', 'svt.se', 'dr.dk', 'yle.fi',
    'aftenposten.no', 'vg.no', 'dagbladet.no',
    'nationen.no', 'klassekampen.no', 'dagsavisen.no',
    'adresseavisen.no', 'bt.no', 'fvn.no',
    'smp.no', 'itromso.no', 'ranablad.no', 'fremover.no', 'h-a.no',
    'svd.se', 'aftonbladet.se', 'expressen.se', 'gp.se', 'dn.se',
    'jyllands-posten.dk', 'berlingske.dk', 'politiken.dk',
    'hs.fi', 'is.fi',
    # Scandinavia – alternative
    'steigan.no', 'document.no', 'inyheter.no',
    'samnytt.se', 'friatider.se', '24nyt.dk',
    # European mainstream
    'reuters.com', 'apnews.com', 'bbc.com', 'theguardian.com', 'dw.com',
    'lemonde.fr', 'lefigaro.fr', 'france24.com',
    'corriere.it', 'ansa.it',
    'elpais.com', 'abc.es', 'publico.pt', 'jn.pt', 'nzz.ch',
    # European alternative
    'nachdenkseiten.de', 'epochtimes.de', 'dagelijksestandaard.nl',
    'off-guardian.org', 'spiked-online.com',
    # Industry / agriculture / food sector media
    'mejerimedier.dk', 'landbruk.no', 'bondebladet.no', 'atl.nu',
    'foodnavigator.com', 'feednavigator.com', 'efsa.europa.eu',
    'ec.europa.eu', 'europarl.europa.eu',
]

# ── Topic keywords ─────────────────────────────────────────────────────────

TOPIC_KEYWORDS = [
    # Bovaer / methane inhibitor
    'bovaer', 'boväer', '3-nop', '3nop',
    'metanhemmer', 'methane inhibitor', 'methane suppressor',
    'metanutslipp', 'metan-striden', 'metanhemmer-striden',
    # Dairy / farming controversy
    'melkebonde', 'melkebønder', 'melkeprodusentene',
    'bondelaget', 'tine', 'nortura',
    'naeringskomiteen', 'næringskomiteen',
    # Insect meal / insect protein
    'insektsmel', 'insektmel', 'insect meal', 'insect protein',
    'insektprotein', 'insektsprotein', 'insektmjöl',
    # GMO fish feed / animal feed
    'gmo-fiskefor', 'gmo fiskefor', 'gmo fish feed',
    'genmodifisert fiskefor', 'genetically modified fish feed',
    'gmo fôr', 'gmo for', 'gmo-fôr', 'genmodifisert fôr',
    'raps fra gmo', 'soy feed gmo', 'oppdrettsfor gmo',
    'gmo animal feed', 'gmo dyrefôr',
    # EU GMO / novel food / import regulations
    'eu gmo', 'eu genmodifisert', 'novel food', 'novel foods',
    'ny mat-forordning', 'nye mat-regler',
    'gmo import', 'gmo-import', 'genmodifisert import',
    'eu deregulering gmo', 'gmo deregulation',
    'new genomic techniques', 'ngt', 'cisgenic',
    'genredigering', 'geneditering', 'gene editing',
    'crispr', 'matimport gmo',
    # General food safety / feed
    'tilsetningsstoffer fôr', 'feed additives',
    'matsikkerhet', 'food safety',
    'omdommemaling', 'omdømme',
]

# ── Spam patterns ──────────────────────────────────────────────────────────

SPAM_PATTERNS = [
    r'buy\s+(cheap|now|online)', r'click\s+here', r'earn\s+money',
    r'work\s+from\s+home', r'casino', r'crypto', r'bitcoin',
    r'sex\b', r'porn', r'viagra', r'payday\s+loan',
    r'seo\s+service', r'backlink',
]

# ── Helpers ────────────────────────────────────────────────────────────────


def extract_yaml_block(body):
    m = re.search(r'```yaml\s*(.*?)\s*```', body or '', re.S)
    return m.group(1) if m else (body or '')


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


def host_from_url(url):
    try:
        from urllib.parse import urlparse
        return urlparse(url).hostname.lower()
    except Exception:
        return ''


def is_trusted_domain(url):
    host = host_from_url(url)
    if not host:
        return False
    return any(
        host == d or host.endswith('.' + d)
        for d in TRUSTED_NEWS_DOMAINS
    )


def has_required_topic(title, url):
    text = (title + ' ' + url).lower()
    return any(kw in text for kw in TOPIC_KEYWORDS)


def check_url_reachable(url, timeout=10):
    req = urllib.request.Request(
        url, method='HEAD',
        headers={'User-Agent': 'matsjekk-modbot/1.0'}
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status in range(200, 400)
    except urllib.error.HTTPError as e:
        return e.code in range(200, 400) or e.code in (401, 403)
    except Exception:
        return False


def check_spam(title, url):
    text = (title + ' ' + url).lower()
    for pat in SPAM_PATTERNS:
        if re.search(pat, text, re.I):
            return True
    return False


def gh_api(method, path, token, payload=None, parse_json=False):
    url = f'https://api.github.com{path}'
    data = json.dumps(payload).encode() if payload else None
    req = urllib.request.Request(url, data=data, method=method, headers={
        'Authorization': f'Bearer {token}',
        'Accept': 'application/vnd.github+json',
        'Content-Type': 'application/json',
        'X-GitHub-Api-Version': '2022-11-28',
    })
    try:
        with urllib.request.urlopen(req, timeout=15) as r:
            if parse_json:
                return json.loads(r.read().decode())
            return r.status
    except Exception as e:
        print(f'  GitHub API error ({method} {path}): {e}')
        return None if parse_json else 0


def post_comment(repo, number, body, token):
    return gh_api('POST', f'/repos/{repo}/issues/{number}/comments',
                  token, {'body': body})


def add_labels(repo, number, labels, token):
    return gh_api('POST', f'/repos/{repo}/issues/{number}/labels',
                  token, {'labels': labels})


def close_issue(repo, number, token):
    return gh_api('PATCH', f'/repos/{repo}/issues/{number}',
                  token, {'state': 'closed'})


def assign_issue(repo, number, assignee, token):
    return gh_api('POST', f'/repos/{repo}/issues/{number}/assignees',
                  token, {'assignees': [assignee]})


# ── Main ───────────────────────────────────────────────────────────────────

def main():
    body = os.environ.get('ISSUE_BODY', '')
    number = os.environ.get('ISSUE_NUMBER', '0')
    title = os.environ.get('ISSUE_TITLE', '')
    author = os.environ.get('ISSUE_AUTHOR', '')
    token = os.environ.get('GH_TOKEN', '')
    repo = os.environ.get('GITHUB_REPO', '')
    maintainer = os.environ.get('MAINTAINER_LOGIN', 'Einars-Apps')

    print(f'=== News auto-moderasjon: issue #{number} ===')
    print(f'  Tittel: {title}')

    # Guard: skip if already moderated (has decision label)
    if token and repo:
        issue_data = gh_api('GET', f'/repos/{repo}/issues/{number}', token, parse_json=True)
        if issue_data:
            existing = [lbl['name'] for lbl in issue_data.get('labels', [])]
            if any(lbl in existing for lbl in ('auto-approved', 'needs-manual-review', 'spam')):
                print(f'  Allerede moderert (labels: {existing}). Avbryter.')
                return 0

    yaml_text = extract_yaml_block(body)
    try:
        import yaml as _yaml
        entry = _yaml.safe_load(yaml_text) or {}
    except Exception:
        entry = parse_yaml_simple(yaml_text)
    if not isinstance(entry, dict):
        entry = {}

    article_url = entry.get('url', '').strip()
    article_title = entry.get('title', title).strip()
    source = entry.get('source', '').strip()

    print(f'  URL: {article_url}')
    print(f'  Kilde: {source}')

    results = []
    decision = 'approve'  # approve | review | reject
    is_spam = False
    has_url = bool(article_url)

    # 1. URL present
    if not article_url:
        results.append(('❌', 'Mangler URL'))
        # No URL alone does NOT reject — might be review. See spam check below.
    else:
        results.append(('✅', f'URL oppgitt: {article_url}'))

    # 2. Spam check
    if check_spam(article_title, article_url):
        results.append(('🚫', 'Spam-mønster funnet'))
        is_spam = True
    else:
        results.append(('✅', 'Ingen spam-mønstre'))

    # 3. Trusted source
    trusted = is_trusted_domain(article_url)
    if trusted:
        results.append(('✅', f'Kjent kilde: {host_from_url(article_url)}'))
    elif article_url:
        results.append(('⚠️', f'Ukjent kilde: {host_from_url(article_url)} — krever manuell vurdering'))
        if decision == 'approve':
            decision = 'review'
    else:
        results.append(('⚠️', 'Kan ikke sjekke kilde uten URL'))

    # 4. On-topic check
    on_topic = has_required_topic(article_title, article_url)
    if on_topic:
        results.append(('✅', 'Relevant tema funnet (bovaer/insektsmel/GMO/EU)'))
    else:
        results.append(('⚠️', 'Tema ikke gjenkjent i tittel/URL — krever manuell vurdering'))
        if decision == 'approve':
            decision = 'review'

    # 5. URL reachable
    reachable = False
    if article_url:
        reachable = check_url_reachable(article_url)
        if reachable:
            results.append(('✅', 'URL er tilgjengelig'))
        else:
            results.append(('⚠️', 'URL ikke nåbar — kan være midlertidig'))
            if decision == 'approve':
                decision = 'review'

    # ── CENSORSHIP RESISTANCE: reject ONLY if spam + no valid/reachable URL ──
    # A real article (with a reachable URL) can NEVER be auto-rejected.
    # Only pure spam with no valid URL gets rejected.
    if is_spam and not has_url:
        decision = 'reject'
    elif is_spam and not reachable:
        decision = 'reject'
    elif is_spam:
        # Spam patterns detected but URL is reachable — send to review, don't reject
        # (could be a false positive — a real article about e.g. crypto regulation)
        if decision == 'approve':
            decision = 'review'
        results.append(('ℹ️', 'Spam-mønster funnet men URL er gyldig — sendt til manuell vurdering'))
    elif not has_url:
        decision = 'review'

    # ── Build comment ──
    if decision == 'approve':
        status_line = '## ✅ Auto-godkjent'
        action_line = '_Artikkelen er godkjent og vil inkluderes i nyhetsfeeden. Issue lukkes automatisk._'
    elif decision == 'review':
        status_line = '## ⚠️ Sendt til manuell vurdering'
        action_line = (
            f'_Artikkelen kunne ikke automatisk godkjennes. '
            f'Tildelt @{maintainer} for manuell gjennomgang. '
            f'E-postvarsling sendt via GitHub._'
        )
    else:
        status_line = '## 🚫 Avvist som spam'
        action_line = (
            '_Innsendingen ble avvist som spam (ingen gyldig URL + spam-mønster). '
            'Merk: Reelle artikler med gyldige URL-er kan aldri avvises automatisk._'
        )

    lines = [
        '### 🤖 Matsjekk Nyhets-Moderasjonsbot',
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
        f'**Tittel:** {article_title}',
        f'**Kilde:** {source}',
        f'**URL:** {article_url}',
        f'**Språk:** {entry.get("language", "?")}',
        f'**Land:** {entry.get("country", "?")}',
        '',
        '---',
        action_line,
        '',
        '_Sensurresistens: Reelle nyhetsartikler med gyldige URL-er kan aldri slettes eller avvises automatisk. '
        'Kun åpenbar spam uten gyldig URL avvises. Godkjente artikler er permanente._',
    ]

    comment_body = '\n'.join(lines)
    print(f'\nDecision: {decision.upper()}\n')
    print(comment_body)

    if token and repo:
        post_comment(repo, number, comment_body, token)

        if decision == 'approve':
            add_labels(repo, number, ['auto-approved', 'news'], token)
            close_issue(repo, number, token)
        elif decision == 'review':
            add_labels(repo, number, ['needs-manual-review', 'news'], token)
            assign_issue(repo, number, maintainer, token)
        else:
            # Only spam with no valid URL reaches here
            add_labels(repo, number, ['spam', 'news'], token)
            close_issue(repo, number, token)

    # Write result to $GITHUB_OUTPUT
    gh_output = os.environ.get('GITHUB_OUTPUT', '')
    if gh_output:
        with open(gh_output, 'a') as f:
            f.write(f'decision={decision}\n')
            f.write(f'approved={"true" if decision == "approve" else "false"}\n')
            if decision == 'approve':
                f.write(f'article_url={article_url}\n')
                f.write(f'article_title={article_title}\n')
                f.write(f'article_source={source}\n')
                f.write(f'article_language={entry.get("language", "nb")}\n')
                f.write(f'article_country={entry.get("country", "")}\n')

    return 0


if __name__ == '__main__':
    sys.exit(main())
