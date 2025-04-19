# If you are using a previous version of this repo, or have manaully changed your registry to point your personal folder path a a new diretory
# and you wish to revert that to the default, you can run this script

# Reset the 'Personal' folder path to the Windows default
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" `
    -Name "Personal" `
    -Value "%USERPROFILE%\Documents"

Write-Host "Restored Personal folder to default (%USERPROFILE%\Documents)."
Write-Host "Please restart Windows Terminal or log out and back in for changes to apply."