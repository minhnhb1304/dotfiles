# PowerShell profile managed by chezmoi (luanquangminh/dotfiles).
# Mirrors the zsh setup: mise activation, starship prompt, and common aliases.
# Edit the source at .chezmoitemplates/powershell-profile.ps1, then `chezmoi apply`.

$env:EDITOR = "nvim"

# mise: tool versions + project env
if (Get-Command mise -ErrorAction SilentlyContinue) {
    (& mise activate pwsh) | Out-String | Invoke-Expression
}

# starship prompt
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
}

# zoxide: smarter cd (use `z <dir>`)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# Aliases / functions mirroring the zsh config
if (Get-Command eza -ErrorAction SilentlyContinue) {
    function ll { eza -la --git --icons @args }
    function la { eza -a  --icons @args }
    function ls { eza      --icons @args }
}
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat @args }
}
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    function vim { nvim @args }
}
Set-Alias -Name g -Value git
