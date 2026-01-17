param(
    [int]$Port = 8000
)

$ErrorActionPreference = 'Stop'

# Project directory (script folder)
$ProjectDir = $PSScriptRoot

Write-Host 'Switching to project directory:' $ProjectDir
Set-Location -Path $ProjectDir

# If our helper exists, run it
$serveScript = Join-Path $ProjectDir 'serve-docs.ps1'
if (Test-Path $serveScript) {
    Write-Host "Found serve-docs.ps1 - launching (Port=$Port)"
    & powershell -NoProfile -ExecutionPolicy Bypass -File $serveScript -Port $Port -Root docs
    exit $LASTEXITCODE
}

# Try Python (py launcher or python)
if (Get-Command py -ErrorAction SilentlyContinue) {
    Write-Host "Launching Python (py) http.server on port $Port"
    & py -3 -m http.server $Port --directory docs
    exit $LASTEXITCODE
}
elseif (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "Launching Python http.server on port $Port"
    & python -m http.server $Port --directory docs
    exit $LASTEXITCODE
}

# Nothing available - instruct user
Write-Host 'No serve script or Python found. Please install Python or place serve-docs.ps1 in the project root.'
Write-Host 'To run manually:'
Write-Host '  Set-Location' $ProjectDir
Write-Host '  powershell -NoProfile -ExecutionPolicy Bypass -File .\serve-docs.ps1 -Port 8000 -Root docs'
