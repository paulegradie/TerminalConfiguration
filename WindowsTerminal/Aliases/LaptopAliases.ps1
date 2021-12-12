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
set-location "$USER\code\octopus\OctopusDeploy"
function od { Set-Location "$USER\code\octopus\OctopusDeploy" }
function portal { Set-Location "$USER\code\octopus\OctopusDeploy\newportal" }
function oct { Set-Location "$USER\code\octopus\" }
function bouncer { ServiceBouncer.exe }
function prep { npm i --no-save }
function cli { Set-Location "$USER\code\octopus\OctopusCLI" }


############# Personal Location Aliases
$SERVER = "$USER\code\palavyr\Palavyr\server";
$PORT = "$USER\code\palavyr\Palavyr\ui";
$PDF = "$USER\code\palavyr\PalavyrPdfServer\";
$MANAGER = "$USER\code\palavyr\Palavyr";
$WIDGET = "$USER\code\palavyr\Palavyr\ui";
$DESIGN = "$USER\code\KayKayArt\KayKayDesign"
$ALI = "$USER\code\Aliqapu";
$ROOF = "$USER\code\jojo-roof-website";
$FRAME = "$USER\code\palavyr-chat-widget";


function serv { Set-Location $SERVER }
function port { Set-Location $PORT }
function pdf { Set-Location $PDF }
function widget { Set-Location $WIDGET }
function manager { Set-Location $MANAGER }
function design { Set-Location $DESIGN }
function ali { Set-Location $ALI }
function roof { Set-Location $ROOF; code .; npm run dev }
function frame { Set-Location $FRAME }

function startup {
    wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
}