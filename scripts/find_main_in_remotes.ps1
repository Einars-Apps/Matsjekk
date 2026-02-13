$bad = 'pr/gardsbutikker-merged'
$remotes = git branch -r | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^origin/' -and $_ -notmatch '->' }
foreach ($r in $remotes) {
  $ref = $r -replace '^origin/', 'origin/'
  try {
    $path = $ref + ':.github/workflows/main.yml'
    $content = git show $path 2>$null
  } catch {
    continue
  }
  if ($content -and $content.Trim() -ne $bad) {
    Write-Output "FOUND in $ref"
    Write-Output "---CONTENT---"
    Write-Output $content
    exit 0
  }
}
Write-Output 'NO_REMOTE_COPY_FOUND'
