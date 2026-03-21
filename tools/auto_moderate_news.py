#!/usr/bin/env python3
"""
Auto-moderation for news article submissions via GitHub Issues.

Reads the issue body (YAML block), runs moderation checks, then:
  - if all pass  â†’ AUTO-APPROVE: add to feed data, close issue
  - if topic doubtful â†’ NEEDS REVIEW: assign maintainer (email via GitHub)
  - if spam/off-topic â†’ REJECT: label + comment + close

Checks performed:
  1. Required fields (url)
  2. Trusted source domain (mainstream + known alternative + local media)
  3. On-topic (bovaer, insektsmel, GMO fÃ´r, EU GMO import)
  4. Spam patterns
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

# â”€â”€ Trusted news domains (mainstream + known alternative + local) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

TRUSTED_NEWS_DOMAINS = [
    # Scandinavia â€“ mainstream
    'nrk.no', 'svt.se', 'dr.dk', 'yle.fi',
    'aftenposten.no', 'vg.no', 'dagbladet.no',
    'nationen.no', 'klassekampen.no', 'dagsavisen.no',
    'adresseavisen.no', 'bt.no', 'fvn.no',
    'smp.no', 'itromso.no', 'ranablad.no', 'fremover.no', 'h-a.no',
    'svd.se', 'aftonbladet.se', 'expressen.se', 'gp.se', 'dn.se',
    'jyllands-posten.dk', 'berlingske.dk', 'politiken.dk',
    'hs.fi', 'is.fi',
    # Scandinavia â€“ alternative
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

# â”€â”€ Topic keywords â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

TOPIC_KEYWORDS = [
    # Bovaer
    'bovaer', 'bovÃ¤er', '3-nop', '3nop',
    # Insect meal / insect protein
    'insektsmel', 'insektmel', 'insect meal', 'insect protein',
    'insektprotein', 'insektsprotein', 'insektmjÃ¶l',
    # GMO fish feed / animal feed
    'gmo-fiskefor', 'gmo fiskefor', 'gmo fish feed',
    'genmodifisert fiskefor', 'genetically modified fish feed',
    'gmo fÃ´r', 'gmo for', 'gmo-fÃ´r', 'genmodifisert fÃ´r',
    'raps fra gmo', 'soy feed gmo', 'oppdrettsfor gmo',
    'gmo animal feed', 'gmo dyrefÃ´r',
    # EU GMO / novel food / import regulations
    'eu gmo', 'eu genmodifisert', 'novel food', 'novel foods',
    'ny mat-forordning', 'nye mat-regler',
    'gmo import', 'gmo-import', 'genmodifisert import',
    'eu deregulering gmo', 'gmo deregulation',
    'new genomic techniques', 'ngt', 'cisgenic',
    'genredigering', 'geneditering', 'gene editing',
    'crispr', 'matimport gmo',
    # General food safety / feed
    'tilsetningsstoffer fÃ´r', 'feed additives',
    'matsikkerhet', 'food safety',
]

# â”€â”€ Spam patterns â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

SPAM_PATTERNS = [
    r'buy\s+(cheap|now|online)', r'click\s+here', r'earn\s+money',
    r'work\s+from\s+home', r'casino', r'crypto', r'bitcoin',
    r'sex\b', r'porn', r'viagra', r'payday\s+loan',
    r'seo\s+service', r'backlink',
]

# â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€


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


def gh_api(method, path, token, payload=None):
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
            return r.status
    except Exception as e:
        print(f'  GitHub API error ({method} {path}): {e}')
        return 0


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


# â”€â”€ Main â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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

    # 1. URL present
    if not article_url:
        results.append(('âŒ', 'Mangler URL'))
        decision = 'reject'
    else:
        results.append(('âœ…', f'URL oppgitt: {article_url}'))

    # 2. Spam check
    if check_spam(article_title, article_url):
        results.append(('ðŸš«', 'Spam-mÃ¸nster funnet'))
        decision = 'reject'
    else:
        results.append(('âœ…', 'Ingen spam-mÃ¸nstre'))

    # 3. Trusted source
    trusted = is_trusted_domain(article_url)
    if trusted:
        results.append(('âœ…', f'Kjent kilde: {host_from_url(article_url)}'))
    else:
        results.append(('âš ï¸', f'Ukjent kilde: {host_from_url(article_url)} â€” krever manuell vurdering'))
        if decision == 'approve':
            decision = 'review'

    # 4. On-topic check
    on_topic = has_required_topic(article_title, article_url)
    if on_topic:
        results.append(('âœ…', 'Relevant tema funnet (bovaer/insektsmel/GMO/EU)'))
    else:
        results.append(('âš ï¸', 'Tema ikke gjenkjent i tittel/URL â€” krever manuell vurdering'))
        if decision == 'approve':
            decision = 'review'

    # 5. URL reachable
    if article_url:
        reachable = check_url_reachable(article_url)
        if reachable:
            results.append(('âœ…', 'URL er tilgjengelig'))
        else:
            results.append(('âš ï¸', 'URL ikke nÃ¥bar â€” kan vÃ¦re midlertidig'))
            if decision == 'approve':
                decision = 'review'

    # â”€â”€ Build comment â”€â”€
    if decision == 'approve':
        status_line = '## âœ… Auto-godkjent'
        action_line = '_Artikkelen er godkjent og vil inkluderes i nyhetsfeeden. Issue lukkes automatisk._'
    elif decision == 'review':
        status_line = '## âš ï¸ Sendt til manuell vurdering'
        action_line = (
            f'_Artikkelen kunne ikke automatisk godkjennes. '
            f'Tildelt @{maintainer} for manuell gjennomgang. '
            f'E-postvarsling sendt via GitHub._'
        )
    else:
        status_line = '## âŒ Avvist'
        action_line = '_Innsendingen ble automatisk avvist. Se detaljer i tabellen over._'

    lines = [
        '### ðŸ¤– Matsjekk Nyhets-Moderasjonsbot',
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
        f'**SprÃ¥k:** {entry.get("language", "?")}',
        f'**Land:** {entry.get("country", "?")}',
        '',
        '---',
        action_line,
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
            add_labels(repo, number, ['rejected', 'news'], token)
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

    return 0 if decision == 'approve' else (1 if decision == 'review' else 2)


if __name__ == '__main__':
    sys.exit(main())
