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
set-location "$USER\code\octopus\OctopusDeploy"
function od { Set-Location "$USER\code\octopus\OctopusDeploy" }
function portal { Set-Location "$USER\code\octopus\OctopusDeploy\newportal" }
function oct { Set-Location "$USER\code\octopus\" }
function bouncer { ServiceBouncer.exe }
function prep { npm i --no-save }
function cli { Set-Location "$USER\code\octopus\OctopusCLI" }


############# Personal Location Aliases
$SERVER = "$USER\code\palavyr\Configuration-Manager\server";
$PORT = "$USER\code\palavyr\Configuration-Manager\frontend";
$PDF = "$USER\code\palavyr\Configuration-Manager\pdf-server";
$MANAGER = "$USER\code\palavyr\Configuration-Manager";
$WIDGET = "$USER\code\palavyr\Configuration-Manager\widget";

function serv { Set-Location $SERVER}
function port { Set-Location $PORT}
function pdf {Set-Location $PDF}
function widget {Set-Location $WIDGET}
function manager {Set-Location $MANAGER}

function startup {
    wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
}