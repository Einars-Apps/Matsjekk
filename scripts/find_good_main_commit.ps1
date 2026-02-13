$bad = 'pr/gardsbutikker-merged'
$hashes = git rev-list HEAD -- .github/workflows/main.yml
foreach ($h in $hashes) {
  try {
    $path = $h + ':.github/workflows/main.yml'
    $c = git show $path 2>$null
  } catch {
    continue
  }
  if ($c -and $c.Trim() -ne $bad) {
    Write-Output "GOOD_COMMIT:$h"
    Write-Output "---CONTENT---"
    Write-Output $c
    exit 0
  }
}
Write-Output 'NO_GOOD_COMMIT_FOUND'
