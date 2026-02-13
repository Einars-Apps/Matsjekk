import os, json, urllib.request, sys

def main():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr)
        sys.exit(1)
    url = 'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls?head=Einars-Apps:fix/reconstruct-main-yml-2'
    req = urllib.request.Request(url, headers={
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent'
    })
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.load(resp)
    if not data:
        print('No PR found')
        return
    for pr in data:
        print(pr.get('number'), pr.get('state'), pr.get('title'))
        print(pr.get('html_url'))

if __name__ == '__main__':
    main()
