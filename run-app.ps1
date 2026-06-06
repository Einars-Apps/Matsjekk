# Starter appen på telefonen med kassal.app-nøkkelen fra kassalapp.token
# Bruk: høyreklikk filen og "Run with PowerShell", eller kjør:  ./run-app.ps1
Set-Location -Path $PSScriptRoot

$tokenPath = Join-Path $PSScriptRoot 'kassalapp.token'
if (-not (Test-Path $tokenPath)) {
    Write-Error "Fant ikke kassalapp.token. Lag filen og lim inn nokkelen din."
    exit 1
}

$token = (Get-Content $tokenPath -Raw).Trim()
if ([string]::IsNullOrWhiteSpace($token) -or $token -eq 'LIM_INN_NOKKELEN_DIN_HER') {
    Write-Error "kassalapp.token er tom. Apne filen og lim inn nokkelen din, og lagre."
    exit 1
}

Write-Host "Starter app med kassal.app-nokkel (lengde: $($token.Length) tegn)..." -ForegroundColor Green
flutter run -d RFCY70C82CH --dart-define=KASSALAPP_TOKEN=$token
