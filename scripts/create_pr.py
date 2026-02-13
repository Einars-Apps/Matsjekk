import os, json, urllib.request, sys

def main():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr)
        sys.exit(1)
    body = {
        'title': 'ci: reconstruct main.yml',
        'head': 'fix/reconstruct-main-yml-2',
        'base': 'main',
        'body': 'Reconstruct full main.yml combining existing CI jobs (flutter, python, pages).'
    }
    data = json.dumps(body).encode('utf-8')
    req = urllib.request.Request(
        'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls',
        data=data,
        headers={
            'Authorization': f'token {token}',
            'User-Agent': 'mat_sjekk-agent',
            'Content-Type': 'application/json'
        },
        method='POST'
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            print(resp.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        print('HTTPError', e.code, e.read().decode('utf-8'), file=sys.stderr)
        sys.exit(2)

if __name__ == '__main__':
    main()
