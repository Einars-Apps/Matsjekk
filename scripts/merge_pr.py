import os, sys, json, urllib.request

def main():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr)
        return 2
    pr = 22
    url = f'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls/{pr}/merge'
    data = json.dumps({
        'commit_title': f'Merge PR #{pr}: reconstruct main.yml',
        'merge_method': 'merge'
    }).encode('utf-8')
    req = urllib.request.Request(url, data=data, headers={
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent',
        'Content-Type': 'application/json'
    }, method='PUT')
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            print(resp.read().decode('utf-8'))
            return 0
    except urllib.error.HTTPError as e:
        print('HTTPError', e.code)
        try:
            print(e.read().decode('utf-8'))
        except Exception:
            pass
        return 3

if __name__=='__main__':
    sys.exit(main())
