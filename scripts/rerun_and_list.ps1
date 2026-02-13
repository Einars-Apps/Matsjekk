$h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
try {
  Invoke-RestMethod -Method Post -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs/21969135090/rerun' -Headers $h -ErrorAction Stop
  Write-Output 'Rerun requested'
} catch {
  Write-Error $_.Exception.Message
  if ($_.Exception.Response) { $_.Exception.Response.Content | Out-String | Write-Output }
}
Start-Sleep -Seconds 3
$runs = Invoke-RestMethod -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs?per_page=50' -Headers $h
$filter = $runs.workflow_runs | Where-Object { $_.name -eq 'Deploy docs to GitHub Pages' -and $_.head_branch -eq 'main' } | Select-Object id,status,conclusion,created_at,html_url | Sort-Object created_at -Descending | Select-Object -First 5
$filter | ConvertTo-Json -Depth 4
