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

