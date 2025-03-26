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

# 4. Add the include line if not already present
$IncludeLine = ". `"$ProfileScriptPath`""
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

Write-Host ""
Write-Host "Setup complete."
Write-Host "Restart Windows Terminal or run the following to apply changes:"
Write-Host ". $PROFILE"
