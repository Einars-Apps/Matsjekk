param(
  [string]$AliasName = 'serve-docs',
  [string]$ScriptPath = "$PSScriptRoot\..\serve-docs.ps1"
)

$profilePath = $profile.CurrentUserAllHosts
if (-not (Test-Path -Path $profilePath)) {
  New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

Write-Host "About to add alias '$AliasName' -> '$ScriptPath' to your PowerShell profile: $profilePath"
$confirm = Read-Host "Proceed and append alias to profile? (y/n)"
if ($confirm -ne 'y') { Write-Host "Aborted."; exit 0 }

$aliasLine = "Set-Alias -Name $AliasName -Value \"powershell -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" -Port 8000 -Root docs\""
Add-Content -Path $profilePath -Value "`n# Alias added by mat_sjekk helper`n$aliasLine`n"
Write-Host "Alias added. Restart PowerShell or run `& $profilePath` to load it now."