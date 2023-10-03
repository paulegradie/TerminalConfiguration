$USER = $env:USERPROFILE;

function refresh {

    if ($env:COMPUTERNAME -eq "RegEx") {
        $Location1 = "D:\code\octopus\OctopusDeploy"
        $Location2 = "D:\code\octopus\OctopusDeployt\frontend"
    }
    else {
        # laptop
        $Location1 = "$USER\code\octopus\OctopusDeploy"
        $Location2 = "$USER\code\octopus\OctopusDeploy\frontend"
    }

    Set-Location $Location1
    ./environment.cmd clean
    git clean -fdx
    ./environment.cmd setup
    Set-Location $Location2
    npm i --no-save
}


function fromBase64String ([string]$arg) {
    Write-Host [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($arg));
}