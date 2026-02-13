import os, json, urllib.request, sys

def main():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr); return 2
    body = {
        'title': 'ci: reconstruct root main.yml',
        'head': 'fix/reconstruct-root-main',
        'base': 'main',
        'body': 'Replace broken root .github/workflows/main.yml with reconstructed combined workflow.'
    }
    req = urllib.request.Request('https://api.github.com/repos/Einars-Apps/Matsjekk/pulls', data=json.dumps(body).encode('utf-8'), headers={
        'Authorization': 'token '+token,
        'User-Agent': 'mat_sjekk-agent',
        'Content-Type': 'application/json'
    }, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            print(resp.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        print('HTTPError', e.code)
        try:
            print(e.read().decode('utf-8'))
        except Exception:
            pass
        return 3

if __name__=='__main__':
    sys.exit(main())
