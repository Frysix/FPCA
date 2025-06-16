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

# This function creates new buttons dynamically and adds them to a specified element in a Windows Form.

function Invoke-CreateNewButton {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ButtonText,
        [Parameter(Mandatory=$false)]
        $Location,
        [Parameter(Mandatory=$false)]
        [int]$Width = 100,
        [Parameter(Mandatory=$false)]
        [int]$Height = 30
    )
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $ButtonText
    $button.Width = $Width
    $button.Height = $Height
    $button.Parent = $ParentControl
    return $button
}

# This function creates a new label dynamically and adds it to a specified element in a Windows Form.
function Invoke-CreateNewLabel {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LabelText,
        [Parameter(Mandatory=$false)]
        $Location,
        [Parameter(Mandatory=$false)]
        [int]$Width = 100,
        [Parameter(Mandatory=$false)]
        [int]$Height = 30
    )
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $LabelText
    $label.Width = $Width
    $label.Height = $Height
    return $label
}

# This function creates a new progress bar dynamically and adds it to a specified element in a Windows Form.
function Invoke-CreateNewProgressBar {
    param(
        [Parameter(Mandatory=$false)]
        $Location,
        [Parameter(Mandatory=$false)]
        [int]$Width = 200,
        [Parameter(Mandatory=$false)]
        [int]$Height = 20
    )
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Width = $Width
    $progressBar.Height = $Height
    return $progressBar
}

# This function removes a specified control from its parent in a Windows Form.
function Invoke-RemoveControl {
    param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.Control]$Control
    )
    if ($Control -and $Control.Parent) {
        $Control.Parent.Controls.Remove($Control)
        $Control.Dispose()
    }
}