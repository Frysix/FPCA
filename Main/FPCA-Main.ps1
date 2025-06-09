# This is the main script that displays the main menu and handles the main functionality of the FPCA application.

# Start-Check.ps1 is used to determine if the application is launched for the first time or not, passing the info through these parameters.
Param(
    [Parameter(Mandatory=$true)]
    [string]$LaunchType
)

# Import the required .NET assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Test to see if everything works till now ---- REMOVE THIS WHEN DONE TESTING ----
[System.Windows.Forms.MessageBox]::Show("Welcome to Frysix's Powershell Configurator App (FPCA)!`nThe Launch Type Was: ${LaunchType}", "FPCA - Main Menu", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
Exit