## In powershell, my current understanding is that I need
## use functions to assign aliases.

###### General Nav Helpers ##########
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }
function ...... { Set-Location ../../../../.. }


function .u1 { Set-Location .. }
function .u2 { Set-Location ../.. }
function .u3 { Set-Location ../../.. }
function .u4 { Set-Location ../../../.. }
function .u5 { Set-Location ../../../../.. }

$Code = "C:\Users\paule\code\"

############# Personal Location Aliases
function sail { Set-Location "$Code\Sailfish\"}

# function startup {
#     wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
# }
