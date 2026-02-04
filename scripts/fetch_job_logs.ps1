param(
  [long]$RunId
)

$owner = 'Einars-Apps'
$repo = 'Matsjekk'
$headers = @{ Authorization = "token $env:GH_TOKEN"; 'User-Agent' = 'ps' }

if (-not $RunId) {
  Write-Error "RunId parameter is required. Usage: .\fetch_job_logs.ps1 -RunId 12345"
  exit 2
}

try {
  $jobs = Invoke-RestMethod -Headers $headers -Uri "https://api.github.com/repos/$owner/$repo/actions/runs/$RunId/jobs"
} catch {
  Write-Error ("Failed to query jobs for run {0}: {1}" -f $RunId, $_)
  exit 2
}

if (-not $jobs.jobs) {
  Write-Host "No jobs found for run $RunId"
  exit 0
}

$outDir = Join-Path (Get-Location) "run-logs-extracted\$RunId"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

foreach ($job in $jobs.jobs) {
  $id = $job.id
  $name = ($job.name -replace '[^a-zA-Z0-9_-]','_')
  $zipUrl = "https://api.github.com/repos/$owner/$repo/actions/jobs/$id/logs"
  $outZip = Join-Path $outDir "$($name)-$id.zip"
  Write-Host "Downloading logs for job $name (id $id) -> $outZip"
  try {
    Invoke-WebRequest -Headers $headers -Uri $zipUrl -OutFile $outZip -UseBasicParsing
  } catch {
    Write-Host ("Failed to download logs for job {0}: {1}" -f $id, $_)
    continue
  }
  if (Test-Path $outZip) {
    try {
      $bytes = Get-Content -Path $outZip -Encoding Byte -TotalCount 4 -ErrorAction Stop
      if ($bytes.Length -ge 2 -and $bytes[0] -eq 0x50 -and $bytes[1] -eq 0x4B) {
        Expand-Archive -Force -Path $outZip -DestinationPath $outDir -ErrorAction Stop
        Write-Host "Extracted $outZip"
      } else {
        # Not a zip archive; treat as plain log text
        $txtPath = $outZip -replace '\.zip$','.log'
        try {
          Move-Item -Force -Path $outZip -Destination $txtPath
          Write-Host "Saved plain log to $txtPath"
        } catch {
          Write-Host ("Failed to move non-zip log to {0}: {1}" -f $txtPath, $_)
        }
      }
    } catch {
      Write-Host ("Failed to inspect or extract {0}: {1}" -f $outZip, $_)
    }
  }
}

Write-Host "Saved job logs to $outDir"
