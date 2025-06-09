REM Description: This script sets up the environment for the project and starts the main application.
REM Usage: Double-click this batch file to start the application.
@echo off
setlocal enabledelayedexpansion

REM Check if the script is running with administrative privileges
REM If not, create a file to indicate the user is not an admin
powershell -NoProfile -Executionpolicy Bypass -Command "function Get-AdminStatus {if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {return $false} else {return $true}}; if (-not (Get-AdminStatus)) {$null | out-file -filepath """%~dp0\UserNotAdmin.txt""" -encoding ascii}"
if exist "%~dp0\UserNotAdmin.txt" (goto NotAdmin) else (goto IsAdmin)

REM User is not administrator relaunch script as administrator
:NotAdmin
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UserNotAdmin.txt""") {remove-item -path """%~dp0\UserNotAdmin.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -Command "start-process -WindowStyle Hidden -filepath """%~dp0\Start.bat""" -verb runas"
Exit

REM User is administrator, proceed with the application launch
REM Launches PowerShell script to check for updates and start the application
:IsAdmin
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\Start-Check.ps1"

REM Check if the file FirstLaunch.txt exists
if exist "%~dp0\FirstLaunch.txt" (goto FirstLaunch) else (NormalLaunch)

REM If the file exists, it is the first launch of the application
REM Delete the FirstLaunch.txt file and launch the application with the correct argument
:FirstLaunch
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\FirstLaunch.txt""") {remove-item -path """%~dp0\FirstLaunch.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Main.ps1" -ArgumentList "FirstLaunch"
Exit

REM Normal launch of the application
REM If the file does not exist, it is a normal launch
:NormalLaunch
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Main.ps1" -ArgumentList "NormalLaunch"
Exit