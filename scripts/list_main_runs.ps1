$h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
try {
  $runs = Invoke-RestMethod -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs?per_page=50' -Headers $h
  $filter = $runs.workflow_runs | Where-Object { $_.head_branch -in @('main','fix/fetch-farmshops-lfs') } | Select-Object id,name,status,conclusion,head_branch,created_at,html_url
  $filter | ConvertTo-Json -Depth 4
} catch {
  Write-Error "API error: $($_.Exception.Message)"
  if ($_.Exception.Response) { $_.Exception.Response.Content | Out-String | Write-Output }
  exit 1
}
