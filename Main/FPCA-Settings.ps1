# This script is launched to handle the settings UI for the FPCA application.
# It reads the settings definition, generates the UI in a runspace, and allows users to save their settings.
# Import necessary modules for the script
Import-Module -Name "$PSScriptroot\Helper\ParsingHelper.psm1" -Force

# Define synchronized hashtables for the script
$Global:UiHash = [hashtable]::Synchronized(@{})
# Define default values for the UiHash
$Global:UiHash.PSScriptRoot = $PSScriptroot
$Global:UiHash.SettingsUiLoaded = $false
$Global:UiHash.ClosedFor = $null

# Create a runspace for the Settings UI
$UiRunspace = [runspacefactory]::CreateRunspace()
$UiRunspace.ApartmentState = "STA"
$UiRunspace.ThreadOptions = "ReuseThread"
$UiRunspace.Open()
$UiRunspace.SessionStateProxy.SetVariable('UiHash',$Global:UiHash)
$UiPowershell = [powershell]::Create()
$UiPowershell.Runspace = $UiRunspace
# Set the script block to run in the UI runspace
$Null = $UiPowershell.AddScript({
    # Import necessary assembly for the UI script
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
    [System.Windows.Forms.Application]::EnableVisualStyles()

    # Import the helper modules for the UI script
    Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\FormHelper.psm1" -Force

    # Import the UI script for the settings
    . (Join-Path $Global:UiHash.PSScriptroot '\Scripts\UI-Scripts\Settings-Ui.ps1')

    # Generate the settings UI
    . "$($Global:UiHash['PSScriptroot'])\Scripts\UI-Scripts\Gen\Gen-Settings-Ui.ps1" -UiHash $Global:UiHash

    foreach ($sectionName in $Global:UiHash.SettingsTabPages.Keys) {
        $tabPage = $Global:UiHash.SettingsTabPages[$sectionName]
        $SETTINGS_TABCONTROL.TabPages.Add($tabPage)
    }

    $SAVE_SETTINGS_BUTTON.Add_Click({
        . "$($Global:UiHash['PSScriptroot'])\Scripts\Settings-Scripts\Save-Settings.ps1" -UiHash $Global:UiHash
    })
    $BACK_SETTINGS_BUTTON.Add_Click({
        $SETTINGS_FORM.Close()
    })
    $RESET_SETTINGS_BUTTON.Add_Click({
        # Set the ClosedFor flag to "Reset" when the Reset button is clicked.
        . "$($Global:UiHash['PSScriptroot'])\Scripts\Settings-Scripts\Reset-Settings.ps1" -UiHash $Global:UiHash -ConfirmReset
        . "$($Global:UiHash['PSScriptroot'])\Scripts\Settings-Scripts\Gen\Gen-Settings-Ui.ps1" -UiHash $Global:UiHash
    })

    $SETTINGS_FORM.Add_Load({
        # Set the SettingsUiLoaded flag to true when the form is loaded.
        $Global:UiHash.SettingsUiLoaded = $true
    })

    $SETTINGS_FORM.ShowDialog()

    $Global:UiHash.ClosedByUser = $true

})
# Register the event handler for the UI runspace
$Null = Register-ObjectEvent -InputObject $UiPowershell -EventName InvocationStateChanged -Action {
    $State = $EventArgs.InvocationStateInfo.State
    if ($State -in 'Completed', 'Failed') {
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
    }
}
# Start the UI runspace
$UiHandle = $UiPowershell.BeginInvoke()
# Wait for the UI runspace to complete
While ($UiHash.SettingsUiLoaded -eq $false) {
    Start-Sleep -Milliseconds 100
}


While ($true) {
    Start-Sleep -Milliseconds 500
    if ($Global:UiHash.ClosedByUser) {
        Start-Process -FilePath "$PSScriptroot\Start.bat" -WindowStyle Hidden -WorkingDirectory $PSScriptroot
        Break
    }
}
exit