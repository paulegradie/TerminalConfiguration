## Remove unwanted powershell aliases
try {
    Remove-Alias -Name gcm -Force
    Remove-Alias -Name gp -Force
    Remove-Alias -Name gcmp -Force
}
catch {
    If (Test-Path Alias:gp) { Remove-Item Alias:gp -Force }
    If (Test-Path Alias:gcm) { Remove-Item Alias:gcm -Force }
    If (Test-Path Alias:gcmp) { Remove-Item Alias:gcmp -Force }
}

function gcm {
    param (
        [string]$commitMessage
    )

    $branchName = git rev-parse --abbrev-ref HEAD
    if ($branchName -match "^(\d+)-[a-zA-Z0-9\-]+") {
        $number = [int]$matches[1]
        $prefix = "PLA-$number"
        $prefixedMessage = "$prefix $commitMessage"
        git commit -m $prefixedMessage
    }
    else {
        git commit -m $commitMessage
    }
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
function gau { git add -u }

