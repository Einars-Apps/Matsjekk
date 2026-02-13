param(
    [int]$IntervalSeconds = 300
)

# Simple monitor that polls GitHub Actions runs for this repo every $IntervalSeconds
while ($true) {
    if (-not $env:GITHUB_TOKEN) {
        Write-Output "GITHUB_TOKEN not set in environment; sleeping for $IntervalSeconds seconds"
        Start-Sleep -Seconds $IntervalSeconds
        continue
    }

    $h = @{ Authorization = "token $env:GITHUB_TOKEN"; 'User-Agent' = 'mat_sjekk-agent' }
    try {
        $runs = Invoke-RestMethod -Uri 'https://api.github.com/repos/Einars-Apps/Matsjekk/actions/runs?per_page=20' -Headers $h -ErrorAction Stop
        $runs.workflow_runs | Select-Object id,name,status,conclusion,head_branch,created_at,html_url | Format-Table -AutoSize
    } catch {
        Write-Output "API error: $_"
    }

    Write-Output "--- checked at: $(Get-Date)"
    Start-Sleep -Seconds $IntervalSeconds
}
