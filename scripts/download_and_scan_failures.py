import os, sys, json, urllib.request, urllib.error, zipfile, io, re

RUN_IDS = [21982326635, 21982326305, 21982223439]
PATTERNS = [r"deprecated", r"Unexpected value", r"Encountered 1 file that should have been a pointer", r"ERROR", r"error", r"failed", r"FAIL", r"exception", r"Traceback", r"fatal"]
OUT_SUMMARY = 'scan_summary.json'

OWNER = 'Einars-Apps'
REPO = 'Matsjekk'


def api_get(url):
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr); sys.exit(2)
    req = urllib.request.Request(url, headers={
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent'
    })
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            return resp.getcode(), resp.read()
    except urllib.error.HTTPError as e:
        body = None
        try:
            body = e.read().decode('utf-8')
        except Exception:
            pass
        return e.code, body


def download_logs(run_id):
    url = f'https://api.github.com/repos/{OWNER}/{REPO}/actions/runs/{run_id}/logs'
    print('Downloading logs for', run_id)
    code, data = api_get(url)
    if code != 200:
        print('  download failed:', code)
        return None
    outname = f'run-{run_id}-logs.zip'
    with open(outname, 'wb') as f:
        f.write(data)
    print('  saved', outname)
    return outname


def scan_zip(zip_path):
    findings = []
    with zipfile.ZipFile(zip_path, 'r') as z:
        for name in z.namelist():
            if name.endswith('/'):
                continue
            # only scan text files
            if not any(name.endswith(ext) for ext in ('.txt', '.log', '.out', '.xml', '.json', '.yml', '.yaml')):
                continue
            try:
                with z.open(name) as f:
                    try:
                        text = f.read().decode('utf-8', errors='ignore')
                    except Exception:
                        continue
                for pat in PATTERNS:
                    for m in re.finditer(pat, text, flags=re.IGNORECASE):
                        # capture surrounding line
                        lineno = text.count('\n', 0, m.start()) + 1
                        line = text.splitlines()[lineno-1] if lineno-1 < len(text.splitlines()) else ''
                        findings.append({'file': name, 'pattern': pat, 'lineno': lineno, 'line': line.strip()[:400]})
            except Exception as e:
                print('  error reading', name, e)
    return findings


def main():
    summary = {}
    for rid in RUN_IDS:
        entry = {'downloaded': False, 'file': None, 'findings': []}
        zipf = download_logs(rid)
        if not zipf:
            summary[str(rid)] = entry
            continue
        entry['downloaded'] = True
        entry['file'] = zipf
        findings = scan_zip(zipf)
        entry['findings'] = findings
        summary[str(rid)] = entry
    with open(OUT_SUMMARY, 'w', encoding='utf-8') as f:
        json.dump(summary, f, indent=2, ensure_ascii=False)
    print('Wrote', OUT_SUMMARY)
    # print short report
    for rid, e in summary.items():
        print('\nRun', rid, 'downloaded=' + str(e['downloaded']), 'findings=', len(e['findings']))
        for f in e['findings'][:5]:
            print(' -', f['file'], f['pattern'], f['lineno'], f['line'])

if __name__=='__main__':
    main()
