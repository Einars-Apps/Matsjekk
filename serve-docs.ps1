param(
  [int]$Port = 8000,
  [string]$Root = "docs"
)

$ErrorActionPreference = 'Stop'

function Start-PythonServer {
  param($Port, $Root)
  Push-Location -Path $PSScriptRoot
  try {
    Set-Location -Path $Root
    Write-Host "Starting Python http.server on port $Port (serving $Root)"
    # Use py launcher if available for Windows (PowerShell 5.1 compatible)
    $pyCmdObj = Get-Command py -ErrorAction SilentlyContinue
    if ($pyCmdObj) { $pyCmd = $pyCmdObj.Source } else { $pyCmd = $null }
    $pythonCmdObj = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonCmdObj) { $pythonCmd = $pythonCmdObj.Source } else { $pythonCmd = $null }
    if ($pyCmd) {
      & $pyCmd -3 -m http.server $Port --directory .
    } elseif ($pythonCmd) {
      & $pythonCmd -m http.server $Port --directory .
    } else {
      throw "No Python executable found"
    }
  } finally {
    Pop-Location
  }
}

function Start-NodeServer {
  param($Port, $Root)
  Push-Location -Path $PSScriptRoot
  try {
    Set-Location -Path $Root
    Write-Host "Starting npx http-server on port $Port (serving $Root)"
    & npx http-server -p $Port
  } finally {
    Pop-Location
  }
}

function Start-FallbackListener {
  param($Port, $Root)
  $listener = New-Object System.Net.HttpListener
  $prefix = "http://localhost:$Port/"
  $listener.Prefixes.Add($prefix)
  try {
    $listener.Start()
  } catch {
    $errMsg = if ($_.Exception) { $_.Exception.Message } else { $_.ToString() }
    Write-Error ("Failed to start listener on {0}: {1}" -f $prefix, $errMsg)
    exit 1
  }
  Write-Host "Serving '$Root' at http://localhost:$Port/ (Ctrl+C to stop)"

  while ($listener.IsListening) {
    try {
      $context = $listener.GetContext()
    } catch [System.Net.HttpListenerException] {
      break
    }
    $request = $context.Request
    $response = $context.Response

    $urlPath = $request.Url.AbsolutePath.TrimStart('/')
    if ([string]::IsNullOrEmpty($urlPath)) { $urlPath = 'index.html' }

    $fileRoot = Join-Path -Path $PSScriptRoot -ChildPath $Root
    $filePath = Join-Path -Path $fileRoot -ChildPath $urlPath

    if (Test-Path $filePath) {
      try {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
        switch ($ext) {
          '.html' { $response.ContentType = 'text/html; charset=utf-8' }
          '.css'  { $response.ContentType = 'text/css' }
          '.js'   { $response.ContentType = 'application/javascript' }
          '.json' { $response.ContentType = 'application/json' }
          '.svg'  { $response.ContentType = 'image/svg+xml' }
          '.png'  { $response.ContentType = 'image/png' }
          '.jpg' { $response.ContentType = 'image/jpeg' }
          '.jpeg' { $response.ContentType = 'image/jpeg' }
          default { $response.ContentType = 'application/octet-stream' }
        }
        $response.ContentLength64 = $bytes.LongLength
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
      } catch {
        $response.StatusCode = 500
        $writer = New-Object System.IO.StreamWriter($response.OutputStream)
        $writer.Write("Internal server error")
        $writer.Flush()
      }
    } else {
      $response.StatusCode = 404
      $writer = New-Object System.IO.StreamWriter($response.OutputStream)
      $writer.Write("404 Not Found")
      $writer.Flush()
    }
    $response.Close()
  }

  $listener.Stop()
  Write-Host "Server stopped." 
}

# Prefer Python, then Node (npx), then fallback to internal listener
if ((Get-Command py -ErrorAction SilentlyContinue) -or (Get-Command python -ErrorAction SilentlyContinue)) {
  try {
    Start-PythonServer -Port $Port -Root $Root
    return
  } catch {
    $errMsg = if ($_.Exception) { $_.Exception.Message } else { $_.ToString() }
    Write-Warning ("Python server failed: {0}" -f $errMsg)
  }
}

if (Get-Command npx -ErrorAction SilentlyContinue) {
  try {
    Start-NodeServer -Port $Port -Root $Root
    return
  } catch {
    $errMsg = if ($_.Exception) { $_.Exception.Message } else { $_.ToString() }
    Write-Warning ("npx http-server failed: {0}" -f $errMsg)
  }
}

Start-FallbackListener -Port $Port -Root $Root
