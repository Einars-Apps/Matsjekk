# Build the Play candidate from an isolated source copy.
# Uses the already installed Flutter 3.44.x. Does not download Flutter,
# does not change the system Flutter, and does not write the original checkout.
# Reads android/key.properties in memory. Does not print secret values.
# Does not call scripts/release.ps1 or any iOS/TestFlight workflow.
# Fails closed when the upload key is missing. Never debug-signs.

$ErrorActionPreference = 'Stop'

$IsolatedRoot = 'C:\Users\ebors\AppData\Local\Temp\Matsjekk-release-3501947-9ff67918e1304ce89d00eb4a1fa8d32c'
$OriginalRoot = 'C:\Users\ebors\Projects\Einars-Apps\Matsjekk'
$BuildName = '1.1.9'
$BuildNumber = '3501947'
# Public Play upload certificate. Compared only after the new AAB is signed.
$ExpectedSha256 = '29:F4:C1:56:AA:AB:67:28:04:89:CE:64:A0:54:0D:24:0A:73:99:12:1C:71:77:FF:D4:D6:92:FA:3A:E0:FA:80'
$ExpectedSha1 = '88:C2:17:E8:7C:E4:34:F9:2A:9E:6E:C4:2E:53:F1:0B:1E:1F:DC:BC'

if ($IsolatedRoot -eq $OriginalRoot) {
    throw 'Refusing to build inside the original checkout.'
}
if (-not (Test-Path -LiteralPath $IsolatedRoot)) {
    throw 'Isolated source directory does not exist yet.'
}

$propsPath = Join-Path $OriginalRoot 'android\key.properties'
$appDir = Join-Path $OriginalRoot 'android\app'
if (-not (Test-Path -LiteralPath $propsPath -PathType Leaf)) {
    throw 'key.properties is missing. Refusing to debug-sign.'
}

$values = @{}
foreach ($line in Get-Content -LiteralPath $propsPath) {
    $trimmed = $line.Trim()
    if ($trimmed.Length -eq 0 -or $trimmed.StartsWith('#')) { continue }
    $split = $trimmed.IndexOf('=')
    if ($split -lt 1) { continue }
    $values[$trimmed.Substring(0, $split).Trim()] = $trimmed.Substring($split + 1).Trim()
}

foreach ($name in @('keyAlias', 'keyPassword', 'storeFile', 'storePassword')) {
    if (-not $values.ContainsKey($name) -or [string]::IsNullOrWhiteSpace($values[$name])) {
        throw "Signing property $name is missing or empty. Refusing to debug-sign."
    }
}

$rawStore = $values['storeFile']
if ([System.IO.Path]::IsPathRooted($rawStore)) {
    $storePath = $rawStore
} else {
    $storePath = [System.IO.Path]::GetFullPath((Join-Path $appDir $rawStore))
}
if (-not (Test-Path -LiteralPath $storePath -PathType Leaf)) {
    throw 'Resolved keystore file is missing. Refusing to debug-sign.'
}

$flutter = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutter) {
    throw 'flutter is not on PATH. This recipe does not install or replace Flutter.'
}
$versionText = (& flutter --version | Out-String)
if ($versionText -notmatch 'Flutter 3\.44\.') {
    throw 'Expected the existing Flutter 3.44.x. This recipe does not upgrade Flutter.'
}

$env:MATSJEKK_KEY_PROPERTIES = $propsPath
$env:MATSJEKK_STORE_FILE_BASE = $appDir

Set-Location -LiteralPath $IsolatedRoot
& flutter build appbundle --release --build-name=$BuildName --build-number=$BuildNumber
if ($LASTEXITCODE -ne 0) {
    throw 'flutter build appbundle failed.'
}

$aab = Join-Path $IsolatedRoot 'build\app\outputs\bundle\release\app-release.aab'
if (-not (Test-Path -LiteralPath $aab -PathType Leaf)) {
    throw 'Release AAB was not produced.'
}

$keytool = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytool) {
    Remove-Item -LiteralPath $aab -Force
    throw 'keytool is missing, so the upload certificate was not checked. Removed the bundle.'
}

$certText = (& keytool -printcert -jarfile $aab | Out-String)
$sha256 = $null
$sha1 = $null
foreach ($line in ($certText -split "`r?`n")) {
    if ($line -match 'SHA256:\s*([0-9A-F:]+)') { $sha256 = $Matches[1].ToUpperInvariant() }
    elseif ($line -match 'SHA1:\s*([0-9A-F:]+)') { $sha1 = $Matches[1].ToUpperInvariant() }
}
if ($sha256 -ne $ExpectedSha256 -or $sha1 -ne $ExpectedSha1) {
    Remove-Item -LiteralPath $aab -Force
    throw 'Signed AAB certificate does not match the Play upload key. Removed the bundle.'
}

Write-Host 'AAB certificate matches the Play upload key. This recipe does not upload it.'
