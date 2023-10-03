## Remove unwanted powershell aliases
try {
    Remove-Alias -Name gcm -Force
    Remove-Alias -Name gp -Force
}
catch {
    If (Test-Path Alias:gp) { Remove-Item Alias:gp -Force }
    If (Test-Path Alias:gcm) { Remove-Item Alias:gcm -Force }
}


function gco {
    $opt = $args[0]
    $branch = $args[1]
    if ($opt -eq "-b") {
        git checkout -b "$branch"
    }
    else {
        git checkout "$opt"
    }
}

function gpo {
    $branch = $args[0]
    git push origin "$branch"
}

function gpfo {
    $branch = $args[0]
    git push -f origin "$branch"

}

function gpwr {
    $branch = $args[0]

    if ($branch -eq "") {
        throw new Error("No branch provided.")
    }

    if ($branch.ToString().StartsWith("release")) {

    }

    gco master
    git pull
    git checkout $branch
    git rebase master
    git push origin "$branch"
}

function gbd {
    git branch -d $args[0]
}

function gbdf {
    git branch -D $args[0]
}

function gst { git status }
function gp { git pull }
function gb { git branch }
function gbr { git branch -r }
function gcm { git commit -m "$args" }
function gau { git add -u }
