import os, sys, json, time, urllib.request, urllib.error

OWNER = 'Einars-Apps'
REPO = 'Matsjekk'
RUN_IDS = [21970149407, 21970118777]
POLL_INTERVAL = 10
TIMEOUT = 60 * 20  # 20 minutes


def api_request(method, path, data=None):
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr)
        sys.exit(2)
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
            return resp.getcode(), resp.read().decode('utf-8')
    except urllib.error.HTTPError as e:
        body = None
        try:
            body = e.read().decode('utf-8')
        except Exception:
            pass
        return e.code, body


def rerun_and_wait(run_id):
    print(f'--> Requesting rerun for {run_id}')
    code, body = api_request('POST', f'/actions/runs/{run_id}/rerun')
    if code not in (202, 201, 200):
        print(f'Rerun request returned {code}: {body}')
        return False
    print('Rerun requested; polling status...')
    start = time.time()
    while True:
        code, body = api_request('GET', f'/actions/runs/{run_id}')
        if code != 200:
            print(f'Failed to get run status: {code} {body}')
            return False
        info = json.loads(body)
        status = info.get('status')
        conclusion = info.get('conclusion')
        head_branch = info.get('head_branch')
        print(f'  status={status} conclusion={conclusion} branch={head_branch}')
        if status == 'completed':
            print(f'Run {run_id} completed with conclusion={conclusion}')
            return True
        if time.time() - start > TIMEOUT:
            print('Timed out waiting for run to complete')
            return False
        time.sleep(POLL_INTERVAL)


def download_logs(run_id):
    print(f'--> Downloading logs for {run_id}')
    token = os.environ.get('GITHUB_TOKEN')
    url = f'https://api.github.com/repos/{OWNER}/{REPO}/actions/runs/{run_id}/logs'
    req = urllib.request.Request(url, headers={
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent',
        'Accept': 'application/vnd.github+json'
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
        body = None
        try:
            body = e.read().decode('utf-8')
        except Exception:
            pass
        print('Failed to download logs', e.code, body)
        return False


def main():
    any_failed = False
    for rid in RUN_IDS:
        ok = rerun_and_wait(rid)
        if not ok:
            any_failed = True
            continue
        dl = download_logs(rid)
        if not dl:
            any_failed = True
    return 1 if any_failed else 0

if __name__ == '__main__':
    sys.exit(main())
