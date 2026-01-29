REM Simple batch file to start the Updater script, it ensures that the script is run with administrative privileges first.
@echo off
setlocal enabledelayedexpansion
pushd "%~dp0"

REM Check if the script is running with administrative privileges
REM If not, create a file to indicate the user is not an admin
powershell -NoProfile -Executionpolicy Bypass -Command "function Get-AdminStatus {if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {return $false} else {return $true}}; if (Get-AdminStatus) {$null | out-file -filepath """%~dp0\UserIsAdmin.txt""" -encoding ascii}"
if exist "%~dp0\UserIsAdmin.txt" (goto IsAdmin) else (goto NotAdmin)

REM User is not administrator relaunch script as administrator
:NotAdmin
powershell -NoProfile -Executionpolicy Bypass -Command "start-process -WindowStyle Hidden -filepath """%~dp0\Start-Updater.bat""" -verb runas"
goto Close

REM User is administrator, proceed with the application launch
REM Start App Check Script to determine launch type and update necessity
:IsAdmin
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UserIsAdmin.txt""") {remove-item -path """%~dp0\UserIsAdmin.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Updater.ps1"
goto Close

REM If the script reaches here, it means the Updater-Check script has completed
:Close
popd
Exit