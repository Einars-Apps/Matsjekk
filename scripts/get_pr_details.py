import os, json, urllib.request, sys

def main():
    pr = 22
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr); return 2
    url = f'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls/{pr}'
    req = urllib.request.Request(url, headers={'Authorization': f'token {token}', 'User-Agent': 'mat_sjekk-agent'})
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.load(resp)
    print('PR', data['number'], data['state'], 'title:', data['title'])
    print('mergeable:', data.get('mergeable'))
    print('mergeable_state:', data.get('mergeable_state'))
    print('mergeable_by:', data.get('mergeable_by'))
    print('head sha:', data.get('head',{}).get('sha'))
    print('base sha:', data.get('base',{}).get('sha'))
    print('draft:', data.get('draft'))
    print('mergeable_reason:', data.get('mergeable_reason'))
    for k in ['requested_reviewers','labels','assignees']:
        print(k, ':', data.get(k))
    return 0

if __name__=='__main__':
    sys.exit(main())
