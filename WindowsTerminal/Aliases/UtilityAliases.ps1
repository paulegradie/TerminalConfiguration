## Remove unwanted powershell aliases
try {
    Remove-Alias -Name ls -Force
    Remove-Alias -Name cli -Force
    Remove-Alias -Name rm -Force
    Remove-Alias -Name sl -Force
}
catch {
    If (Test-Path Alias:ls) { Remove-Item Alias:ls -Force }
    If (Test-Path Alias:cli) { Remove-Item Alias:cli -Force }
    If (Test-Path Alias:rm) { Remove-Item Alias:rm -Force }
    If (Test-Path Alias:sl) { Remove-Item Alias:sl -Force }

}

function settings {
    # Get the Current User Current Host profile path
    $CurrentUserCurrentHost = ($profile | Select-Object -Property CurrentUserCurrentHost).CurrentUserCurrentHost

    # Get the parent of the parent directory of the current profile path
    $GrandParentDir = Split-Path -Parent (Split-Path -Parent $CurrentUserCurrentHost)

    # Get parent dir of the Windows Terminal Dir (the settings dir)
    Set-Location (Split-Path -Parent $GrandParentDir)
}

function prof { code $PROFILE.CurrentUserCurrentHost }
function ls { $(Get-ChildItem $args[0]).Name }
function lsa { $(Get-ChildItem $args[0]) }
function rm {
    if ($args[0] = "-rf") {
        $(Remove-Item -Recurse ...$args[1])
    }
    else {
        $(Remove-Item $args[0])
    }
}
