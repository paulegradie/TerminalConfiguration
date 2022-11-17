$UserSettings = $env:USERPROFILE + "\OneDrive\.SettingsAndConfiguration"
. $UserSettings/WindowsTerminal/Functions/functions.ps1
. $UserSettings/WindowsTerminal/Aliases/CommonAliases.ps1

Import-Module posh-git

# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/bubbles.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_modern.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/tokyonight_storm.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/tonybaloney.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/material.omp.json' | Invoke-Expression
# oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/marcduiker.omp.json' | Invoke-Expression
oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/illusi0n.omp.json' | Invoke-Expression


if($env:COMPUTERNAME -eq "RegEx") {
    . $UserSettings/WindowsTerminal/Aliases/DesktopAliases.ps1
} else {
    . $UserSettings/WindowsTerminal/Aliases/LaptopAliases.ps1
    Set-Location ${USER}/code
}
