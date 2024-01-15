$USER = $env:USERPROFILE;
function fromBase64String ([string]$arg) {
    Write-Host [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($arg));
}