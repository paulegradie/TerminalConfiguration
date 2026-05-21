# Ensure errors halt the script
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Running TerminalConfiguration setup..."

# 1. Locate the path to this script and calculate the correct profile path
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProfileScriptPath = Join-Path $ScriptDirectory "WindowsPowershell\profile.ps1"

# 2. Validate that profile.ps1 exists
if (-not (Test-Path $ProfileScriptPath)) {
    Write-Host "Cannot find profile.ps1 at: $ProfileScriptPath"
    exit 1
}

# 3. Ensure the user's PowerShell profile file exists
if (-not (Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    Write-Host "Created PowerShell profile at: $PROFILE"
}

# 4. Add the include line if not already present, stripping any stale lines
#    that reference a previous TerminalConfiguration repo location.
$IncludeLine = ". `"$ProfileScriptPath`""

if (Test-Path $PROFILE) {
    $existing = Get-Content $PROFILE
    $stalePattern = '^\s*\.\s+".*TerminalConfiguration[^"]*\\WindowsPowershell\\profile\.ps1"\s*$'
    $kept = $existing | Where-Object {
        -not ($_ -match $stalePattern -and $_ -ne $IncludeLine)
    }
    $removed = $existing.Count - $kept.Count
    if ($removed -gt 0) {
        Set-Content -Path $PROFILE -Value $kept
        Write-Host "Removed $removed stale TerminalConfiguration include line(s) from PROFILE"
    }
}

$ProfileContent = ""
if (Test-Path $PROFILE) {
    $ProfileContent = Get-Content $PROFILE -Raw
}

if ([string]::IsNullOrWhiteSpace($ProfileContent) -or
    $ProfileContent -notmatch [regex]::Escape($IncludeLine)) {

    Add-Content -Path $PROFILE -Value "`n$IncludeLine"
    Write-Host "Added sourcing of your repo's profile.ps1 to PowerShell profile"
} else {
    Write-Host "Sourcing line already present in PowerShell profile"
}

# 5. Pin personal identity + activate versioned pre-commit hook for this repo.
#    Routes ssh through a personal key so the work machine can't push as work identity.
$RepoRoot = Split-Path -Parent $ScriptDirectory
$ExpectedName = "Paul Gradie"
$ExpectedEmail = "paul.e.gradie@gmail.com"
$PersonalKey = Join-Path $HOME ".ssh\id_ed25519_personal"

Write-Host ""
Write-Host "Configuring local git identity and hooks for this repo..."
git -C $RepoRoot config --local user.name $ExpectedName
git -C $RepoRoot config --local user.email $ExpectedEmail
git -C $RepoRoot config --local core.hooksPath ".githooks"

if (Test-Path $PersonalKey) {
    $sshKeyForGit = $PersonalKey -replace '\\', '/'
    git -C $RepoRoot config --local core.sshCommand "ssh -i '$sshKeyForGit' -o IdentitiesOnly=yes -o IdentityAgent=none"
    Write-Host "core.sshCommand set to use $PersonalKey"
} else {
    Write-Warning "Personal SSH key not found at $PersonalKey"
    Write-Warning "Generate one and add the .pub to your personal GitHub, then re-run this script:"
    Write-Warning "  ssh-keygen -t ed25519 -C `"$ExpectedEmail`" -f `"$PersonalKey`""
    git -C $RepoRoot config --local --unset core.sshCommand 2>$null
}

Write-Host ""
Write-Host "Setup complete."
Write-Host "Restart Windows Terminal or run the following to apply changes:"
Write-Host ". $PROFILE"
