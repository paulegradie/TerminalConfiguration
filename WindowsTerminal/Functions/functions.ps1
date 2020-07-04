$USER = $env:USERPROFILE;

function refresh {

    if($env:COMPUTERNAME -eq "RegEx") {
        $Location1 = "$USER\Documents\code\octopus\OctopusDeploy"
        $Location2 = "$USER\Documents\code\octopus\OctopusDeploy\newportal"
    }
    else { # laptop
        $Location1 = "D:\code\octopus\OctopusDeploy"
        $Location2 = "D:\code\octopus\OctopusDeployt\newportal"
    }

    Set-Location $Location1
    ./environment.cmd clean
    git clean -fdx
    ./environment.cmd setup
    Set-Location $Location2
    npm i --no-save
}


function Usage {
    Write-Host "Usage: clone {repo-link} [suffix]"
    Write-Host "Suffix one of [octo, peg, or gml]"
    Write-Host ""
    Write-Host "e.g. clone git@github.com:paulegradie/SeqPyPlot.git peg"
}

function clone {

    $REPO = $args[0]
    $KEY = $args[1]
    if (!$REPO) {
        Usage
    } elseif (!$KEY) {
        Usage
    }

    $GML = "github.com-gradieml"

    if ($env:COMPUTERNAME -eq "RegEx") {
        write-host "Compute Name: $env:COMPUTERNAME"
        $PEG = "github.com-desktop"
    } else {
        $PEG = "github.com-paulegradie"
    }

    $itemtoreplace = "github.com"

    if ($KEY -eq "octo") {
        Write-Host "Cloning using desktop ssh key for paul.e.gradie"
        $newhost = $REPO -replace $itemtoreplace, $PEG
        git clone $newhost

    } elseif ($KEY -eq "peg") {
        Write-Host "Cloning using desktop ssh key for paul.e.gradie"
        $newhost = $REPO -replace $itemtoreplace, $PEG
        git clone $newhost

    } elseif ($KEY -eq "gml") {
        Write-Host "Cloning using desktop ssh key for gradie.machine.learning"
        $newhost = $REPO -replace $itemtoreplace, $GML
        git clone $newhost

    } else {
        Usage
    }

}
