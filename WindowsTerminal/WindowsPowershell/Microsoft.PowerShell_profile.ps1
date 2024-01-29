
# Get the Current User Current Host profile path
$CurrentUserCurrentHost = ($profile | Select-Object -Property CurrentUserCurrentHost).CurrentUserCurrentHost

# Get the parent of the parent directory of the current profile path
$GrandParentDir = Split-Path -Parent (Split-Path -Parent $CurrentUserCurrentHost)

# Source Functions and Aliases based on their relative positions to GrandParentDir
. (Join-Path $GrandParentDir "Functions\functions.ps1")
. (Join-Path $GrandParentDir "Aliases\UtilityAliases.ps1")
. (Join-Path $GrandParentDir "Aliases\GitAliases.ps1")

# Conditionally load aliases based on computer name
if ($env:COMPUTERNAME -match "Paul") {
    . (Join-Path $GrandParentDir "Aliases\DesktopAliases.ps1")
}
else {
    . (Join-Path $GrandParentDir "Aliases\LaptopAliases.ps1")
}

$configBase = Join-Path $GrandParentDir "PoshConfigs"

# To load these locally, you just need to copy the files down locally and point to theme here

# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/bubbles.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_modern.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/tokyonight_storm.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/tonybaloney.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/marcduiker.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/material.omp.json' | Invoke-Expression

# oh-my-posh init pwsh --config (Join-Path $configBase "illusion.json") | Invoke-Expression
oh-my-posh init pwsh --config (Join-Path $configBase "material.json") | Invoke-Expression

# Navigate to the 'code' directory within the user's home directory or custom directory if specified


if ($env:COMPUTERNAME -match "Paul") {
    Set-Location "G:\code\"
}
else {
    Set-Location "C:\Users\paule\code"
}
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
