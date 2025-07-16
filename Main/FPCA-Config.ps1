# Dynamic task launcher with progress tracking in UI
# This script is designed to launch tasks in a PowerShell runspace and update the UI with the progress of each task.
Param(
    [Parameter(Mandatory=$true)]
    [string[]]$SelectedTasks,
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
    $Global:TaskHash.RunspacePool.Open()
    $Global:TaskHash.PowerShellInstances = @{}
    $Global:TaskHash.CommunicationChannel = [hashtable]::Synchronized(@{})

    foreach ($task in $Global:UiHash.ActiveTasks.Keys) {
        # Create a new PowerShell instance for each task
        $Global:TaskHash.PowerShellInstances[$task] = [powershell]::Create()
        $Global:TaskHash.PowerShellInstances[$task].RunspacePool = $Global:TaskHash.RunspacePool

        # Define used variable for the script block
        $TaskName = $task

        # Build the script block for the task
        # Replace your script block with this corrected version:
        $ScriptBlock = {
            Param(
                [string]$TaskName,
                [hashtable]$TaskHash
            )
            Try {
                # Initialize communication channel for this task
                $TaskHash.CommunicationChannel[$TaskName] = [hashtable]::Synchronized(@{
                    Status = "Running"
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
                
                # Update progress
                $TaskHash.CommunicationChannel[$TaskName].Progress = 10
                $TaskHash.CommunicationChannel[$TaskName].Status = "Executing script..."
                
                # Execute the script
                if ($ScriptFileName -like "*.ps1") {
                    Write-Host "Executing PowerShell script: $ScriptPath"
                    . $ScriptPath -Coms $TaskHash.CommunicationChannel[$TaskName] -TaskName $TaskName
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
        $Global:TaskHash.PowerShellInstances[$task].AddScript($ScriptBlock).Add
        # Add the parameters to the script block
        $Global:TaskHash.PowerShellInstances[$task].AddParameter('TaskName', $TaskName)
        $Global:TaskHash.PowerShellInstances[$task].AddParameter('TaskHash', $Global:TaskHash)
        # Start the task in a new runspace
        $Global:TaskHash.PowerShellInstances[$task].BeginInvoke()
        Write-Host "Task '$TaskName' started in a new runspace."
    }
}

# Define synchronized hashtables for the script
$Global:UiHash = [hashtable]::Synchronized(@{})
$Global:TaskHash = [hashtable]::Synchronized(@{})
# Initialize hashtables
$Global:UiHash.PSScriptRoot = $PSScriptroot
$Global:TaskHash.PSScriptRoot = $PSScriptroot
$Global:UiHash.TaskFormLoaded = $false
$Global:TaskHash.ExitType = "Default"
$Global:TaskHash.TaskListener = $true
$Global:UiHash.ActiveTasks = @{}
$Global:UiHash.StartTime = $null
$Global:UiHash.ClosedByUser = $false
$Global:UiHash.ClosedByError = $false
$Global:UiHash.TaskPanelInitialized = $false
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
    Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\ParsingHelper.psm1" -Force

    # Import the UI script for the configuration
    . (Join-Path $Global:UiHash.PSScriptroot '\Scripts\UI-Scripts\Config-Ui.ps1')

    # Define Timers
    $UiTimer = New-Object System.Windows.Forms.Timer
    $UiTimer.Interval = 500 # Set the timer interval to 500 milliseconds (0.5 seconds).
    $UiTimer.Add_Tick({

    })
    $ElapsedTimer = New-Object System.Windows.Forms.Timer
    $ElapsedTimer.Interval = 1000 # 1 second
    $ElapsedTimer.Add_Tick({
        # Update the elapsed time label every second.
        if ($Global:UiHash.StartTime) {
            $elapsedTime = (Get-Date) - $Global:UiHash.StartTime
            $timeString = "{0:D2}:{1:D2}:{2:D2}" -f $elapsedTime.Hours, $elapsedTime.Minutes, $elapsedTime.Seconds
            $MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Text = $timeString
        }
    })

    # Add Load event handler for the main form.
    $TASK_FORM.add_Load({
        # Set the form's loaded state to true in the global UiHash.
        $Global:UiHash.TaskFormLoaded = $true
        if (-not $Global:UiHash.TaskPanelInitialized) {
            # If the task panel is not initialized, initialize it.
            Initialize-ConfigUiPanel -UiHash $Global:UiHash -MainPanel $MAIN_TASK_PANEL
        }
        # Start the timer to trigger the Tick event every second.
        $UiTimer.Start()
        $ElapsedTimer.Start()
    })

    # Assign the TaskForm to the global UiHash variable for later access.
    $Global:UiHash.TaskForm = $TASK_FORM
    # Initialize the main task panel and other UI elements before loading the form.
    Initialize-ConfigUiPanel -UiHash $Global:UiHash -MainPanel $MAIN
    $MAIN_TOTALPROGRESS_PROGRESSBAR.Value = 0
    $MAIN_TOTALPROGRESS_PROGRESSBAR.Minimum = 0
    $MAIN_TOTALPROGRESS_PROGRESSBAR.Maximum = $UiHash.ActiveTasks.Count
    $MAIN_TASKACTIVECOUNT_LABEL.Text = $UiHash.ActiveTasks.Count.ToString()

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

# If the main form is loaded, set the start time for the task execution.
$Global:UiHash.StartTime = Get-Date
# Proceed with task execution

# Start the task execution in the runspace pool
Start-TaskExecution

# Main loop to monitor task progress and update the UI
While ($Global:TaskHash.TaskListener) {
    Start-Sleep -Milliseconds 500
    
    # Debug: Check communication channel
    Write-Host "=== Debug Info ===" -ForegroundColor Yellow
    Write-Host "Active Tasks: $($Global:UiHash.ActiveTasks.Keys -join ', ')" -ForegroundColor Yellow
    Write-Host "Communication Channel Tasks: $($Global:TaskHash.CommunicationChannel.Keys -join ', ')" -ForegroundColor Yellow
    
    # Check for running tasks and update their status
    foreach ($taskName in $Global:UiHash.ActiveTasks.Keys) {
        if ($Global:TaskHash.CommunicationChannel.ContainsKey($taskName)) {
            $TaskStatus = $Global:TaskHash.CommunicationChannel[$taskName]
            Write-Host "Task '$taskName' - Status: $($TaskStatus.Status), Progress: $($TaskStatus.Progress)" -ForegroundColor Cyan
            if ($TaskStatus.Status -eq "Running") {
                if ($TaskStatus.Progress -gt $Global:UiHash.TaskControls[$taskName].ProgressBar.Value) {
                    $Global:UiHash.TaskControls[$taskName].ProgressBar.Value = $TaskStatus.Progress
                }
                if ($TaskStatus.Comment -ne $Global:UiHash.TaskControls[$taskName].StatusLabel.Text) {
                    $Global:UiHash.TaskControls[$taskName].StatusLabel.Text = "Running: $($TaskStatus.Comment)"
                    $Global:UiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Blue
                }
            } elseif ($TaskStatus.Status -eq "Completed") {
                $Global:UiHash.TaskControls[$taskName].ProgressBar.Value = 100
                $Global:UiHash.TaskControls[$taskName].StatusLabel.Text = "Completed"
                $Global:UiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Green
                $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
            } elseif ($TaskStatus.Status -eq "Failed" -or $TaskStatus.Status -eq "Error") {
                $Global:UiHash.TaskControls[$taskName].ProgressBar.Value = 0
                $Global:UiHash.TaskControls[$taskName].StatusLabel.Text = "Failed: $($TaskStatus.ErrorMessage)"
                $Global:UiHash.TaskControls[$taskName].StatusLabel.ForeColor = [System.Drawing.Color]::Red
                $Global:TaskHash.CompletedTasks[$taskName] = $TaskStatus
                
                # Debug: Show error message
                if ($TaskStatus.ErrorMessage) {
                    Write-Host "Error for task '$taskName': $($TaskStatus.ErrorMessage)" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "Task '$taskName' not found in communication channel" -ForegroundColor Red
        }
    }

    foreach ($taskName in $Global:TaskHash.CompletedTasks.Keys) {
        if ($Global:UiHash.ActiveTasks.ContainsKey($taskName)) {
            $Global:UiHash.ActiveTasks.Remove($taskName)
        }
    }
    
    if ($Global:UiHash.ClosedByUser) {
        Write-Host "UI has been closed by user. Stopping task listener."
        # Clean up task runspaces
        Stop-AllTaskRunspaces
        # Clean up the UI runspace
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
        $Global:TaskHash.TaskListener = $false
        $ExitCode = 1
        Break
    } elseif ($Global:UiHash.ClosedByError) {
        Write-Host "UI has encountered an error. Stopping task listener."
        # Clean up task runspaces
        Stop-AllTaskRunspaces
        # Clean up the UI runspace
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
        $Global:TaskHash.TaskListener = $false
        $ExitCode = 2
        Break
    } elseif ($Global:UiHash.ActiveTasks.Count -le 0) {
        Write-Host "All tasks have been completed. Stopping task listener."
        # Clean up task runspaces
        Stop-AllTaskRunspaces
        # Verify for end of Configuration scripts
        foreach ($taskName in $Global:TaskHash.CompletedTasks.Keys) {
            $TaskStatus = $Global:TaskHash.CompletedTasks[$taskName]
            if ($TaskStatus.Status -eq "Failed") {
                Show-TopMostMessageBox -Message "Task '$taskName' failed with error: $($TaskStatus.ErrorMessage)" -Title "Error" -Icon "Error"
            } else {
                Write-Host "Task '$taskName' completed successfully."
            }
            if ($TaskStatus.ContainsKey('FinalScript')) {
                $FinalScriptBlock = $TaskStatus.FinalScript
                if ($FinalScriptBlock -and $FinalScriptBlock -is [scriptblock]) {
                    # Run the final script block
                    Write-Host "Running final script block for task '$taskName'."
                    $FinalScriptBlock.Invoke($Global:TaskHash)
                }
            }
        }
        # Add some time for user to see the results
        Start-Sleep -Seconds 3
        if ($Global:TaskHash.ExitType -eq "Default") {
            # Clean up the UI runspace
            $Global:UiHash.TaskForm.Close()
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            $Global:TaskHash.TaskListener = $false
            $ExitCode = 0
            Write-Host "All tasks completed successfully. Exiting with code $ExitCode - Default Exit."
            Break
        } elseif ($Global:TaskHash.ExitType -eq "BIOS") {
            Write-Host "All tasks completed successfully. Exiting with code $ExitCode - BIOS Exit."
            # Clean up the UI runspace
            $Global:UiHash.TaskForm.Close()
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            $Global:TaskHash.TaskListener = $false
            $ExitCode = 3
            Break
        } elseif ($Global:TaskHash.ExitType -eq "Override") {
            Write-Host "All tasks completed successfully. Exiting with code $ExitCode - Override Exit."
            # Clean up the UI runspace
            $Global:UiHash.TaskForm.Close()
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            $Global:TaskHash.TaskListener = $false
            $ExitCode = 4
            Break
        } elseif ($Global:TaskHash.ExitType -eq "Restart") {
            Write-Host "All tasks completed successfully. Exiting with code $ExitCode - Restart Exit."
            # Clean up the UI runspace
            $Global:UiHash.TaskForm.Close()
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            $Global:TaskHash.TaskListener = $false
            $ExitCode = 5
            Break
        } elseif ($Global:TaskHash.ExitType -eq "Shutdown") {
            Write-Host "All tasks completed successfully. Exiting with code $ExitCode - Shutdown Exit."
            # Clean up the UI runspace
            $Global:UiHash.TaskForm.Close()
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            $Global:TaskHash.TaskListener = $false
            $ExitCode = 6
            Break
        } elseif ($Global:TaskHash.ExitType -eq "RestartApp") {
            Write-Host "All tasks completed successfully. Exiting with code $ExitCode - Restart App Exit."
            # Clean up the UI runspace
            $Global:UiHash.TaskForm.Close()
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            $Global:TaskHash.TaskListener = $false
            $ExitCode = 7
            Break
        } else {
            Write-Host "Unknown exit type: $($Global:TaskHash.ExitType). Exiting with code $ExitCode - Unknown Exit."
            # Clean up the UI runspace
            $Global:UiHash.TaskForm.Close()
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            $Global:TaskHash.TaskListener = $false
            $ExitCode = 8
            Break
        }
    }
}

if (-not $ExitCode) {
    $ExitCode = 0
}

if ($ExitCode -eq 4) {
    Return $ExitCode, $OverrideScriptBlock
} else {
    Return $ExitCode
}
