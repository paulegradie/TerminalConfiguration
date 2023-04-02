## In powershell, my current understanding is that I need
## use functions to assign aliases.

$USER = $env:USERPROFILE;
###### General Nav Helpers ##########
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }
function ...... { Set-Location ../../../../.. }


######### Octopus location aliases #############
try {

    set-location "$USER\code\octopus\OctopusDeploy"
    function od { Set-Location "$USER\code\octopus\OctopusDeploy" }
    function portal { Set-Location "$USER\code\octopus\OctopusDeploy\newportal" }
    function oct { Set-Location "$USER\code\octopus\" }
    function perf { Set-Location "$USER\code\octopus\CorePlatformServices" }
    function bouncer { ServiceBouncer.exe }
    function prep { npm i --no-save }
    function cli { Set-Location "$USER\code\octopus\OctopusCLI" }
}
catch {
    // do nothing
}
    
    
############# Personal Location Aliases
$SERVER = "$USER\code\palavyr\Palavyr\server";
$PORT = "$USER\code\palavyr\Palavyr\ui";
$PDF = "$USER\code\palavyr\palavyr-pdf-server";
$FRAME = "$USER\code\palavyr-chat-widget";
$WEBSITE = "$USER\code\palavyr\Palavyr-Website";
$SAILFISH = "$USER\code\Sailfish";

function serv { Set-Location $SERVER }
function port { Set-Location $PORT }
function pdf { Set-Location $PDF }
function widget { Set-Location $WIDGET }
function manager { Set-Location $MANAGER }
function design { Set-Location $DESIGN }
function frame { Set-Location $FRAME }
function web { Set-Location $WEBSITE }
function sail { Set-Location $SAILFISH }

function startup {
    wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
}