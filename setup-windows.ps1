# TerminalConfiguration - Windows bootstrap wrapper
# Run this from the repo root in PowerShell:
#   .\setup-windows.ps1
# It delegates to WindowsTerminal\setup.ps1

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$target = Join-Path $root "WindowsTerminal\setup.ps1"

if (-not (Test-Path $target)) {
  Write-Error "Could not find $target"
  exit 1
}

& $target
exit $LASTEXITCODE

