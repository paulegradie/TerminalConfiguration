$DDRIVE = "D:"

function home {Set-Location "$DDRIVE"}

######### Octopus location aliases #############
function od { Set-Location "$DDRIVE\code\octopus\OctopusDeploy" }
function portal { Set-Location "$DDRIVE\code\octopus\OctopusDeploy\newportal" }
function oct { Set-Location "$DDRIVE\code\octopus\" }
function bouncer { ServiceBouncer.exe }
function prep { npm i --no-save }
function cli { Set-Location "$DDRIVE\code\octopus\OctopusCLI" }


############# Personal Location Aliases

$SERVER = "$DDRIVE\code\palavyr\Configuration-Manager\server";
$PORT = "$DDRIVE\code\palavyr\Configuration-Manager\frontend";
$PDF = "$DDRIVE\code\palavyr\Configuration-Manager\pdf-server";
$MANAGER = "$DDrive\code\palavyr\Configuration-Manager";
$WIDGET = "$DDrive\code\palavyr\Configuration-Manager\widget";

function serv { Set-Location $SERVER}
function port { Set-Location $PORT}
function pdf {Set-Location $PDF}
function widget {Set-Location $WIDGET}
function manager {Set-Location $MANAGER}

function startup {
    wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
}