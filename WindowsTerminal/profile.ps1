# This is my profile for PowerShell 7.0 (not to be confused with Windows PowerShell 5.1) -- the profile directory is different
# %USERPROFILE%\Documents\PowerShell\profile.ps1
# Shortcut to open with vs code: >code $PROFILE.CurrentUserAllHosts
# https://mathieubuisson.github.io/powershell-linux-bash/

## Remove unwanted powershell aliases
Remove-Alias -Name gcm -Force
Remove-Alias -Name ls -Force
Remove-Alias -Name gp -Force
Remove-Alias -Name cli -Force
Remove-Alias -Name rm -Force
Remove-Alias -Name sl -Force

###### Some Development Only Environment Variables Std #############
$env:OCTOPUS_CLI_SERVER="http://localhost:8065"
$env:OCTOPUS_CLI_USERNAME="Admin"
$env:OCTOPUS_CLI_PASSWORD="Password01!"

###### General Nav Helpers ##########
function .. {Set-Location ..}
function ... {Set-Location ../..}
function .... {Set-Location ../../..}
function ..... {Set-Location ../../../..}
function ...... {Set-Location ../../../../..}


######### Octopus location aliases #############
set-location "%USERPROFILE%\Documents\code\octopus\OctopusDeploy"
function od { Set-Location "%USERPROFILE%\Documents\code\octopus\OctopusDeploy" }
function portal { Set-Location "%USERPROFILE%\Documents\code\octopus\OctopusDeploy\newportal" }
function oct { Set-Location "%USERPROFILE%\Documents\code\octopus\" }
function bouncer { ServiceBouncer.exe }
function prep { npm i --no-save }
function cli { Set-Location "%USERPROFILE%\Documents\code\octopus\OctopusCLI" }


function refresh {
    Set-Location "C:\Users\paule\Documents\code\octopus\OctopusDeploy"
    ./environment.cmd clean
    git clean -fdx
    ./environment.cmd setup
    Set-Location "C:\Users\paule\Documents\code\octopus\OctopusDeploy\newportal"
    npm i --no-save
}


############# Personal Location Aliases
function board { Set-Location "%USERPROFILE%\Documents\code\projects\dashboard"}
function conv { Set-Location "%USERPROFILE%\Documents\code\projects\ConvoBuilder"}
function port { Set-Location "%USERPROFILE%\Documents\code\projects\ConvoBuilder\dashboard\portal"}
function dcf {Set-Location "%USERPROFILE%\Documents\code\projects\Dashboard-Configuration-Frontend"}

############ utilities
function prof { code $PROFILE.CurrentUserAllHosts}
function ls {$(Get-ChildItem $args[0]).Name}
function lsa {$(Get-ChildItem $args[0])}
function rm {
    if ($args[0] = "-rf") {
        $(Remove-Item -Recurse ...$args[1])
    }
    else {
        $(Remove-Item $args[0])
    }
}
####################### GIT ##################
# git aliases
function gco {
    $opt = $args[0];
    $branch = $args[1]
    git checkout "$opt" "$branch"
}
function gpo {
    $branch = $args[0]
    git push origin "$branch"
}

function gbd {
    git branch -d $args[0]
}

function gbdf {
    git branch -D $args[0]
}

function gst {git status}
function gp {git pull}
function gb {git branch}
function gbr {git branch -r}
function gcm {git commit -m "$args[0]"}
function gau {git add -u}

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