$h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
$body = @{ 
  title = 'CI: bump Pages actions to v2'
  head  = 'fix/update-pages-actions'
  base  = 'main'
  body  = 'Bump actions/upload-pages-artifact and actions/deploy-pages to v2 to avoid a deprecated dependency that uses actions/upload-artifact v3.'
}
$json = $body | ConvertTo-Json -Depth 6
try {
  $resp = Invoke-RestMethod -Method Post -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls' -Headers $h -Body $json -ContentType 'application/json'
  $resp | ConvertTo-Json -Depth 6
} catch {
  Write-Error "API request failed: $($_.Exception.Message)"
  if ($_.Exception.Response) { $bodyText = $_.Exception.Response.Content; Write-Output $bodyText }
  exit 1
}
