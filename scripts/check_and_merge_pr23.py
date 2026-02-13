import os, sys, json, urllib.request, urllib.error

PR = 23
OWNER = 'Einars-Apps'
REPO = 'Matsjekk'

TOKEN = os.environ.get('GITHUB_TOKEN')
if not TOKEN:
    print('GITHUB_TOKEN not set', file=sys.stderr); sys.exit(2)

def api(method, path, data=None):
    url = f'https://api.github.com/repos/{OWNER}/{REPO}{path}'
    headers = {
        'Authorization': f'token {TOKEN}',
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

# Get PR details
code, data = api('GET', f'/pulls/{PR}')
if code != 200:
    print('Failed to fetch PR', PR, code, data)
    sys.exit(3)
print('PR', data['number'], 'state:', data['state'], 'title:', data['title'])
print('mergeable:', data.get('mergeable'), 'mergeable_state:', data.get('mergeable_state'))

# If not mergeable and not clean, warn but still attempt to merge
print('Attempting to merge PR', PR)
code, resp = api('PUT', f'/pulls/{PR}/merge', {'commit_title': f'Merge PR #{PR}: {data.get("title")}', 'merge_method': 'merge'})
if code in (200,201):
    print('Merged:', json.dumps(resp))
    sys.exit(0)
else:
    print('Merge failed:', code, resp)
    sys.exit(4)
