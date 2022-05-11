## Remove unwanted powershell aliases
try {
    Remove-Alias -Name gcm -Force
    Remove-Alias -Name ls -Force
    Remove-Alias -Name gp -Force
    Remove-Alias -Name cli -Force
    Remove-Alias -Name rm -Force
    Remove-Alias -Name sl -Force
} catch {
    If (Test-Path Alias:gcm) {Remove-Item Alias:gcm -Force}
    If (Test-Path Alias:ls) {Remove-Item Alias:ls -Force}
    If (Test-Path Alias:gp) {Remove-Item Alias:gp -Force}
    If (Test-Path Alias:cli) {Remove-Item Alias:cli -Force}
    If (Test-Path Alias:rm) {Remove-Item Alias:rm -Force}
    If (Test-Path Alias:sl) {Remove-Item Alias:sl -Force}

}

############ utilities
function settings {set-location ${USER}\.SettingsAndConfigurations\}
function prof { code $PROFILE.CurrentUserAllHosts}
function ls {$(Get-ChildItem $args[0]).Name}
function lsa {$(Get-ChildItem $args[0])}
function rm {
    if ($args[0] = "-rf") {
        $(Remove-Item -Recurse ...$args[1])
    }
    else {
        $(Remove-Item $args[0])
    }
}
####################### GIT ##################
# git aliases
function gco {
    $opt = $args[0];
    $branch = $args[1]
    git checkout "$opt" "$branch"
}
function gpo {
    $branch = $args[0]
    git push origin "$branch"
}

function gpfo {
    $branch = $args[0]
    git push -f origin "$branch"

}

function gbd {
    git branch -d $args[0]
}

function gbdf {
    git branch -D $args[0]
}

function gst {git status}
function gp {git pull}
function gb {git branch}
function gbr {git branch -r}
function gcm {git commit -m "$args"}
function gau {git add -u}
