# Bootstrap Scoop (user-scope package manager, no admin needed). Idempotent.
# Runs once before files are applied. ASCII-only so it is safe on Windows PowerShell 5.1.
$ErrorActionPreference = "Stop"

if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "[scoop] already installed"
}
else {
    Write-Host "[scoop] installing (user scope)..."
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    }
    catch {
        Write-Host "[scoop] could not set ExecutionPolicy (continuing)"
    }
    Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
}

# git is required for buckets; install it first if missing.
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[scoop] installing git (needed for buckets)"
    scoop install git
}

# Ensure the 'extras' bucket exists (adding an existing bucket is a harmless no-op).
try {
    scoop bucket add extras
}
catch {
    # already added
}

Write-Host "[scoop] ready"
