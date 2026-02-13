param(
  [long[]] $RunIds
)
$h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
$tmp = Join-Path $PSScriptRoot 'tmp_run_logs'
if (-Not (Test-Path $tmp)) { New-Item -Path $tmp -ItemType Directory | Out-Null }
foreach ($id in $RunIds) {
  Write-Output "--- Processing run: $id ---"
  $zipPath = Join-Path $tmp "run-$id.zip"
  $outDir = Join-Path $tmp "run-$id"

  try {
    $url = "https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs/$id/logs"
    Write-Output "Downloading logs from $url"
    Invoke-WebRequest -Uri $url -Headers $h -OutFile $zipPath -UseBasicParsing -ErrorAction Stop
  } catch {
    Write-Output ("Failed to download logs for run {0}: {1}" -f $id, $_.Exception.Message)
    continue
  }

  try {
    if (Test-Path $outDir) { Remove-Item -Recurse -Force $outDir }
    Expand-Archive -Path $zipPath -DestinationPath $outDir -Force
  } catch {
    Write-Output ("Failed to extract {0}: {1}" -f $zipPath, $_.Exception.Message)
    continue
  }

  Write-Output "Scanning extracted logs for common failure patterns..."
  $matches = Select-String -Path (Join-Path $outDir '**\*') -Pattern 'error|exception|fatal|failed' -AllMatches -SimpleMatch -CaseSensitive:$false -ErrorAction SilentlyContinue
  if (-not $matches) { Write-Output "No matches found for run $id." ; continue }
  $matches | Select-Object Path,LineNumber,Line | Sort-Object Path,LineNumber | ForEach-Object {
    Write-Output "[$($_.Path):$($_.LineNumber)] $($_.Line.Trim())"
  }
}
