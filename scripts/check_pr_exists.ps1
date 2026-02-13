$h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
try {
  $prs = Invoke-RestMethod -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls?state=all&per_page=100' -Headers $h
  $match = $prs | Where-Object { $_.head.ref -eq 'fix/update-pages-actions' }
  if ($match) { $match | Select-Object number,state,title,html_url | ConvertTo-Json -Depth 4; exit 0 } else { Write-Output 'NO_MATCH' ; exit 0 }
} catch {
  Write-Error "API error: $($_.Exception.Message)"
  if ($_.Exception.Response) { $_.Exception.Response.Content | Out-String | Write-Output }
  exit 1
}
