function home { Set-Location "G:\code\" }

############# Personal Location Aliases
$SAILFISH = "G:\code\Sailfish\";
function sail { Set-Location $SAILFISH }


# just for reference on how to create multiple panes if you need to
# function startup {
#     wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
# }