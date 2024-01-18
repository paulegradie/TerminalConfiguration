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


############# Personal Location Aliases
$SAILFISH = "G:\code\Sailfish\";
function sail { Set-Location $SAILFISH }

# function startup {
#     wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
# }