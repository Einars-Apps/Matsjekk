import os, sys, time, json, urllib.request, urllib.error, datetime

OWNER = 'Einars-Apps'
REPO = 'Matsjekk'
POLL_INTERVAL = 15
TIMEOUT = 60 * 15  # 15 minutes


def api_req(path, method='GET', data=None):
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr); sys.exit(2)
    url = f'https://api.github.com/repos/{OWNER}/{REPO}{path}'
    headers = {
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent',
        'Accept': 'application/vnd.github+json'
    }
    if data is not None:
        data = json.dumps(data).encode('utf-8')
        headers['Content-Type'] = 'application/json'
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.getcode(), json.load(resp)
    except urllib.error.HTTPError as e:
        body = None
        try:
            body = e.read().decode('utf-8')
        except Exception:
            pass
        return e.code, body


def list_recent_runs():
    code, data = api_req('/actions/runs?per_page=50')
    if code != 200:
        print('Failed to list runs', code, data)
        return []
    return data.get('workflow_runs', [])


def download_logs(run_id):
    token = os.environ.get('GITHUB_TOKEN')
    url = f'https://api.github.com/repos/{OWNER}/{REPO}/actions/runs/{run_id}/logs'
    req = urllib.request.Request(url, headers={
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent'
    })
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
            data = resp.read()
        out = f'run-{run_id}-logs.zip'
        with open(out, 'wb') as f:
            f.write(data)
        print('Saved', out)
        return True
    except urllib.error.HTTPError as e:
        body = ''
        try:
            body = e.read().decode('utf-8')
        except Exception:
            pass
        print(f'Failed to download logs for {run_id}:', e.code, body)
        return False


def main():
    seen = set()
    start = time.time()
    print('Starting poll for new `main` runs; timeout', TIMEOUT, 'seconds')
    while True:
        now = time.time()
        if now - start > TIMEOUT:
            print('Timeout reached; exiting')
            return 0
        runs = list_recent_runs()
        # filter runs on branch main created in last 30 minutes
        cutoff = datetime.datetime.utcnow() - datetime.timedelta(minutes=30)
        for r in runs:
            try:
                head_branch = r.get('head_branch') or ''
                created_at = r.get('created_at')
                created_dt = datetime.datetime.fromisoformat(created_at.replace('Z','+00:00')) if created_at else None
                if head_branch != 'main':
                    continue
                if created_dt and created_dt < cutoff:
                    continue
                rid = r['id']
                if rid in seen:
                    continue
                seen.add(rid)
                print('Found candidate run', rid, 'name=', r.get('name'), 'status=', r.get('status'), 'conclusion=', r.get('conclusion'))
                # Poll this run until completed
                run_done = False
                poll_start = time.time()
                while True:
                    code, info = api_req(f'/actions/runs/{rid}')
                    if code != 200:
                        print('Failed to get run', rid, code, info); break
                    status = info.get('status')
                    concl = info.get('conclusion')
                    print(f'  run {rid} status={status} conclusion={concl}')
                    if status == 'completed':
                        # try download logs
                        ok = download_logs(rid)
                        if not ok:
                            print('Will retry download later')
                        run_done = True
                        break
                    if time.time() - poll_start > 60 * 10:
                        print('Giving up polling this run after 10 minutes')
                        break
                    time.sleep(POLL_INTERVAL)
                # continue to next run
            except Exception as e:
                print('Error processing run entry', e)
        time.sleep(POLL_INTERVAL)

if __name__=='__main__':
    sys.exit(main())
