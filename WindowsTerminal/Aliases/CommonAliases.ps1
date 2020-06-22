## Remove unwanted powershell aliases
Remove-Alias -Name gcm -Force
Remove-Alias -Name ls -Force
Remove-Alias -Name gp -Force
Remove-Alias -Name cli -Force
Remove-Alias -Name rm -Force
Remove-Alias -Name sl -Force

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
function gcm {git commit -m "$args[0]"}
function gau {git add -u}
