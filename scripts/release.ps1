<#
.SYNOPSIS
    One-command release build for ALL platforms with a collision-proof build number.

.DESCRIPTION
    Implements the project's release rule so build/version codes never collide
    on Google Play or App Store Connect again:

      1. Computes ONE monotonic build number (minutes since 2020-01-01 UTC) via
         scripts/build_number.ps1, floored above the current pubspec build.
      2. Restores the committed generated localisations (lib/gen_l10n, lib/l10n)
         which Flutter's `generate: true` would otherwise delete on build.
      3. Builds the signed Android App Bundle with that exact build number.
      4. Verifies the AAB is signed and that every native .so is >=16 KB aligned.
      5. Optionally triggers the iOS TestFlight workflow, which derives the SAME
         number from the same formula -> Android and iOS stay in lock-step.

    The build number is passed via --build-number, so pubspec.yaml is NOT edited
    or committed on every build. Bump the marketing version (the part before '+'
    in pubspec) manually only when you want a new user-facing version.

.PARAMETER Ios
    Also trigger the iOS TestFlight workflow (requires the GitHub CLI `gh`).

.PARAMETER SkipAndroid
    Skip the local Android build (e.g. when you only want to ship iOS).

.EXAMPLE
    pwsh scripts/release.ps1
    # Builds a signed Android AAB with a fresh monotonic build number.

.EXAMPLE
    pwsh scripts/release.ps1 -Ios
    # Builds Android locally AND triggers the iOS TestFlight workflow.
#>
[CmdletBinding()]
param(
    [switch]$Ios,
    [switch]$SkipAndroid
)

$ErrorActionPreference = 'Stop'

# Resolve repo root (this script lives in <root>/scripts).
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

# --- 1. Compute the collision-proof build number ----------------------------
$pubspec = Get-Content 'pubspec.yaml' -Raw
if ($pubspec -notmatch '(?m)^version:\s*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)\s*$') {
    throw "Could not parse 'version: X.Y.Z+BUILD' from pubspec.yaml."
}
$versionName = $Matches[1]
$currentBuild = [int64]$Matches[2]

$buildNumber = [int64](& "$PSScriptRoot\build_number.ps1" -MinFloor $currentBuild)

Write-Host "Marketing version : $versionName"        -ForegroundColor Cyan
Write-Host "Previous build    : $currentBuild"        -ForegroundColor DarkGray
Write-Host "New build number  : $buildNumber"         -ForegroundColor Green
Write-Host ""

# --- 2 + 3. Build Android ----------------------------------------------------
if (-not $SkipAndroid) {
    Write-Host "Restoring generated localisations (gen_l10n gotcha)..." -ForegroundColor Cyan
    git checkout HEAD -- lib/gen_l10n lib/l10n 2>$null

    Write-Host "Building signed Android App Bundle..." -ForegroundColor Cyan
    flutter build appbundle --release --build-number=$buildNumber --build-name=$versionName
    if ($LASTEXITCODE -ne 0) { throw "flutter build appbundle failed." }

    $aab = Join-Path $repoRoot 'build\app\outputs\bundle\release\app-release.aab'
    if (-not (Test-Path $aab)) { throw "Expected AAB not found at $aab" }

    # --- 4. Verify signature -------------------------------------------------
    $jarsigner = 'C:\Program Files\Android\Android Studio\jbr\bin\jarsigner.exe'
    if (Test-Path $jarsigner) {
        $verify = & $jarsigner -verify $aab 2>&1
        if ($verify -match 'jar verified') {
            Write-Host "Signature         : jar verified" -ForegroundColor Green
        } else {
            Write-Warning "AAB signature could NOT be verified. Check android/key.properties."
        }
    }

    # --- 4b. Verify 16 KB native-lib alignment -------------------------------
    $ndkRoot = Join-Path $env:LOCALAPPDATA 'Android\Sdk\ndk'
    $readelf = $null
    if (Test-Path $ndkRoot) {
        $readelf = Get-ChildItem $ndkRoot -Recurse -Filter 'llvm-readelf.exe' -ErrorAction SilentlyContinue |
            Select-Object -First 1 -ExpandProperty FullName
    }
    if ($readelf) {
        $tmp = Join-Path $env:TEMP 'release_aab_check'
        if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
        New-Item -ItemType Directory -Path $tmp | Out-Null
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($aab, $tmp)

        $arm64 = Join-Path $tmp 'base\lib\arm64-v8a'
        $bad = @()
        foreach ($lib in (Get-ChildItem $arm64 -Filter '*.so' -ErrorAction SilentlyContinue)) {
            $loads = & $readelf -l $lib.FullName 2>$null | Select-String -Pattern 'LOAD'
            $aligns = ($loads | ForEach-Object { ($_ -split '\s+')[-1] }) | Sort-Object -Unique
            # 16 KB alignment = 0x4000 or larger (0x10000). 0x1000 (4 KB) is bad.
            if ($aligns -contains '0x1000') { $bad += $lib.Name }
        }
        if ($bad.Count -eq 0) {
            Write-Host "16 KB alignment   : all arm64-v8a libs OK" -ForegroundColor Green
        } else {
            Write-Warning ("These arm64-v8a libs are still 4 KB aligned: {0}" -f ($bad -join ', '))
        }
    }

    Write-Host ""
    Write-Host "Android AAB ready (versionCode $buildNumber):" -ForegroundColor Green
    Write-Host "  $aab" -ForegroundColor Green
}

# --- 5. Trigger iOS ----------------------------------------------------------
if ($Ios) {
    Write-Host ""
    Write-Host "Triggering iOS TestFlight workflow (derives the same build number)..." -ForegroundColor Cyan
    gh workflow run ios-testflight.yml --ref main
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Could not trigger iOS workflow. Is the GitHub CLI 'gh' authenticated?"
    } else {
        Start-Sleep -Seconds 5
        gh run list --workflow ios-testflight.yml --limit 1 --json databaseId,status,createdAt
    }
}

Write-Host ""
Write-Host "Done. Build number $buildNumber is higher than every previous build on both stores." -ForegroundColor Green
