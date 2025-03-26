function fromBase64String ([string]$arg) {
    Write-Host [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($arg));
}

function Get-PrFromCommit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$CommitSha, # partial sha is okay here

        [Parameter(Mandatory = $false)]
        [string]$RepoOwner = "empowerfinance",

        [Parameter(Mandatory = $false)]
        [string]$RepoName = "empower-app"
    )

    $Repo = "$RepoOwner/$RepoName"

    try {
        $prInfo = gh api `
            -H "Accept: application/vnd.github.groot-preview+json" `
            "repos/$Repo/commits/$CommitSha/pulls" 2>$null
    } catch {
        Write-Warning "GitHub CLI failed. Is your token set up and authenticated? - To install with choco: choco install gh"
        return
    }

    if (-not $prInfo -or $prInfo -eq "[]") {
        Write-Host "No PRs found for commit $CommitSha in $Repo"
        return
    }

    $prList = $prInfo | ConvertFrom-Json

    foreach ($pr in $prList) {
        Write-Host "Commit $CommitSha is part of PR #$($pr.number): $($pr.title)"
        Write-Host "URL: $($pr.html_url)"
    }
}
