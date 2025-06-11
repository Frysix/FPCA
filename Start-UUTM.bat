@echo off
REM Description: This script runs the Update-Ui-To-Main PowerShell script with elevated privileges.
REM Usage: Double-click this batch file to execute the PowerShell script.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\DevTools\Update-Ui-To-Main.ps1" -verb runas