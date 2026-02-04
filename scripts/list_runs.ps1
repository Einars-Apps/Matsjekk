$token = $env:GH_TOKEN
if (-not $token) { Write-Host 'GH_TOKEN missing' -ForegroundColor Red; exit 2 }
$remote = git config --get remote.origin.url
if ($remote -notmatch 'github.com[:/](.+?)/(.+?)(\\.git)?$') { Write-Host "Cannot parse remote URL: $remote" -ForegroundColor Red; exit 3 }
$owner = $matches[1]
$repo = $matches[2]
$headers = @{ Authorization = "token $token"; 'User-Agent' = 'check' }
$url = "https://api.github.com/repos/$owner/$repo/actions/runs?branch=ci-ui-safety-fixes-clean2&per_page=10"
try {
  $runs = Invoke-RestMethod -Headers $headers -Uri $url -ErrorAction Stop
} catch {
  Write-Host "API request failed: $_" -ForegroundColor Red
  exit 4
}
if (-not $runs.workflow_runs) { Write-Host 'No workflow runs'; exit 0 }
$runs.workflow_runs | Select-Object id,status,conclusion,created_at,head_sha | Format-Table -AutoSize
