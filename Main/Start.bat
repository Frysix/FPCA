REM Description: This script sets up the environment for the project and starts the main application.
REM Usage: Double-click this batch file to start the application.
@echo off
setlocal enabledelayedexpansion

REM Check if the script is running with administrative privileges
REM If not, create a file to indicate the user is not an admin
powershell -NoProfile -Executionpolicy Bypass -Command "function Get-AdminStatus {if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {return $false} else {return $true}}; if (Get-AdminStatus) {$null | out-file -filepath """%~dp0\UserIsAdmin.txt""" -encoding ascii}"
if exist "%~dp0\UserIsAdmin.txt" (goto IsAdmin) else (goto NotAdmin)

REM User is not administrator relaunch script as administrator
:NotAdmin
powershell -NoProfile -Executionpolicy Bypass -Command "start-process -WindowStyle Hidden -filepath """%~dp0\Start.bat""" -verb runas"
goto Close

REM User is administrator, proceed with the application launch
REM Start App Check Script to determine launch type and update necessity
:IsAdmin
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UserIsAdmin.txt""") {remove-item -path """%~dp0\UserIsAdmin.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\Start-Check.ps1"

REM Check if the file FirstLaunch.txt exists after running to determine if this is the first launch of the application
if exist "%~dp0\FirstLaunch.txt" (goto FirstLaunch) else (goto SecondCheck)

REM Check if the file UpdatedLaunch.txt exists to determine if the script was just updated
:SecondCheck
if exist "%~dp0\UpdatedLaunch.txt" (goto UpdatedLaunch) else (goto ThirdCheck)

REM if the file does not exist test if the file UpdateApp.txt exists to determine if the application needs to be updated
:ThirdCheck
if exist "%~dp0\UpdateApp.txt" (goto UpdateApp) else (goto FourthCheck)

REM if the file does not exist test if the file OutdatedLaunch.txt exists to determine if the application is outdated
:FourthCheck
if exist "%~dp0\OutdatedLaunch.txt" (goto UpdateFailedLaunch) else (goto NormalLaunch)

REM If the file UpdateApp.txt exists, it indicates that the application needs to be updated
:UpdateApp
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UpdateApp.txt""") {remove-item -path """%~dp0\UpdateApp.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\Update-Check.ps1"
if exist "%~dp0\UpdaterInstalled.txt" (goto UpdaterInstalled) else (goto UpdateFailedCheck)

REM If the file UpdaterInstalled.txt exists, it indicates that the updater was installed successfully
REM Cleanup the UpdaterInstalled.txt file
:UpdaterInstalled
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UpdaterInstalled.txt""") {remove-item -path """%~dp0\UpdaterInstalled.txt""" -recurse -force}"
goto Close

REM If the file UpdaterInstalled.txt does not exist, it indicates that the updater was not installed successfully
REM Check if the file UpdateFailedLaunch.txt exists to determine if the user wants to launch the application anyway
:UpdateFailedCheck
if exist "%~dp0\UpdateFailedLaunch.txt" (goto UpdateFailedLaunch) else (goto Close)

REM If the file UpdateFailedLaunch.txt exists, it indicates that the update check failed but the user wants to launch the application anyway
:UpdateFailedLaunch
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\OutdatedLaunch.txt""") {remove-item -path """%~dp0\OutdatedLaunch.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UpdateFailedLaunch.txt""") {remove-item -path """%~dp0\UpdateFailedLaunch.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Main.ps1" -LaunchType "OutdatedLaunch"
goto Close

REM If the file UpdatedLaunch.txt exists, it indicates that the script was just updated
:UpdatedLaunch
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\UpdatedLaunch.txt""") {remove-item -path """%~dp0\UpdatedLaunch.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Main.ps1" -LaunchType "UpdatedLaunch"
goto Close

REM If the file firstlaunch exists, it is the first launch of the application
REM Delete the FirstLaunch.txt file and launch the application with the correct argument
:FirstLaunch
powershell -NoProfile -Executionpolicy Bypass -Command "if (test-path -path """%~dp0\FirstLaunch.txt""") {remove-item -path """%~dp0\FirstLaunch.txt""" -recurse -force}"
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Main.ps1" -LaunchType "FirstLaunch"
goto Close

REM Normal launch of the application
REM If the file does not exist, it is a normal launch
:NormalLaunch
powershell -NoProfile -Executionpolicy Bypass -File "%~dp0\FPCA-Main.ps1" -LaunchType "NormalLaunch"
goto Close

:Close
Exit