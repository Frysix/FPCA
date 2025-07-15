# Dynamic task launcher with progress tracking in UI
# This script is designed to launch tasks in a PowerShell runspace and update the UI with the progress of each task.
Param(
    [Parameter(Mandatory=$true)]
    [string[]]$SelectedTasks,
    [Parameter(Mandatory=$false)]
    [string[]]$LoadedModConfigs
)

if (-not $SelectedTasks) {
    Write-Host "No tasks selected for execution. Exiting."
    Exit
}

# Import necessary modules for the script
Import-Module -Name "$PSScriptroot\Helper\ParsingHelper.psm1" -Force
Import-Module -Name "$PSScriptroot\Helper\FormHelper.psm1" -Force

# Define synchronized hashtables for the script
$Global:UiHash = [hashtable]::Synchronized(@{})
$Global:TaskHash = [hashtable]::Synchronized(@{})
# Initialize hashtables
$Global:UiHash.PSScriptRoot = $PSScriptroot
$Global:UiHash.TaskFormLoaded = $false
$Global:TaskHash.TaskListener = $true
$Global:UiHash.ActiveTasks = @{}
$Global:TaskHash.CompletedTasks = [hashtable]::Synchronized(@{})

$Global:TaskHash.TaskDefinitions = Convert-JsonToHashtable -FilePath "$($Global:UiHash.PSScriptRoot)\Assets\refs\DefaultConfigDefinition.json"

Write-Host "Loaded task definitions from DefaultConfigDefinition.json"

if (-not $LoadedModConfigs -eq $null) {
    # Load task definitions from the provided configuration files
    foreach ($config in $LoadedModConfigs) {
        # Load additional configurations if provided
        $configPath = Join-Path $Global:UiHash.PSScriptRoot "Mods\Configs\$config.json"
        if (Test-Path -Path $configPath) {
            $TaskDefinitions = Convert-JsonToHashtable -FilePath $configPath
            if ($TaskDefinitions -and $TaskDefinitions.ContainsKey('Configuration')) {
                # Merge the task definitions from the configuration file into the main task definitions
                foreach ($category in $TaskDefinitions.Configuration.Keys) {
                    if (-not $Global:TaskHash.TaskDefinitions.Configuration.ContainsKey($category)) {
                        $Global:TaskHash.TaskDefinitions.Configuration[$category] = @{}
                    }
                    foreach ($task in $TaskDefinitions.Configuration[$category].Keys) {
                        $Global:TaskHash.TaskDefinitions.Configuration[$category][$task] = $TaskDefinitions.Configuration[$category][$task]
                    }
                }
                Write-Host "Merged task definitions from configuration file: $configPath"
            } else {
                Write-Host "No valid task definitions found in configuration file: $configPath - Skipping."
                continue
            }
        } else {
            Write-Host "Configuration file not found: $configPath - Skipping."
            continue
        }
    }
} else {
    Write-Host "No additional configuration files provided. Using default task definitions."
}


# Create a hashtable to store tasks that will actually be run
foreach ($task in $SelectedTasks) {
    foreach ($category in $Global:TaskHash.TaskDefinitions.Configuration.Keys) {
        if ($Global:TaskHash.TaskDefinitions.Configuration[$category].ContainsKey($task)) {
            $Global:UiHash.ActiveTasks[$task] = @{
                Name = $task
                Category = $category
                Status = "Pending"
                Progress = 0
                StartTime = Get-Date
                TaskDefinition = $Global:TaskHash.TaskDefinitions.Configuration[$category][$task]
            }
            Write-Host "Task '$task' found in category '$category' and selected for execution."
        } else {
            Write-Host "Task '$task' not found in category '$category'."
        }    
    }
}

Write-Host "Active tasks transferred to UiHash for UI processing."

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
    . (Join-Path $Global:UiHash.PSScriptroot '\Scripts\UI-Scripts\Config-Ui.ps1')

    # Create a timer to handle periodic updates or checks in the UI.
    $Timer = New-Object System.Windows.Forms.Timer
    $Timer.Interval = 500
    $Timer.Add_Tick({
        if ($Global:UiHash.GENERATE_CONFIGUI_ELEMENTS) {
            $Global:UiHash.GENERATE_CONFIGUI_ELEMENTS = $false
            # If the UI elements need to be generated, clear the main task panel and regenerate the UI.
            $MAIN_TASK_PANEL.Controls.Clear()
            # Call the UI script to generate the OS configuration window with the current UiHash.
            . "$($Global:UiHash['PSScriptroot'])\Scripts\UI-Scripts\Gen\Gen-OSConfigWindow-Ui.ps1" -UiHash $UiHash

            foreach ($task in $UiHash.ActiveTasks.Keys) {
                $MAIN_TASK_PANEL.Controls.Add($Global:UiHash.TaskControls[$task].TaskNameLabel)
                $MAIN_TASK_PANEL.Controls.Add($Global:UiHash.TaskControls[$task].ProgressBar)
                $MAIN_TASK_PANEL.Controls.Add($Global:UiHash.TaskControls[$task].StatusLabel)
            }
            # Refresh the main task panel to ensure all controls are displayed correctly.
            $MAIN_TASK_PANEL.Refresh()
            $MAIN_TOTALPROGRESS_PROGRESSBAR.Value = 0
            $MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Text = "0:00"
            $MAIN_TASKACTIVECOUNT_LABEL.Text = $UiHash.ActiveTasks.Count.ToString()
        }
    })

    # Add Load event handler for the main form.
    $TASK_FORM.add_Load({
        # Set the form's loaded state to true in the global UiHash.
        $Global:UiHash.TaskFormLoaded = $true
        $Global:UiHash.GENERATE_CONFIGUI_ELEMENTS = $true
        # Refresh the main task panel to ensure all controls are displayed correctly.
        $MAIN_TASK_PANEL.Refresh()
        # Start the timer to trigger the Tick event every second.
        $Timer.Start()
    })

    # Assign the TaskForm to the global UiHash variable for later access.
    $Global:UiHash.TaskForm = $TASK_FORM

    # Show the task form dialog.
    $TASK_FORM.ShowDialog()

    $Global:UiHash.ClosedByUser = $true
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
    Start-Sleep -Milliseconds 500
    if ($Global:UiHash.ClosedByUser) {
        # If the UI has been closed by the user, stop the task listener.
        $Global:TaskHash.TaskListener = $false
        Write-Host "UI has been closed by user. Stopping task listener."
        Break
    } elseif ($Global:UiHash.ClosedByError) {
        # If there was an error in the UI, stop the task listener.
        $Global:TaskHash.TaskListener = $false
        Write-Host "UI has encountered an error. Stopping task listener."
        Break
    }
    if ($Global:UiHash.TaskControls.Count -eq 0) {
        # If there are no task controls, stop the task listener.
        Write-Host "No task controls found."

    }

}
Exit