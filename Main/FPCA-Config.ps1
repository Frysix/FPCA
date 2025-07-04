# This is the dynamic modular configuration script for the FPCA application.
# It sets up the configuration for the application based on the provided parameters and environment.
Param(
    [Parameter(Mandatory=$true)]
    [string]$TaskInfo      # expecting JSON string
)

# Import necessary modules for the script
Import-Module -Name "$PSScriptroot\Helper\ParsingHelper.psm1" -Force
Import-Module -Name "$PSScriptroot\Helper\FormHelper.psm1" -Force

pause

# Deserialize JSON string to hashtable
$TaskInfoObj = $TaskInfo | ConvertFrom-Json
$TaskInfo = ConvertTo-Hashtable $TaskInfoObj

pause

# Define synchronized hashtables for the script
$Global:UiHash = [hashtable]::Synchronized(@{})
$Global:TaskHash = [hashtable]::Synchronized(@{})
# Define default values for the UiHash
$Global:UiHash.PSScriptRoot = $PSScriptroot
$Global:UiHash.TaskFormLoaded = $false
$Global:TaskHash.TaskListener = $false

# Create a runspace for the Progression UI
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

    # Import the UI script for the configuration
    . (Join-Path $Global:UiHash.PSScriptroot '\UI-Scripts\Config-Ui.ps1')


    # Create a timer to handle periodic updates or checks in the UI.
    $Timer = New-Object System.Windows.Forms.Timer
    $Timer.Interval = 1000 
    $Timer.Add_Tick({

    })
    # Start the timer to trigger the Tick event every second.
    $Timer.Start()

    # Add Load event handler for the main form.
    $TASK_FORM.add_Load({
        # Set the TaskFormLoaded flag to true when the form is loaded.
        $Global:UiHash.TaskFormLoaded = $true
    })

    # Assign the TaskForm to the global UiHash variable for later access.
    $Global:UiHash.TaskForm = $TASK_FORM
    # Show the task form dialog.
    $TASK_FORM.ShowDialog()

    $Global:TaskHash.TaskListener = $false
})
# Register an event handler for the InvocationStateChanged event.
# This event is triggered when the state of the PowerShell invocation changes and automatically handles the closing of the runspace when the Runspace has finished.
$Null = Register-ObjectEvent -InputObject $UiPowershell -EventName InvocationStateChanged -Action {
    $State = $EventArgs.InvocationStateInfo.State
    if ($State -in 'Completed', 'Failed') {
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
    }
}

# Begin invoking the PowerShell instance to run the UI script.
# This starts the execution of the UI script in the runspace.
$UiHandle = $UiPowershell.BeginInvoke()


# Wait Handle for UI to display
$MainFormLoadLoopCounter = 0
$Global:TaskHash.TaskListener = $true
While ($Global:UiHash.TaskFormLoaded -eq $false) {
    if ($MainFormLoadLoopCounter -gt 500) {
        # If the main form is not loaded after 500 iterations, display an error message and exit.
        Show-TopMostMessageBox -Message "The Task form failed to load after multiple attempts. Please check the application logs for more details." -Title "Error" -Icon "Error"
        $Global:TaskHash.TaskListener = $false
        # Clean up the runspace and PowerShell instance to prevent memory leaks.
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
        Break
    }
    # Sleep for a short duration to prevent high CPU usage while waiting for the main form to load.
    Start-Sleep -Milliseconds 250
    # Increment the loop counter to track how many times we've checked for the main form load.
    $MainFormLoadLoopCounter++
}

# Start the task listener loop to handle task distribution and UI refreshing.
While ($Global:TaskHash.TaskListener) {
    Start-Sleep -Milliseconds 250
}