Param(
    [string]$Package = "com.example.mat_sjekk",
    [string]$OutDir = ".",
    [switch]$ErrorsOnly
)

if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    Write-Error "adb not found in PATH. Install Android Platform Tools or add adb to PATH."
    exit 2
}

New-Item -Path $OutDir -ItemType Directory -Force | Out-Null


$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$filename = if ($ErrorsOnly) { "mat_sjekk_errors_$timestamp.txt" } else { "mat_sjekk_live_log_$timestamp.txt" }
$outpath = Join-Path -Path $OutDir -ChildPath $filename

Write-Host "Clearing device logcat..."
adb logcat -c

# Pre-create output file and write header so file is not zero-bytes
Write-Host "Creating output file: $outpath"
Set-Content -Path $outpath -Value "=== mat_sjekk log capture ===" -Encoding utf8
Add-Content -Path $outpath -Value "Started: $(Get-Date -Format o)"
Add-Content -Path $outpath -Value "Package: $Package"
Add-Content -Path $outpath -Value "ErrorsOnly: $($ErrorsOnly.IsPresent)"
Add-Content -Path $outpath -Value ""

Write-Host "Looking up PID for package '$Package'..."
$pidRaw = & adb shell pidof $Package 2>$null
if ($pidRaw) {
    $appPid = $pidRaw.Trim().Split(" ")[0]
    Write-Host "Found PID: $appPid"
} else {
    Write-Host "PID not found. Will fall back to filtering by package name."
    $appPid = $null
}

if ($ErrorsOnly) {
    if ($appPid) {
        Write-Host "Capturing error-level logs for PID $appPid to $outpath (press Ctrl+C to stop)..."
        & adb logcat --pid=$appPid *:E -v time | ForEach-Object { $line = $_.ToString(); $line | Out-File -FilePath $outpath -Append -Encoding utf8; $line }
    } else {
        Write-Host "Capturing error-level logs filtered by package to $outpath (press Ctrl+C to stop)..."
        & adb logcat *:E -v time | Select-String -Pattern $Package | ForEach-Object { $line = $_.ToString(); $line | Out-File -FilePath $outpath -Append -Encoding utf8; $line }
    }
} else {
    if ($appPid) {
        Write-Host "Capturing full logs for PID $appPid to $outpath (press Ctrl+C to stop)..."
        & adb logcat --pid=$appPid -v time | ForEach-Object { $line = $_.ToString(); $line | Out-File -FilePath $outpath -Append -Encoding utf8; $line }
    } else {
        Write-Host "Capturing full logs filtered by package to $outpath (press Ctrl+C to stop)..."
        & adb logcat -v time | Select-String -Pattern $Package | ForEach-Object { $line = $_.ToString(); $line | Out-File -FilePath $outpath -Append -Encoding utf8; $line }
    }
}

Write-Host "Log capture finished. Saved to: $outpath"
