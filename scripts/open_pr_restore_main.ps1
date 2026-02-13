$h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
$body = @{ title = 'ci: restore minimal main.yml placeholder'; head = 'fix/restore-main-yml'; base = 'main'; body = 'Restore a minimal valid main.yml to remove parse errors. Replace with full workflow when ready.' }
$json = $body | ConvertTo-Json -Depth 6
try {
  $resp = Invoke-RestMethod -Method Post -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls' -Headers $h -Body $json -ContentType 'application/json'
  $resp | ConvertTo-Json -Depth 6
} catch {
  Write-Error "API request failed: $($_.Exception.Message)"
  if ($_.Exception.Response) { $_.Exception.Response.Content | Out-String | Write-Output }
  exit 1
}
