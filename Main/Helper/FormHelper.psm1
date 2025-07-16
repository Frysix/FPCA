# Module for handling form-related operations in PowerShell
# Importing necessary assemblies for Windows Forms functionality.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
[System.Windows.Forms.Application]::EnableVisualStyles()

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
        [System.Windows.Forms.IWin32Window]$Owner = $null,
        [Parameter(Mandatory=$false)]
        $Buttons
    )
    if (-not $Buttons) {
        $Buttons = [System.Windows.Forms.MessageBoxButtons]::OK
    } elseif ($Buttons -is [string]) {
        # Convert string to MessageBoxButtons enum if a string is provided
        $Buttons = [System.Windows.Forms.MessageBoxButtons]::Parse([System.Windows.Forms.MessageBoxButtons], $Buttons)
    }
    # Check for the presence of the an Owner window for the message box.
    if ($Owner -ne $null) {
        # If an owner is provided, show the message box with the owner window.
        # This ensures the message box is modal to the owner window.
        $Owner.TopMost = $true
        $Owner.Activate()
        $Owner.Focus()
        [System.Windows.Forms.MessageBox]::Show($Owner, $Message, $Title, $Buttons, [System.Windows.Forms.MessageBoxIcon]::Parse([System.Windows.Forms.MessageBoxIcon], $Icon))
    } else {
        # fallback to old behavior if no owner is provided
        $TopFormTemp = New-Object System.Windows.Forms.Form
        $TopFormTemp.TopMost = $true
        $TopFormTemp.StartPosition = 'CenterScreen'
        $TopFormTemp.Size = '0,0'
        $TopFormTemp.Show()
        $TopFormTemp.Hide()
        [System.Windows.Forms.MessageBox]::Show($TopFormTemp, $Message, $Title, $Buttons, [System.Windows.Forms.MessageBoxIcon]::Parse([System.Windows.Forms.MessageBoxIcon], $Icon))
        $TopFormTemp.Close()
        $TopFormTemp.Dispose()
    }
}


# Function to initialize the configuration UI panel.
# This function generates UI elements for the configuration window.
function Initialize-ConfigUiPanel {
    Param(
        [Parameter(Mandatory=$true)]
        [hashtable]$UiHash,
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.Panel]$MainPanel
    )
    Try {
        # This function generates UI elements for the configuration window.
        # It creates labels, progress bars, and other controls based on the provided UiHash.
        $Global:UiHash.GENERATE_CONFIGUI_ELEMENTS = $false
        # If the UI elements need to be generated, clear the main task panel and regenerate the UI.
        $MainPanel.Controls.Clear()
        # Call the UI script to generate the OS configuration window with the current UiHash.
        . "$($UiHash['PSScriptroot'])\Scripts\UI-Scripts\Gen\Gen-OSConfigWindow-Ui.ps1" -UiHash $UiHash

        foreach ($task in $UiHash.ActiveTasks.Keys) {
            $MainPanel.Controls.Add($UiHash.TaskControls[$task].TaskNameLabel)
            $MainPanel.Controls.Add($UiHash.TaskControls[$task].ProgressBar)
            $MainPanel.Controls.Add($UiHash.TaskControls[$task].StatusLabel)
        }
        # Refresh the main task panel to ensure all controls are displayed correctly.
        $MainPanel.Refresh()
        $UiHash.TaskPanelInitialized = $true
    } Catch {
        $UiHash.TaskPanelInitialized = $false
    }
}