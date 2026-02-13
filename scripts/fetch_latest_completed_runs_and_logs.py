import os, sys, json, urllib.request, datetime

def iso_to_dt(s):
    try:
        return datetime.datetime.fromisoformat(s.replace('Z','+00:00'))
    except Exception:
        return s


def main():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr)
        return 2
    url = 'https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs?per_page=50'
    req = urllib.request.Request(url, headers={
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent'
    })
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.load(resp)
    runs = data.get('workflow_runs', [])
    runs_sorted = sorted(runs, key=lambda r: r.get('created_at',''), reverse=True)
    print('Recent runs:')
    for r in runs_sorted[:10]:
        print(f"{r['id']:>12}  {r['name'][:30]:30}  {r['status']:9}  {r.get('conclusion', '')[:10]:10}  {r['head_branch'][:20]:20}  {r['created_at']}")

    completed = [r for r in runs_sorted if r.get('status')=='completed']
    to_fetch = completed[:2]
    if not to_fetch:
        print('No completed runs found')
        return 0
    for r in to_fetch:
        rid = r['id']
        name = r['name']
        concl = r.get('conclusion')
        print('\nDownloading logs for run', rid, name, 'conclusion=', concl)
        logs_url = f'https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs/{rid}/logs'
        outname = f'run-{rid}-logs.zip'
        req2 = urllib.request.Request(logs_url, headers={
            'Authorization': f'token {token}',
            'User-Agent': 'mat_sjekk-agent'
        })
        try:
            with urllib.request.urlopen(req2, timeout=60) as resp:
                data = resp.read()
            with open(outname, 'wb') as f:
                f.write(data)
            print('Saved', outname)
        except urllib.error.HTTPError as e:
            print('Failed to download logs for', rid, 'HTTP', e.code, e.reason)
            try:
                print(e.read().decode('utf-8'))
            except Exception:
                pass
    return 0

if __name__=='__main__':
    sys.exit(main())
