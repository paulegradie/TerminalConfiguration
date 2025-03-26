# Use the actual folder where profile.ps1 resides
$BaseDir = Split-Path -Parent $PSScriptRoot

# Source Functions and Aliases
. (Join-Path $BaseDir "Functions\functions.ps1")
. (Join-Path $BaseDir "Aliases\UtilityAliases.ps1")
. (Join-Path $BaseDir "Aliases\GitAliases.ps1")

# Conditional aliases based on machine name
if ($env:COMPUTERNAME -match "Paul") {
    . (Join-Path $BaseDir "Aliases\DesktopAliases.ps1")
} else {
    . (Join-Path $BaseDir "Aliases\LaptopAliases.ps1")
}

# Oh My Posh setup
# To load other themes, download them and add to PoshConfigs. Then load them here
#'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/material.omp.json'
$configBase = Join-Path $BaseDir "PoshConfigs"
oh-my-posh init pwsh --config (Join-Path $configBase "material.json") | Invoke-Expression

# Set working directory - customize this as you please
if ($env:COMPUTERNAME -match "Paul") {
    Set-Location "G:\code\"
} else {
    Set-Location "$HOME\code"
}

# Chocolatey tab completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module $ChocolateyProfile
}
