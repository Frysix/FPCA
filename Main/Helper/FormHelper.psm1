# Module for handling form-related operations in PowerShell
# Importing necessary assemblies for Windows Forms functionality.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore

# This module provides functions to create and manage forms, including showing message boxes.
function Show-TopMostMessageBox {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Information', 'Warning', 'Error', 'Question')][string]$Icon = 'Information',
        [Parameter(Mandatory=$false)]
        [System.Windows.Forms.IWin32Window]$Owner = $null
    )
    # Check for the presence of the an Owner window for the message box.
    if ($Owner -ne $null) {
        # If an owner is provided, show the message box with the owner window.
        # This ensures the message box is modal to the owner window.
        $Owner.TopMost = $true
        $Owner.Activate()
        $Owner.Focus()
        [System.Windows.Forms.MessageBox]::Show($Owner, $Message, $Title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Parse([System.Windows.Forms.MessageBoxIcon], $Icon))
    } else {
        # fallback to old behavior if no owner is provided
        $TopFormTemp = New-Object System.Windows.Forms.Form
        $TopFormTemp.TopMost = $true
        $TopFormTemp.StartPosition = 'CenterScreen'
        $TopFormTemp.Size = '0,0'
        $TopFormTemp.Show()
        $TopFormTemp.Hide()
        [System.Windows.Forms.MessageBox]::Show($TopFormTemp, $Message, $Title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Parse([System.Windows.Forms.MessageBoxIcon], $Icon))
        $TopFormTemp.Close()
        $TopFormTemp.Dispose()
    }
}