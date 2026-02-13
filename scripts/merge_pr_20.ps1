$h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
$body = @{ merge_method = 'merge'; commit_title = 'Merge PR #20: Fix/update pages actions'; commit_message = 'Merging PR #20 to bump Pages actions to v2' } | ConvertTo-Json -Depth 6
try {
  $resp = Invoke-RestMethod -Method Put -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/pulls/20/merge' -Headers $h -Body $body -ContentType 'application/json'
  $resp | ConvertTo-Json -Depth 6
} catch {
  Write-Error "API request failed: $($_.Exception.Message)"
  if ($_.Exception.Response) { $_.Exception.Response.Content | Out-String | Write-Output }
  exit 1
}
