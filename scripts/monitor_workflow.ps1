# Poll GitHub Actions for the latest run on a branch and download artifacts when it finishes
$token = $env:GH_TOKEN
if (-not $token) { Write-Host 'GH_TOKEN not set in this terminal' -ForegroundColor Red; exit 2 }
$remote = git config --get remote.origin.url 2>$null
if (-not $remote) { Write-Host 'git remote origin URL not found' -ForegroundColor Red; exit 3 }
if ($remote -match 'github.com[:/](.+?)/(.+?)(\.git)?$') { $owner=$matches[1]; $repo=$matches[2] } else { Write-Host 'Cannot parse remote URL' -ForegroundColor Red; exit 4 }
$branch = 'ci-ui-safety-fixes-clean2'
$headers = @{ Authorization = "token $token"; 'User-Agent' = 'workflow-monitor' }
$maxAttempts = 80
$interval = 15
$attempt = 0
Write-Host "Monitoring workflow runs for $owner/$repo on branch '$branch' (up to $([int]($maxAttempts*$interval/60)) minutes)"
while ($attempt -lt $maxAttempts) {
  $attempt++
  try {
    $runsUrl = "https://api.github.com/repos/$owner/$repo/actions/runs?branch=$branch&per_page=5"
    $runs = Invoke-RestMethod -Headers $headers -Uri $runsUrl -ErrorAction Stop
  } catch {
    Write-Host "Failed to list runs: $_" -ForegroundColor Yellow
    Start-Sleep -Seconds $interval
    continue
  }
  if (-not $runs.workflow_runs -or $runs.total_count -eq 0) {
    Write-Host "No workflow runs found for branch $branch" -ForegroundColor Yellow
    Start-Sleep -Seconds $interval
    continue
  }
  $run = $runs.workflow_runs | Select-Object -First 1
  $id = $run.id
  Write-Host "Run id: $id  status: $($run.status)  conclusion: $($run.conclusion)  created_at: $($run.created_at)"
  if ($run.status -eq 'completed') {
    Write-Host "Run completed with conclusion: $($run.conclusion)"
    # list jobs
    try {
      $jobsUrl = "https://api.github.com/repos/$owner/$repo/actions/runs/$id/jobs"
      $jobs = Invoke-RestMethod -Headers $headers -Uri $jobsUrl -ErrorAction Stop
      Write-Host "Jobs for run $id (name -> conclusion):"
      foreach ($j in $jobs.jobs) { Write-Host ("- $($j.name) -> $($j.conclusion) (status: $($j.status))") }
    } catch { Write-Host "Failed to list jobs: $_" -ForegroundColor Yellow }
    # download artifacts using existing script
    Write-Host "Downloading artifacts for run $id..."
    & powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\download_artifacts.ps1
    exit 0
  }
  Start-Sleep -Seconds $interval
}
Write-Host "Timeout: workflow run did not complete within expected time." -ForegroundColor Red
exit 1
