## In powershell, my current understanding is that I need
## use functions to assign aliases.

$USER = $env:USERPROFILE;

###### General Nav Helpers ##########
function .. {Set-Location ..}
function ... {Set-Location ../..}
function .... {Set-Location ../../..}
function ..... {Set-Location ../../../..}
function ...... {Set-Location ../../../../..}


######### Octopus location aliases #############
set-location "$USER\Documents\code\octopus\OctopusDeploy"
function od { Set-Location "$USER\Documents\code\octopus\OctopusDeploy" }
function portal { Set-Location "$USER\Documents\code\octopus\OctopusDeploy\newportal" }
function oct { Set-Location "$USER\Documents\code\octopus\" }
function bouncer { ServiceBouncer.exe }
function prep { npm i --no-save }
function cli { Set-Location "$USER\Documents\code\octopus\OctopusCLI" }


############# Personal Location Aliases
function proj { Set-Location "$USER\Documents\code\projects\"}
function board { Set-Location "$USER\Documents\code\projects\dashboard"}
function conv { Set-Location "$USER\Documents\code\projects\ConvoBuilder"}
function port { Set-Location "$USER\Documents\code\projects\ConvoBuilder\dashboard\portal"}
function dcf {Set-Location "$USER\Documents\code\projects\Dashboard-Configuration-Frontend"}

