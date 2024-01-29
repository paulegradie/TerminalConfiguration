## In powershell, my current understanding is that I need
## use functions to assign aliases.

###### General Nav Helpers ##########
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }
function ...... { Set-Location ../../../../.. }

$Code = "C:\Users\paule\code\"
######### Job location aliases #############
function empower { Set-Location "$Code\empower\empower-app"}

############# Personal Location Aliases
function sail { Set-Location "$Code\Sailfish\"}

# function startup {
#     wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
# }