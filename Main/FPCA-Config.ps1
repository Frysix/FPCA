# Dynamic task launcher with progress tracking in UI
# This script is designed to launch tasks in a PowerShell runspace and update the UI with the progress of each task.
Param(
    [Parameter(Mandatory=$true)]
    [string[]]$SelectedTasks,
    [Parameter(Mandatory=$true)]
    [hashtable]$AppSettings,
    [Parameter(Mandatory=$false)]
    [hashtable]$SelectedTasksSettings,
    [Parameter(Mandatory=$false)]
    [string[]]$LoadedModConfigs
)

# Ensure fallback for error handling
trap {
    Write-Host "Script is exiting unexpectedly. Cleaning up resources..." -ForegroundColor Red
    Stop-AllTaskRunspaces
    if ($UiPowershell) {
        try {
            $UiPowershell.Stop()
            $UiPowershell.Dispose()
        } catch {
            Write-Host "Error disposing UI PowerShell: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    if ($UiRunspace) {
        try {
            $UiRunspace.Close()
            $UiRunspace.Dispose()
        } catch {
            Write-Host "Error disposing UI Runspace: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    break
}

if (-not $SelectedTasks) {
    Write-Host "No tasks selected for execution. Exiting."
    Exit
}

# Import necessary modules for the script
Import-Module -Name "$PSScriptroot\Helper\ParsingHelper.psm1" -Force
Import-Module -Name "$PSScriptroot\Helper\FormHelper.psm1" -Force


# Define function for stopping all task runspaces
function Stop-AllTaskRunspaces {
    Write-Host "Cleaning up task runspaces..."
    
    # Stop and dispose of all PowerShell instances
    foreach ($taskName in $Global:TaskHash.PowerShellInstances.Keys) {
        try {
            $PowerShellInstance = $Global:TaskHash.PowerShellInstances[$taskName]
            if ($PowerShellInstance) {
                Write-Host "Stopping PowerShell instance for task: $taskName"
                $PowerShellInstance.Stop()
                $PowerShellInstance.Dispose()
            }
        } catch {
            Write-Host "Error stopping PowerShell instance for task '$taskName': $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Clear the PowerShell instances hashtable
    $Global:TaskHash.PowerShellInstances.Clear()
    
    # Close and dispose of the runspace pool
    if ($Global:TaskHash.RunspacePool) {
        try {
            Write-Host "Closing runspace pool..."
            $Global:TaskHash.RunspacePool.Close()
            $Global:TaskHash.RunspacePool.Dispose()
            Write-Host "Runspace pool closed successfully."
        } catch {
            Write-Host "Error closing runspace pool: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Clear the communication channel
    if ($Global:TaskHash.CommunicationChannel) {
        $Global:TaskHash.CommunicationChannel.Clear()
    }
}
# Define function for starting task execution
function Start-TaskExecution {

    Write-Host "Starting task execution for selected tasks..."

    # Start the task distribution process
    $Global:TaskHash.RunspacePool = [runspacefactory]::CreateRunspacePool(1, 4)
    $Global:TaskHash.RunspacePool.ApartmentState = "MTA"
    $Global:TaskHash.RunspacePool.Open()
    $Global:TaskHash.PowerShellInstances = @{}
    $Global:TaskHash.CommunicationChannel = [hashtable]::Synchronized(@{})

    foreach ($task in $Global:ConfigUiHash.ActiveTasks.Keys) {
        # Create a new PowerShell instance for each task
        $Global:TaskHash.PowerShellInstances[$task] = [powershell]::Create()
        $Global:TaskHash.PowerShellInstances[$task].RunspacePool = $Global:TaskHash.RunspacePool

        # Define used variable for the script block
        $TaskName = $task
        if ($SelectedTasksSettings -and $SelectedTasksSettings.ContainsKey($task)) {
            if (-not $Global:TaskHash.ContainsKey('TaskSettings')) {
                $Global:TaskHash.TaskSettings = @{}
            }
            $Global:TaskHash.TaskSettings[$task] = $SelectedTasksSettings[$task]
        }
        # Build the script block for the task
        $ScriptBlock = {
            Param(
                [string]$TaskName,
                [hashtable]$TaskHash
            )
            Try {
                # Initialize communication channel for this task
                $TaskHash.CommunicationChannel[$TaskName] = [hashtable]::Synchronized(@{
                    Status = "Initializing"
                    Progress = 0
                    StartTime = Get-Date
                })
                
                Write-Host "Starting task: $TaskName"
                
                # Find the task definition by searching all categories
                $TaskDefinition = $null
                foreach ($category in $TaskHash.TaskDefinitions.Configuration.Keys) {
                    if ($TaskHash.TaskDefinitions.Configuration[$category].ContainsKey($TaskName)) {
                        $TaskDefinition = $TaskHash.TaskDefinitions.Configuration[$category][$TaskName]
                        Write-Host "Found task '$TaskName' in category '$category'"
                        break
                    }
                }
                
                if (-not $TaskDefinition) {
                    throw "Task definition not found for task '$TaskName'"
                }
                
                # Build the script path
                if ($TaskDefinition.ContainsKey('ScriptFolderPath')) {
                    $ScriptFolderPath = $TaskDefinition.ScriptFolderPath
                } else {
                    $ScriptFolderPath = "Scripts\Config-Scripts"
                }
                
                $ScriptFileName = $TaskDefinition.Script
                if (-not $ScriptFileName) {
                    throw "No Script defined for task '$TaskName'"
                }
                
                # Construct full path
                $ScriptPath = Join-Path -Path $TaskHash.PSScriptRoot -ChildPath $ScriptFolderPath
                $ScriptPath = Join-Path -Path $ScriptPath -ChildPath $ScriptFileName
                
                Write-Host "Script path: $ScriptPath"
                
                if (-not (Test-Path -Path $ScriptPath)) {
                    throw "Script file not found: $ScriptPath"
                }
                
                # Execute the script
                if ($ScriptFileName -like "*.ps1") {
                    Write-Host "Executing PowerShell script: $ScriptPath"
                    if ($TaskHash.ContainsKey('TaskSettings') -and $TaskHash.TaskSettings.ContainsKey($TaskName)) {
                        Write-Host "Passing settings to script: $($Settings | Out-String)"
                        . $ScriptPath -Coms $TaskHash.CommunicationChannel[$TaskName] -TaskName $TaskName -ScriptRoot $TaskHash.PSScriptRoot -TaskSettings $TaskHash.TaskSettings[$TaskName]
                    } else {
                        . $ScriptPath -Coms $TaskHash.CommunicationChannel[$TaskName] -TaskName $TaskName -ScriptRoot $TaskHash.PSScriptRoot
                    }
                } elseif ($ScriptFileName -like "*.exe") {
                    Write-Host "Executing executable: $ScriptPath"
                    Start-Process -FilePath $ScriptPath -Wait
                    $TaskHash.CommunicationChannel[$TaskName].Status = "Completed"
                    $TaskHash.CommunicationChannel[$TaskName].Progress = 100
                } elseif ($ScriptFileName -like "*.bat" -or $ScriptFileName -like "*.cmd") {
                    Write-Host "Executing batch file: $ScriptPath"
                    & cmd.exe /c $ScriptPath
                    $TaskHash.CommunicationChannel[$TaskName].Status = "Completed"
                    $TaskHash.CommunicationChannel[$TaskName].Progress = 100
                } else {
                    throw "Unsupported script type: $ScriptFileName"
                }
                
                Write-Host "Task '$TaskName' completed successfully"
                
            } Catch {
                # Handle any errors that occur during task execution
                Write-Host "Error executing task '$TaskName': $($_.Exception.Message)" -ForegroundColor Red
                Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Red
                
                $TaskHash.CommunicationChannel[$TaskName].Status = "Failed"
                $TaskHash.CommunicationChannel[$TaskName].Progress = 0
                $TaskHash.CommunicationChannel[$TaskName].ErrorMessage = $_.Exception.Message
                $TaskHash.CommunicationChannel[$TaskName].EndTime = Get-Date
            }
        }
        # Add the script block to the PowerShell instance
        $Global:TaskHash.PowerShellInstances[$task].AddScript($ScriptBlock)
        # Add the parameters to the script block
        $Global:TaskHash.PowerShellInstances[$task].AddParameter('TaskName', $TaskName)
        $Global:TaskHash.PowerShellInstances[$task].AddParameter('TaskHash', $Global:TaskHash)
        # Start the task in a new runspace
        $Global:TaskHash.PowerShellInstances[$task].BeginInvoke()
        Write-Host "Task '$TaskName' started in a new runspace."
    }
}

# Run the Install-Caffeine script and check if caffeine needs to be started
if (Test-Path -Path "$PSScriptroot\Scripts\Install-Scripts\Install-Caffeine.ps1") {
    . "$PSScriptroot\Scripts\Install-Scripts\Install-Caffeine.ps1" -AppSettings $AppSettings -ScriptRoot $PSScriptroot
}


# Define synchronized hashtables for the script
$Global:ConfigUiHash = [hashtable]::Synchronized(@{})
$Global:TaskHash = [hashtable]::Synchronized(@{})

# Initialize ExitData with default values to prevent null array errors
$ExitData = @{
    Status = "Unknown"
}
# Initialize hashtables
$Global:ConfigUiHash.PSScriptRoot = $PSScriptroot
$Global:TaskHash.PSScriptRoot = $PSScriptroot
$Global:ConfigUiHash.CaffeineWasStarted = $CaffeineWasStarted
$Global:ConfigUiHash.TaskFormLoaded = $false
$Global:ConfigUiHash.AlwaysKeepOnTop = $AppSettings.AlwaysKeepOnTop
$Global:TaskHash.ExitType = "Default"
$Global:TaskHash.TaskListener = $true
$Global:ConfigUiHash.ActiveTasks = @{}
$Global:ConfigUiHash.StartTime = $null
$ConfigUiHash.TaskPanelInitialized = $false
$Global:ConfigUiHash.ClosedByUser = $false
$Global:ConfigUiHash.ClosedByError = $false
$Global:ConfigUiHash.TaskPanelInitialized = $false
$Global:TaskHash.CompletedTasks = [hashtable]::Synchronized(@{})

$Global:TaskHash.TaskDefinitions = Convert-JsonToHashtable -FilePath "$($Global:ConfigUiHash.PSScriptRoot)\Assets\refs\DefaultConfigDefinition.json"

Write-Host "Loaded task definitions from DefaultConfigDefinition.json"

if (-not $LoadedModConfigs -eq $null) {
    # Load task definitions from the provided configuration files
    foreach ($config in $LoadedModConfigs) {
        # Load additional configurations if provided
        $configPath = Join-Path $Global:ConfigUiHash.PSScriptRoot "Mods\Configs\$config.json"
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
                        if ($TaskDefinitions -and $TaskDefinitions.ContainsKey('Information')) {
                            $Global:TaskHash.TaskDefinitions.Configuration[$category][$task].ScriptFolderPath = $TaskDefinitions.Information.ScriptFolderPath
                        }
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
            $Global:ConfigUiHash.ActiveTasks[$task] = @{
                Name = $task
                Category = $category
                Status = "Pending"
                Progress = 0
                StartTime = Get-Date
                TaskDefinition = $Global:TaskHash.TaskDefinitions.Configuration[$category][$task]
            }
            Write-Host "Task '$task' found in category '$category' and selected for execution."
            Break
        } else {
            Write-Host "Task '$task' not found in category '$category'."
        }    
    }
}

Write-Host "Active tasks transferred to ConfigUiHash for UI processing."

# Create a runspace for the Progression UI
$UiRunspace = [runspacefactory]::CreateRunspace()
$UiRunspace.ApartmentState = "STA"
$UiRunspace.ThreadOptions = "ReuseThread"
$UiRunspace.Open()
$UiRunspace.SessionStateProxy.SetVariable('ConfigUiHash',$Global:ConfigUiHash)
$UiPowershell = [powershell]::Create()
$UiPowershell.Runspace = $UiRunspace
# Set the script block to run in the UI runspace
$Null = $UiPowershell.AddScript({
    # Import necessary assembly for the UI script
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
    [System.Windows.Forms.Application]::EnableVisualStyles()

    # Import the helper modules for the UI script
    Import-Module -Name "$($Global:ConfigUiHash['PSScriptroot'])\Helper\FormHelper.psm1" -Force
    Import-Module -Name "$($Global:ConfigUiHash['PSScriptroot'])\Helper\ParsingHelper.psm1" -Force

    # Import the UI script for the configuration
    . (Join-Path $Global:ConfigUiHash.PSScriptroot '\Scripts\UI-Scripts\Config-Ui.ps1')

    # Define function to initialize the configuration UI panel
    function Initialize-ConfigUiPanel {
        Param (
            [Parameter(Mandatory=$true)]
            [hashtable]$ConfigUiHash,
            [Parameter(Mandatory=$true)]
            [System.Windows.Forms.Panel]$MainPanel
        )
        # Generate the configuration window UI elements
        . "$($Global:ConfigUiHash.PSScriptRoot)\Scripts\Ui-Scripts\Gen\Gen-ConfigurationWindow-Ui.ps1" -UiHash $Global:ConfigUiHash -Generate
        $Global:ConfigUiHash.TaskPanelInitialized = $true
        # Add the generated UI elements to the main panel
        foreach ($task in $Global:ConfigUiHash.TaskControls.Keys) {
            foreach ($element in $Global:ConfigUiHash.TaskControls[$task].Keys) {
                if ($element -eq 'TaskPanel') {
                    $MainPanel.Controls.Add($Global:ConfigUiHash.TaskControls[$task][$element])
                }
            }
        }
    }

    # Define Timers
    $UiTimer = New-Object System.Windows.Forms.Timer
    $UiTimer.Interval = 500 # Set the timer interval to 500 milliseconds (0.5 seconds).
    $UiTimer.Add_Tick({
        if ($MAIN_TASKACTIVECOUNT_LABEL.Text -ne $Global:ConfigUiHash.ActiveTasks.Count.ToString()) {
            # Update the active task count label if it has changed.
            $MAIN_TASKACTIVECOUNT_LABEL.Text = "Tasks Running: $($Global:ConfigUiHash.ActiveTasks.Count.ToString()) / $($Global:ConfigUiHash.TotalTasks)"
        }

    })
    $ElapsedTimer = New-Object System.Windows.Forms.Timer
    $ElapsedTimer.Interval = 1000 # 1 second
    $ElapsedTimer.Add_Tick({
        # Update the elapsed time label every second.
        if ($Global:ConfigUiHash.StartTime) {
            $elapsedTime = (Get-Date) - $Global:ConfigUiHash.StartTime
            $timeString = "{0:D2}:{1:D2}:{2:D2}" -f $elapsedTime.Hours, $elapsedTime.Minutes, $elapsedTime.Seconds
            $MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Text = "Time Elapsed: $timeString"
        }
    })

    # Add Load event handler for the main form.
    $TASK_FORM.add_Load({
        # Set the form's loaded state to true in the global ConfigUiHash.
        $Global:ConfigUiHash.TaskFormLoaded = $true
        if (-not $Global:ConfigUiHash.TaskPanelInitialized) {
            # If the task panel is not initialized, initialize it.
            Initialize-ConfigUiPanel -ConfigUiHash $Global:ConfigUiHash -MainPanel $MAIN_TASK_PANEL
        }
        # Check if caffeine was started and update the label accordingly.
        if ($Global:ConfigUiHash.CaffeineWasStarted) {
            $MAIN_CAFFEINE_STATUS_LABEL.Text = "Caffeine: On"
            $MAIN_CAFFEINE_STATUS_LABEL.ForeColor = [System.Drawing.Color]::Green
        } else {
            $MAIN_CAFFEINE_STATUS_LABEL.Text = "Caffeine: Off"
            $MAIN_CAFFEINE_STATUS_LABEL.ForeColor = [System.Drawing.Color]::Red
        }
        # Set the AlwaysOnTop property based on the configuration setting.
        if ($Global:ConfigUiHash.AlwaysKeepOnTop -eq "true") {
            $TASK_FORM.TopMost = $true
        } else {
            $TASK_FORM.TopMost = $false
        }
        # Start the timer to trigger the Tick event every second.
        $UiTimer.Start()
        $ElapsedTimer.Start()
    })
    $Global:ConfigUiHash.UiTimer = $UiTimer
    $Global:ConfigUiHash.ElapsedTimer = $ElapsedTimer

    # Assign the TaskForm to the global ConfigUiHash variable for later access.
    $Global:ConfigUiHash.TaskForm = $TASK_FORM
    # Initialize the main task panel and other UI elements before loading the form.
    Initialize-ConfigUiPanel -ConfigUiHash $Global:ConfigUiHash -MainPanel $MAIN_TASK_PANEL

    $MAIN_TOTALPROGRESS_PROGRESSBAR.Value = 0
    $MAIN_TOTALPROGRESS_PROGRESSBAR.Minimum = 0
    $MAIN_TOTALPROGRESS_PROGRESSBAR.Maximum = $ConfigUiHash.ActiveTasks.Count
    $MAIN_TASKACTIVECOUNT_LABEL.Text = "Tasks Running: $($Global:ConfigUiHash.ActiveTasks.Count.ToString()) / $($Global:ConfigUiHash.TotalTasks)"
    $Global:ConfigUiHash.MAIN_TASKACTIVECOUNT_LABEL = $MAIN_TASKACTIVECOUNT_LABEL
    $Global:ConfigUiHash.MAIN_TOTALPROGRESS_PROGRESSBAR = $MAIN_TOTALPROGRESS_PROGRESSBAR
    if (Test-Path -Path "$($Global:ConfigUiHash.PSScriptroot)\Assets\img\icons\FPCA_Icon.ico") {
        $TASK_FORM.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($Global:ConfigUiHash.PSScriptroot)\Assets\img\icons\FPCA_Icon.ico")
    }

    # Show the task form dialog.
    $TASK_FORM.ShowDialog()

    $Global:ConfigUiHash.ClosedByUser = $true
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
While ($Global:ConfigUiHash.TaskFormLoaded -eq $false) {
    if ($MainFormLoadLoopCounter -gt 500) {
        # If the main form is not loaded after 500 iterations, display an error message and exit.
        Write-Host "Task form failed to load after 500 attempts. This may be due to UI thread conflicts when running with WindowStyle Hidden." -ForegroundColor Red
        Show-TopMostMessageBox -Message "The Task form failed to load after multiple attempts. Please check the application logs for more details." -Title "Error" -Icon "Error"
        $Global:TaskHash.TaskListener = $false
        # Set error exit data
        $ExitData = @{
            Status = "Error"
            Message = "UI form failed to load"
        }
        # Clean up the runspace and PowerShell instance to prevent memory leaks.
        try {
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
        } catch {
            Write-Host "Error during UI cleanup: $($_.Exception.Message)" -ForegroundColor Red
        }
        Break
    }
    # Sleep for a short duration to prevent high CPU usage while waiting for the main form to load.
    Start-Sleep -Milliseconds 250
    # Increment the loop counter to track how many times we've checked for the main form load.
    $MainFormLoadLoopCounter++
}

# If the main form is loaded, set the start time for the task execution.
if ($Global:ConfigUiHash.TaskFormLoaded) {
    $Global:ConfigUiHash.StartTime = Get-Date
    $Global:ConfigUiHash.TotalTasks = $Global:ConfigUiHash.ActiveTasks.Count.ToString()
    # Proceed with task execution
    
    # Start the task execution in the runspace pool
    Start-TaskExecution
    Write-Host "Task execution started successfully." -ForegroundColor Green
} else {
    Write-Host "Skipping task execution - UI form failed to load." -ForegroundColor Red
}

# Main loop to monitor task progress and update the UI
While ($Global:TaskHash.TaskListener) {
    Start-Sleep -Milliseconds $AppSettings.ConfigMainLoopRefreshRate
    
    # Debug: Check communication channel
    Write-Host "=== Debug Info ===" -ForegroundColor Yellow
    Write-Host "Active Tasks: $($Global:ConfigUiHash.ActiveTasks.Keys -join ', ')" -ForegroundColor Yellow
    Write-Host "Communication Channel Tasks: $($Global:TaskHash.CommunicationChannel.Keys -join ', ')" -ForegroundColor Yellow

    # Reset install mode count
    $InstallModeCount = 0
    # Check for running tasks and update their status
    foreach ($taskName in $Global:ConfigUiHash.ActiveTasks.Keys) {
        if ($Global:TaskHash.CommunicationChannel.ContainsKey($taskName)) {
            # Create a local copy of the task status to avoid threading issues
            $TaskStatus = $Global:TaskHash.CommunicationChannel[$taskName]
            if ($TaskStatus.ContainsKey("InstallMode") -and $TaskStatus.InstallMode -eq $true) {
                # First update installmode count
                $InstallModeCount++
                # if the task is in install mode, update the UI accordingly
                Write-Host "Install Task '$taskName' - Status: $($TaskStatus.Status), Progress: $($Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value)%" -ForegroundColor Cyan
                if ($TaskStatus.Status -eq "Initializing") {
                    if ($TaskStatus.Progress -gt $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value) {
                        $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = $TaskStatus.Progress
                    }
                    if ($TaskStatus.Comment -ne $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text) {
                        $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Initializing: $($TaskStatus.Comment)"
                        $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Blue
                    }
                } elseif ($TaskStatus.Status -eq "Waiting") {
                    if ($InstallModeCount -lt 2) {
                        $Global:TaskHash.CommunicationChannel[$taskName].Status = "Starting"
                    }
                } elseif ($TaskStatus.Status -eq "Starting") {
                    if ($TaskStatus.Comment -ne $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text) {
                        $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Starting: $($TaskStatus.Comment)"
                        $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Blue
                    }
                } elseif ($TaskStatus.Status -eq "Downloading") {
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Downloading: $($TaskStatus.DownloadProgress)%"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::BlueViolet
                    if ($TaskStatus.DownloadIsZip) {
                        $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = [math]::Round($TaskStatus.DownloadProgress * 0.25)
                    } else {
                        $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = [math]::Round($TaskStatus.DownloadProgress * 0.50)
                    }
                } elseif ($TaskStatus.Status -eq "Extracting") {
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Extracting: $($TaskStatus.ExtractProgress)%"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::BlueViolet
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 25 + [math]::Round($TaskStatus.ExtractProgress * 0.25)
                } elseif ($TaskStatus.Status -eq "Installing") {
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Installing: $($TaskStatus.InstallProgress)%"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::BlueViolet
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 50 + [math]::Round($TaskStatus.InstallProgress * 0.40)
                } elseif ($TaskStatus.Status -eq "Verifying") {
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Verifying: $($TaskStatus.Comment)"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Orange
                } elseif ($TaskStatus.Status -eq "Completed") {
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 100
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Completed: $($TaskStatus.Comment)"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Green
                    $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
                } elseif ($TaskStatus.Status -eq "Failed" -or $TaskStatus.Status -eq "Error") {
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 0
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Failed: $($TaskStatus.ErrorMessage)"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Red
                    $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
                } elseif ($TaskStatus.Status -eq "Warning") {
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 100
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Warning: $($TaskStatus.Comment)"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::OrangeRed
                    $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
                }
            } else {
                # if the task is not in install mode, update the UI accordingly
                Write-Host "Task '$taskName' - Status: $($TaskStatus.Status), Progress: $($TaskStatus.Progress)" -ForegroundColor Cyan
                if ($TaskStatus.Status -eq "Running") {
                    if ($TaskStatus.Progress -gt $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value) {
                        $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = $TaskStatus.Progress
                    }
                    if ($TaskStatus.Comment -ne $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text) {
                        $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "$($TaskStatus.Comment)"
                        $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Blue
                    }
                } elseif ($TaskStatus.Status -eq "Completed") {
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 100
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Completed: $($TaskStatus.Comment)"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Green
                    $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
                } elseif ($TaskStatus.Status -eq "Failed" -or $TaskStatus.Status -eq "Error") {
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 0
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Failed: $($TaskStatus.ErrorMessage)"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Red
                    $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
                } elseif ($TaskStatus.Status -eq "Warning") {
                    $Global:ConfigUiHash.TaskControls[$taskName].ProgressBar.Value = 100
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.Text = "Warning: $($TaskStatus.Comment)"
                    $Global:ConfigUiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::OrangeRed
                    $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
                }
            }
        } else {
            Write-Host "Task '$taskName' not found in communication channel" -ForegroundColor Red
        }
    }

    foreach ($taskName in $Global:TaskHash.CompletedTasks.Keys) {
        if ($Global:ConfigUiHash.ActiveTasks.ContainsKey($taskName)) {
            $Global:ConfigUiHash.ActiveTasks.Remove($taskName)
        }
    }
    # Update the total progress bar
    if ($Global:ConfigUiHash.MAIN_TOTALPROGRESS_PROGRESSBAR.Value -ne $Global:TaskHash.CompletedTasks.Count) {
        $Global:ConfigUiHash.MAIN_TOTALPROGRESS_PROGRESSBAR.Value = $Global:TaskHash.CompletedTasks.Count
        Write-Host "Updated total progress bar to $($Global:ConfigUiHash.MAIN_TOTALPROGRESS_PROGRESSBAR.Value) out of $($Global:ConfigUiHash.ActiveTasks.Count)"
    }
    
    if ($Global:ConfigUiHash.ClosedByUser) {
        Write-Host "UI has been closed by user. Stopping task listener."
        # Kill caffeine if it was started by the script
        if ($Global:ConfigUiHash.CaffeineWasStarted) {
            try {
                ."$PSScriptRoot\Assets\Apps\Caffeine\caffeine64.exe" -appexit
                Write-Host "Caffeine stopped successfully." -ForegroundColor Green
            } catch {
                Write-Host "Failed to stop Caffeine: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        # Clean up task runspaces
        Stop-AllTaskRunspaces
        # Clean up the UI runspace
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
        $Global:TaskHash.TaskListener = $false
        $ExitData = @{
            Status = "Cancelled"
        }
        Break
    } elseif ($Global:ConfigUiHash.ClosedByError) {
        Write-Host "UI has encountered an error. Stopping task listener."
        # Kill caffeine if it was started by the script
        if ($Global:ConfigUiHash.CaffeineWasStarted) {
            try {
                ."$PSScriptRoot\Assets\Apps\Caffeine\caffeine64.exe" -appexit
                Write-Host "Caffeine stopped successfully." -ForegroundColor Green
            } catch {
                Write-Host "Failed to stop Caffeine: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        # Clean up task runspaces
        Stop-AllTaskRunspaces
        # Clean up the UI runspace
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
        $Global:TaskHash.TaskListener = $false
        $ExitData = @{
            Status = "Error"
        }
        Break
    } elseif ($Global:ConfigUiHash.ActiveTasks.Count -le 0) {
        Write-Host "All tasks have been completed. Stopping task listener."
        # Clean up task runspaces
        Stop-AllTaskRunspaces
        $Global:ConfigUiHash.UiTimer.Stop()
        $Global:ConfigUiHash.ElapsedTimer.Stop()
        $Global:ConfigUiHash.MAIN_TASKACTIVECOUNT_LABEL.Text = "Tasks Running: 0 / $($Global:ConfigUiHash.TotalTasks)"
        $Global:TaskHash.ExitMessages = @()
        # Verify for end of Configuration scripts
        foreach ($taskName in $Global:TaskHash.CompletedTasks.Keys) {
            $TaskStatus = $Global:TaskHash.CompletedTasks[$taskName]
            if ($TaskStatus.Status -eq "Failed") {
                Show-TopMostMessageBox -Message "Task '$taskName' failed with error: $($TaskStatus.ErrorMessage)" -Title "Error" -Icon "Error"
            } else {
                Write-Host "Task '$taskName' completed successfully."
            }
            if ($TaskStatus.ContainsKey('CustomExit')) {
                $Global:TaskHash.ExitType = $TaskStatus.CustomExit.Type
                $Global:TaskHash.ExitMessages += $TaskStatus.CustomExit.Message
                Write-Host "Custom exit type detected: $($Global:TaskHash.ExitType)"
            } else {
                Write-Host "No custom exit type defined for task '$taskName'. Using default exit type."
            }
            if ($TaskStatus.ContainsKey('RemindDefault') -and $TaskStatus.RemindDefault -eq $true -and $Global:TaskHash.TaskDefinitions.Configuration.Install.ContainsKey($taskName)) {
                if ($null -eq $ToRemindDefault) {
                    $ToRemindDefault = @()
                }
                $ToRemindDefault += $Global:TaskHash.TaskDefinitions.Configuration.Install[$taskName].DisplayName
            }
        }
        if ($ToRemindDefault) {
            $remindList = $ToRemindDefault -join ", "
            Show-TopMostMessageBox -Message "The Configuration has ended. Please set the following apps as default: $remindList" -Title "FPCA - Configuration" -Icon "Information"
            Start-Process "ms-settings:defaultapps"
        } else {
            Show-TopMostMessageBox -Message "The Configuration has ended." -Title "FPCA - Configuration" -Icon "Information"
        }
        # Kill caffeine if it was started by the script
        if ($Global:ConfigUiHash.CaffeineWasStarted) {
            try {
                ."$PSScriptRoot\Assets\Apps\Caffeine\caffeine64.exe" -appexit
                Write-Host "Caffeine stopped successfully." -ForegroundColor Green
            } catch {
                Write-Host "Failed to stop Caffeine: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        $ExitData = @{
            Status = "Success"
        }
        if ($Global:TaskHash.ContainsKey('ExitType')) {
            $ExitData.Type = $Global:TaskHash.ExitType
        }
        if ($Global:TaskHash.ContainsKey('ExitMessages')) {
            $ExitData.Messages = $Global:TaskHash.ExitMessages
        }
        $Global:ConfigUiHash.TaskForm.Close()
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
        $Global:TaskHash.TaskListener = $false
        Break
    }
}

Return $ExitData