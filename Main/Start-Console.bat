@echo off
setlocal enabledelayedexpansion
REM Description: This script sets up the environment for the project and starts the main application in test mode with the console.
REM Usage: Double-click this batch file to start the application.

REM Check if the script is running with administrative privileges
REM If not, create a file to indicate the user is not an admin
powershell -NoProfile -Executionpolicy Bypass -Command "function Get-AdminStatus {if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {return $false} else {return $true}}; if (Get-AdminStatus) {$null | out-file -filepath """%~dp0\UserIsAdmin.txt""" -encoding ascii}"
if exist "%~dp0\UserIsAdmin.txt" (goto IsAdmin) else (goto NotAdmin)

REM User is not administrator relaunch script as administrator
:NotAdmin
powershell -NoProfile -Executionpolicy Bypass -Command "start-process -filepath """%~dp0\Start-Console.bat""" -verb runas"
goto Close

REM User is administrator, proceed with the application launch
REM Start App Check Script to determine launch type and update necessity
:IsAdmin
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UserIsAdmin.txt""") {remove-item -path """%~dp0\UserIsAdmin.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Main.ps1" -LaunchType "test"
goto Close

:Close
Exit