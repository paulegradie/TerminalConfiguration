# This setup script will modify the registry to point to this directory for $profile discovery
# Be sure to run this from the directory it is in

$currentDirectory = (Get-Location).Path
$_ = New-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' Personal -Value $currentDirectory -Type ExpandString -Force

$CurrentUserCurrentHost = ($profile | Select *).CurrentUserCurrentHost
Write-Host "Successfully updated pofile location: "
Write-Host $CurrentUserCurrentHost
Write-Host
Write-Host "Remember to close all of Windows Terminal to initialize changes"
