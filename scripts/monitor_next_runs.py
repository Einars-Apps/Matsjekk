#!/usr/bin/env python3
"""Monitor next 3 `main` workflow runs, wait for completion, download logs, scan for deprecation messages.

Usage:
  set your GitHub token in environment: $env:GITHUB_TOKEN (PowerShell) or export GITHUB_TOKEN=... (bash)
  python scripts/monitor_next_runs.py
"""
import os, time, json, urllib.request, urllib.error, zipfile

token = os.environ.get('GITHUB_TOKEN')
if not token:
    print('ERROR: set GITHUB_TOKEN in environment')
    raise SystemExit(1)

headers = {'Authorization': f'token {token}', 'User-Agent': 'mat_sjekk-agent'}
owner='Einars-Apps'; repo='Matsjekk'

def api_get(path):
    url = f'https://api.github.com/repos/{owner}/{repo}{path}'
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req) as r:
        return json.load(r)

def main():
    # get current max id
    data = api_get('/actions/runs?per_page=10')
    runs = data.get('workflow_runs', [])
    current_max = max((r['id'] for r in runs), default=0)
    print('current_max_run_id:', current_max)

    target_count = 3
    found = {}
    start = time.time()
    timeout_total = 900
    while time.time()-start < timeout_total and len(found) < target_count:
        data = api_get('/actions/runs?per_page=50')
        for r in data.get('workflow_runs', []):
            if r.get('head_branch') == 'main' and r.get('id',0) > current_max and r.get('id') not in found:
                found[r['id']] = r
                print('discovered run', r['id'])
        if len(found) >= target_count:
            break
        time.sleep(6)

    if not found:
        print('No new runs found within timeout')
        return

    downloaded = []
    scan_summary = {}
    for rid in sorted(found.keys()):
        print('Waiting for run', rid)
        run_complete = False
        start_wait = time.time()
        while time.time()-start_wait < 600:
            r = api_get(f'/actions/runs/{rid}')
            status = r.get('status')
            if status == 'completed':
                run_complete = True
                print('Run', rid, 'completed with conclusion', r.get('conclusion'))
                break
            time.sleep(5)
        if not run_complete:
            print('Run', rid, 'did not complete within timeout')
            scan_summary[rid] = {'status':'not_completed'}
            continue

        url = f'https://api.github.com/repos/{owner}/{repo}/actions/runs/{rid}/logs'
        req = urllib.request.Request(url, headers=headers)
        try:
            with urllib.request.urlopen(req) as resp:
                fname = f'run-{rid}-logs.zip'
                with open(fname, 'wb') as f:
                    f.write(resp.read())
                downloaded.append(fname)
                print('Saved', fname)
                # scan
                found_depr = False
                with zipfile.ZipFile(fname) as zf:
                    for name in zf.namelist():
                        text = zf.read(name).decode('utf-8', errors='ignore')
                        if 'This request has been automatically failed' in text or 'deprecated version' in text or 'upload-artifact' in text:
                            found_depr = True
                            outname = f'scan_run_{rid}.txt'
                            with open(outname, 'w', encoding='utf-8') as outf:
                                outf.write('=== '+name+'\n')
                                for i,l in enumerate(text.splitlines()):
                                    if 'upload-artifact' in l or 'deprecated version' in l or 'This request has been automatically failed' in l:
                                        start=max(0,i-4); end=min(len(text.splitlines()), i+5)
                                        for j in range(start,end):
                                            outf.write(f"{j+1:5d}: {text.splitlines()[j].replace('\ufeff','')}\n")
                                        outf.write('\n')
                            break
                scan_summary[rid] = {'status':'completed','found_deprecation':found_depr}
        except urllib.error.HTTPError as e:
            scan_summary[rid] = {'status':'download_failed','http':e.code}

    with open('monitor_summary.json','w',encoding='utf-8') as f:
        json.dump({'found_runs':sorted(found.keys()), 'downloaded':downloaded, 'scan_summary':scan_summary}, f, indent=2)
    print('Wrote monitor_summary.json')

if __name__ == '__main__':
    main()
