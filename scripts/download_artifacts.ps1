# Download and extract latest workflow run artifacts for a branch
$token = $env:GH_TOKEN
if (-not $token) {
  Write-Host "GH_TOKEN not found in this terminal. Export it with: `$env:GH_TOKEN = 'gh_pat_...'" -ForegroundColor Red
  exit 2
}
Write-Host "GH_TOKEN length: $($token.Length)"
$remote = git config --get remote.origin.url 2>$null
if (-not $remote) {
  Write-Host "git remote origin URL not found" -ForegroundColor Red
  exit 3
}
Write-Host "remote: $remote"
if ($remote -match 'github.com[:/](.+?)/(.+?)(\.git)?$') {
  $owner = $matches[1]
  $repo = $matches[2]
} else {
  Write-Host "Cannot parse remote URL: $remote" -ForegroundColor Red
  exit 4
}
Write-Host "repo: $owner/$repo"
$branch = 'ci-ui-safety-fixes-clean2'
$headers = @{ Authorization = "token $token"; 'User-Agent' = 'artifact-downloader' }
Write-Host "Querying workflow runs for branch '$branch'..."
$runsUrl = "https://api.github.com/repos/$owner/$repo/actions/runs?branch=$branch&per_page=5"
$runs = Invoke-RestMethod -Headers $headers -Uri $runsUrl
if (-not $runs.workflow_runs -or $runs.total_count -eq 0) {
  Write-Host "No workflow runs found for branch $branch" -ForegroundColor Yellow
  exit 5
}
$run = $runs.workflow_runs | Select-Object -First 1
Write-Host "Found run id: $($run.id) status: $($run.status) conclusion: $($run.conclusion)"
$artifactsUrl = "https://api.github.com/repos/$owner/$repo/actions/runs/$($run.id)/artifacts"
Write-Host "Listing artifacts at: $artifactsUrl"
$artifacts = Invoke-RestMethod -Headers $headers -Uri $artifactsUrl
if ($artifacts.total_count -eq 0) {
  Write-Host "No artifacts found for run $($run.id)" -ForegroundColor Yellow
  exit 6
}
$dest = Join-Path -Path (Get-Location) -ChildPath 'artifacts'
New-Item -ItemType Directory -Force -Path $dest | Out-Null
foreach ($a in $artifacts.artifacts) {
  $url = $a.archive_download_url
  $safeName = ($a.name -replace '[^a-zA-Z0-9_.-]', '_')
  $file = Join-Path $dest ($safeName + '.zip')
  Write-Host "Downloading $($a.name) -> $file"
  try {
    $dlHeaders = @{ Authorization = "token $token"; 'User-Agent' = 'artifact-downloader' }
    Write-Host "Requesting artifact URL..."
    Invoke-WebRequest -Uri $url -Headers $dlHeaders -OutFile $file -UseBasicParsing -MaximumRedirection 10 -ErrorAction Stop
    Write-Host "Downloaded $file"
    $extractDir = Join-Path $dest $safeName
    Expand-Archive -Path $file -DestinationPath $extractDir -Force
    Write-Host "Extracted to $extractDir"
  } catch {
    Write-Host "Failed to download/extract $($a.name): $_" -ForegroundColor Red
  }
}
Write-Host "Done. Artifacts are in: $dest" -ForegroundColor Green
exit 0
