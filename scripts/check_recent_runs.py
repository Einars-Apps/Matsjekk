import os, sys, json, urllib.request

def main():
    token = os.environ.get('GITHUB_TOKEN')
    if not token:
        print('GITHUB_TOKEN not set', file=sys.stderr); return 2
    url = 'https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs?per_page=50'
    req = urllib.request.Request(url, headers={
        'Authorization': f'token {token}',
        'User-Agent': 'mat_sjekk-agent'
    })
    with urllib.request.urlopen(req, timeout=30) as resp:
        data = json.load(resp)
    runs = data.get('workflow_runs', [])
    if not runs:
        print('No runs found')
        return 0
    # focus on runs created recently for branch main and our PR branches
    interesting = []
    for r in runs:
        name = r.get('name') or r.get('path') or '<unnamed>'
        status = r.get('status')
        conclusion = r.get('conclusion')
        branch = r.get('head_branch')
        created = r.get('created_at')
        interesting.append((r.get('id'), name, branch, status, conclusion, created))
    # print table
    print('Recent workflow runs (most recent first):')
    for id_, name, branch, status, conclusion, created in interesting[:30]:
        print(f"{id_:>12}  {name[:28]:28}  {branch[:20] if branch else '':20}  {status:10}  {str(conclusion):10}  {created}")
    # Check incomplete or failing
    not_ok = [r for r in interesting if r[3] != 'completed' or r[4] not in (None, 'success')]
    # Filter only runs on main or recent PR branches
    bad = []
    for id_, name, branch, status, conclusion, created in interesting:
        if branch in ('main','fix/reconstruct-main-yml-2','fix/reconstruct-root-main','fix/reconstruct-main'):
            if status != 'completed' or conclusion != 'success':
                bad.append((id_, name, branch, status, conclusion))
    if not bad:
        print('\nNo failing or incomplete runs found for main/recent PR branches.')
        return 0
    print('\nRuns with issues for main/recent PR branches:')
    for id_, name, branch, status, conclusion in bad:
        print(f"{id_} {name} branch={branch} status={status} conclusion={conclusion}")
    return 1

if __name__=='__main__':
    sys.exit(main())
