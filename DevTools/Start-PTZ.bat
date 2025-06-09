@echo off
REM Description: This script runs the Package-To-Zip PowerShell script with elevated privileges.
REM Usage: Double-click this batch file to execute the PowerShell script.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0\Package-To-Zip.ps1" -verb runas