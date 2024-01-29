function home { Set-Location "G:\code\" }

############# Personal Location Aliases
$SAILFISH = "G:\code\Sailfish\";
function sail { Set-Location $SAILFISH }


# function startup {
#     wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
# }