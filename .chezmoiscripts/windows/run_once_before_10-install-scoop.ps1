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

# Make scoop reachable in THIS process. The installer adds the shims dir to the
# registry PATH (only seen by NEW processes) and to its own $env:PATH; this guard
# also covers the "already installed but not on this process's PATH" edge.
$scoopRoot = if ($env:SCOOP) { $env:SCOOP } else { Join-Path $env:USERPROFILE 'scoop' }
$shims = Join-Path $scoopRoot 'shims'
if ((Test-Path $shims) -and ($env:PATH -notlike "*$shims*")) {
    $env:PATH = "$shims;$env:PATH"
}

# git is required by scoop for buckets and updates; install it first if missing.
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[scoop] installing git"
    scoop install git
}

# Note: all packages used by this repo live in the scoop 'main' bucket (added by the
# installer automatically), so no extra bucket is needed.

Write-Host "[scoop] ready"
