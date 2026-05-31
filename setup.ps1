# Windows bootstrap for luanquangminh/dotfiles
# Usage (PowerShell, no admin):
#   irm https://raw.githubusercontent.com/luanquangminh/dotfiles/master/setup.ps1 | iex
$ErrorActionPreference = "Stop"

function Test-Cmd($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

Write-Host "[setup] dotfiles for Windows"

# 1) Install chezmoi (prefer winget, then scoop, else bootstrap scoop).
if (-not (Test-Cmd chezmoi)) {
    Write-Host "[setup] installing chezmoi..."
    if (Test-Cmd winget) {
        winget install --id twpayne.chezmoi --exact --source winget --silent `
            --accept-package-agreements --accept-source-agreements --disable-interactivity
    }
    elseif (Test-Cmd scoop) {
        scoop install chezmoi
    }
    else {
        try { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force } catch {}
        Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
        scoop install chezmoi
    }
}

# 2) Initialize from this repo and apply.
#    chezmoi prompts for git name/email; Windows-only targeting is handled by .chezmoiignore.
chezmoi init --apply luanquangminh

Write-Host "[setup] done. Open a new PowerShell session to load your profile."
