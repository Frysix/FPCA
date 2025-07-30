# FPCA main updater script
# This script is responsible for updating the FPCA application.

# Define variables
$Global:UiHash = [hashtable]::Synchronized(@{})
$Global:UiHash.PSScriptRoot = $PSScriptRoot


# Create runspace for the updater's UI
$UiRunspace = [runspacefactory]::CreateRunspace()
$UiRunspace.ApartmentState = "STA"
$UiRunspace.ThreadOptions = "ReuseThread"
$UiRunspace.Open()
$UiRunspace.SessionStateProxy.SetVariable('UiHash',$Global:UiHash)
$UiPowershell = [powershell]::Create()
$UiPowershell.Runspace = $UiRunspace
# Load the UI Runspace's script
$Null = $UiPowershell.AddScript({
    ### UI SCRIPT ###
    Try {
        # Ensure necessary assemblies are loaded
        Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
        [System.Windows.Forms.Application]::EnableVisualStyles()
        # Launch the updater UI
        . (Join-Path $Global:UiHash.PSScriptRoot 'Updater-Ui.ps1')
        # Assign controls to the UiHash
        $Global:UiHash.UPDATER_MAIN_FORM = $UPDATER_MAIN_FORM
        $Global:UiHash.PROGRESS_NUM_LABEL = $PROGRESS_NUM_LABEL
        $Global:UiHash.MAIN_UPDATE_PROGRESSBAR = $MAIN_UPDATE_PROGRESSBAR
        $Global:UiHash.LIVEINFO_TEXTBOX = $LIVEINFO_TEXTBOX
        $Global:UiHash.UPDATINGTO_NUM_LABEL = $UPDATINGTO_NUM_LABEL
        $Global:UiHash.CURRENTVERSION_NUM_LABEL = $CURRENTVERSION_NUM_LABEL
        $Global:UiHash.LIVESTATUS_TEXT_LABEL = $LIVESTATUS_TEXT
    } Catch {

    }
})

# Register object event to handle the end of the UI script
$Null = Register-ObjectEvent -InputObject $UiPowershell -EventName InvocationStateChanged -Action {
    $State = $EventArgs.InvocationStateInfo.State
    if ($State -in 'Completed', 'Failed') {
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
    }
}

# Start the UI script in the runspace
$UiHandle = $UiPowershell.BeginInvoke()
