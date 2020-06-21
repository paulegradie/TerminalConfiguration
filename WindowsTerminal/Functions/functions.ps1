$USER = $env:USERPROFILE;

function refresh {
    Set-Location "$USER\Documents\code\octopus\OctopusDeploy"
    ./environment.cmd clean
    git clean -fdx
    ./environment.cmd setup
    Set-Location "$USER\Documents\code\octopus\OctopusDeploy\newportal"
    npm i --no-save
}
