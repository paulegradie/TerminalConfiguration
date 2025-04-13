## In powershell, my current understanding is that I need
## use functions to assign aliases.

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

# function startup {
#     wt --title "Palavyr" -d $PORT `; split-pane --title "PDF Service" -d $PDF `; split-pane -H -d $WIDGET
# }


function gohome {
    $configPath = "$HOME\.ssh\config"
    $homeIdentity = "    IdentityFile ~/.ssh/home"

    if (Test-Path $configPath) {
        $content = Get-Content $configPath

        $updatedContent = $content -replace '(?<=Host github\.com\s+HostName github\.com\s+User git\s+IdentityFile )\S+', "$homeIdentity"
        
        Set-Content -Path $configPath -Value $updatedContent -Force
        Write-Host "Switched to home identity file."
    } else {
        Write-Host "SSH config file not found."
    }
}

function powerup {
    $configPath = "$HOME\.ssh\config"
    $empowerIdentity = "    IdentityFile ~/.ssh/empower"

    if (Test-Path $configPath) {
        $content = Get-Content $configPath

        $updatedContent = $content -replace '(?<=Host github\.com\s+HostName github\.com\s+User git\s+IdentityFile )\S+', "$empowerIdentity"
        
        Set-Content -Path $configPath -Value $updatedContent -Force
        Write-Host "Switched to empower identity file."
    } else {
        Write-Host "SSH config file not found."
    }
}


function Set-GitIdentity {
    param(
        [Parameter(Mandatory=$true)]
        [string]$IdentityType # "home" or "empower"
    )

    # Define identity details
    $identities = @{
        home = @{
            Name = "paulegradie"
            Email = "paulegradie@domain.com"
            HostAlias = "github.com-home"
            IdentityFile = "~/.ssh/home"
        }
        empower = @{
            Name = "empowerPaul"
            Email = "paul@empower.me"
            HostAlias = "github.com-empower"
            IdentityFile = "~/.ssh/empower"
        }
    }

    if (-not $identities.ContainsKey($IdentityType)) {
        Write-Host "Invalid identity type. Please use 'home' or 'empower'."
        return
    }

    $identity = $identities[$IdentityType]

    # Get the current directory (assumed to be the repository root)
    $RepoPath = Get-Location

    # Set Git user name and email
    git config user.name $identity.Name
    git config user.email $identity.Email

    # Update the remote URL to use the correct SSH key alias
    $currentRemoteUrl = git remote get-url origin
    $newRemoteUrl = $currentRemoteUrl -replace "github\.com", $identity.HostAlias
    git remote set-url origin $newRemoteUrl

    Write-Host "Set Git identity to $IdentityType (`$($identity.Name)` <`$($identity.Email)`>) for repository at $RepoPath."
    Write-Host "Updated remote URL to use SSH key at $($identity.IdentityFile)."
}