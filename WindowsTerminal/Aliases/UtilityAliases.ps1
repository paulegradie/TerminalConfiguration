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
    # Go to the root of the TerminalConfiguration repo
    $SettingsRepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    Set-Location $SettingsRepoRoot
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
