<#
publish_to_github_pages.ps1
Interactive helper to initialize a git repo, commit, create a GitHub repo (optional via gh), and push to main.
Run this in your project root (C:\Users\ebors\mat_sjekk).
Requires: Git installed and available in PATH. Optional: GitHub CLI (`gh`) for automatic repo creation.
#>

Set-StrictMode -Version Latest

function Prompt-YesNo($msg, $default=$true) {
    $yn = if ($default) { "Y/n" } else { "y/N" }
    while ($true) {
        $r = Read-Host "$msg [$yn]"
        if ([string]::IsNullOrWhiteSpace($r)) { return $default }
        switch ($r.ToLower()) {
            'y' { return $true }
            'yes' { return $true }
            'n' { return $false }
            'no' { return $false }
            default { Write-Host "Svar med y/n" }
        }
    }
}

function Check-Command($cmd) {
    $which = Get-Command $cmd -ErrorAction SilentlyContinue
    return $which -ne $null
}

if (-not (Check-Command git)) {
    Write-Host "Feil: 'git' ble ikke funnet i PATH. Installer Git for Windows (https://git-scm.com/downloads) og åpne en ny PowerShell." -ForegroundColor Red
    exit 1
}

$gitVersion = (& git --version) -join ' '
Write-Host "Git funnet: $gitVersion"

$useGh = Check-Command gh
if ($useGh) { Write-Host "GitHub CLI (gh) funnet: kan brukes til å opprette repo automatisk." -ForegroundColor Green }

# Ensure running from project root
$cwd = Get-Location
Write-Host "Arbeider i: $cwd"

# Ask for repo info
$defaultRepo = Read-Host "Skriv GitHub repo-URL (eller <USERNAME>/<REPO>) - la stå tomt for ikke å legge til remote nå"

# Initialize git repo if needed
$gitRoot = (& git rev-parse --show-toplevel 2>$null) 2>$null
if (-not $gitRoot) {
    Write-Host "Initialiserer git repository..."
    git init
    git branch -M main
} else {
    Write-Host "Repository allerede initialisert: $gitRoot"
}

# Add all and commit
Write-Host "Legger til filer og committer..."
try {
    git add .
    # If there is something to commit
    $status = git status --porcelain
    if ($status) {
        git commit -m "Initial commit - add project and docs site"
    } else {
        Write-Host "Ingen endringer å commite. Fortsetter."
    }
} catch {
    Write-Host "Feil under git add/commit: $_" -ForegroundColor Yellow
}

# Create remote & push
if ($defaultRepo) {
    $remoteUrl = $defaultRepo
    # If user provided <username>/<repo>, expand to https URL
    if ($remoteUrl -notmatch 'https?://') {
        if ($remoteUrl -match '^[^/]+/[^/]+$') {
            $userRepo = $remoteUrl
            $remoteUrl = "https://github.com/$userRepo.git"
        }
    }

    # If gh is available and user wants to use it
    if ($useGh -and (Prompt-YesNo "Vil du at jeg skal prøve å opprette repo via 'gh' (krever at du er logget inn med gh)?" $true)) {
        try {
            # If input was <user>/<repo>, use that
            $createArg = $null
            if ($defaultRepo -match '^[^/]+/[^/]+$') { $createArg = $defaultRepo }
            if ($createArg) {
                gh repo create $createArg --public --source=. --remote=origin --push | Out-Host
            } else {
                gh repo create --public --source=. --remote=origin --push | Out-Host
            }
            Write-Host "Repo opprettet og pushet via gh."
            Write-Host "Siden blir tilgjengelig under Settings -> Pages (velg branch main og folder /docs)." -ForegroundColor Green
            exit 0
        } catch {
            Write-Host "gh kommando feilet eller du er ikke logget inn. Feil: $_" -ForegroundColor Yellow
            # fallback to manual remote add
        }
    }

    # Add remote if not exists
    $existing = git remote get-url origin 2>$null
    if (-not $existing) {
        Write-Host "Legger til remote origin -> $remoteUrl"
        git remote add origin $remoteUrl
    } else {
        Write-Host "Remote origin finnes allerede: $existing"
    }

    Write-Host "Pusher til origin main..."
    try {
        git push -u origin main
        Write-Host "Push fullført." -ForegroundColor Green
    } catch {
        Write-Host "Push feilet: $_" -ForegroundColor Red
        Write-Host "Hvis du får autentiseringsfeil, følg GitHub-instruksjonene for å konfigurere SSH eller en Personal Access Token (PAT)." -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Neste: Aktiver GitHub Pages for repoet. Gå til: https://github.com/<USERNAME>/<REPO>/settings/pages og velg Branch: main, Folder: /docs" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host "Ingen remote oppgitt. Repo er lokalt initialisert. Du kan legge til remote senere med: git remote add origin <url>" -ForegroundColor Yellow
    exit 0
}
