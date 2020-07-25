$DDRIVE = "D:\"

function home {Set-Location "$DDRIVE"}

######### Octopus location aliases #############
function od { Set-Location "$DDRIVE\code\octopus\OctopusDeploy" }
function portal { Set-Location "$DDRIVE\code\octopus\OctopusDeploy\newportal" }
function oct { Set-Location "$DDRIVE\code\octopus\" }
function bouncer { ServiceBouncer.exe }
function prep { npm i --no-save }
function cli { Set-Location "$DDRIVE\code\octopus\OctopusCLI" }


############# Personal Location Aliases
function board { Set-Location "$DDRIVE\code\dashboard"}
function conv { Set-Location "$DDRIVE\code\ConvoBuilder"}
function port { Set-Location "$DDRIVE\code\ConvoBuilder\dashboard\portal"}
function dcf {Set-Location "$DDRIVE\code\Dashboard-Configuration-Frontend"}

