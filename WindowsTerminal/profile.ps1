# This is my profile for PowerShell 7.0 (not to be confused with Windows PowerShell 5.1) -- the profile directory is different
# %USERPROFILE%\Documents\PowerShell\profile.ps1
# Shortcut to open with vs code: >code $PROFILE.CurrentUserAllHosts
# https://mathieubuisson.github.io/powershell-linux-bash/

###### Some Development Only Environment Variables Std #############
$env:OCTOPUS_CLI_SERVER="http://localhost:8065"
$env:OCTOPUS_CLI_USERNAME="Admin"
$env:OCTOPUS_CLI_PASSWORD="Password01!"

$USER = $env:USERPROFILE;

. $USER/.SettingsAndConfigurations/WindowsTerminal/Functions/functions.ps1
. $USER/.SettingsAndConfigurations/WindowsTerminal/Aliases/aliases.ps1


## POWER LINE FOR AWESOME GIT DETAILS
# Installation instructions: https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup
# To add a custom Font Symbol, take the .tff file for a given font you like, then open it with FontForge, add the svg icon into the position you prefer, and then save it and install it. Use that font
# and specify the font character by assigning, e.g. $sl.PromptSymbols.ElevatedSymbol = [char]::ConvertFromUtf32(0x80)
# See current profile for details:
# The current profile AgnosterSlim is in %USERPROFILE%\Documents\PowerShell\Modules\oh-my-posh\2.0.412\Themes\AgnosterSlim.psm1

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme AgnosterSlim

### Other available default themes you can choose from!
# Set-Theme Agnoster
# Set-Theme AgnosterPlus
# Set-Theme Avit
# Set-Theme Powerlevel10k-Classic
# Set-Theme Powerlevel10k-Lean
# Set-Theme Powerline
# Set-Theme pure
# Set-Theme tehrob
# Set-Theme Paradox
# Set-Theme Sorin
# Set-Theme Darkblood
# Set-Theme Avit
# Set-Theme Honukai
# Set-Theme Fish
# Set-Theme robbyrussell