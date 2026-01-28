# Custom Demo PC configuration script
# Creates necessary tasks and ensure proper videos are in place
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$Coms,
    [Parameter(Mandatory=$true)]
    [string]$TaskName,
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot,
    [Parameter(Mandatory=$false)]
    [hashtable]$TaskSettings
)

Try {
    $Coms.Status = "Running"
    $Coms.Progress = 10
    $Coms.Comment = "Starting Demo PC configuration task"

    # Assign variables
    $DemoScriptPath = "C:\Demo_Data"
    $DemoVidPath = "$DemoScriptPath\Boucle_Video.mp4"
    $InstallVideo = $true
    # First Check if the tasks are created and if the required videos are in place.
    if (Test-Path -Path $DemoScriptPath) {
        $Coms.Comment = "Demo_Data folder already exists at $DemoScriptPath"
        # if the folder exists, check for the video. If it exists, ensure its at least 38gb in size.
        if (Test-Path -Path $DemoVidPath) {
            $vidInfo = Get-Item $DemoVidPath
            if ($vidInfo.Length -ge 38GB) {
                $Coms.Comment = "Demo video file exists and is of correct size."
                # Set the flag to indicate video is installed
                $InstallVideo = $false
            } else {
                $Coms.Comment = "Demo video file exists but is not of correct size. Removing file..."
                Remove-Item -Path $DemoVidPath -Force
                $Coms.Comment = "Removed incomplete demo video file."
            }
        } else {
            $Coms.Comment = "Demo video file does not exist."
        }
    } else {
        New-Item -ItemType Directory -Path $DemoScriptPath -Force | Out-Null
        $Coms.Comment = "Created Demo_Data folder at $DemoScriptPath"
    }
    # Update progress
    $Coms.Progress = 20
    # Assign variables for task names
    $TaskNames = @{
        "CloseTask_17h" = "DemoPC_Close_17h"
        "CloseTask_20h" = "DemoPC_Close_20h"
        "OpenTask_9h" = "DemoPC_Open_9h"
    }
    # Check if tasks exist
    $existingTasks = Get-ScheduledTask | Where-Object { $TaskNames.Values -contains $_.TaskName } | Select-Object -ExpandProperty TaskName
    # Clean up existing tasks
    if ($existingTasks.Count -gt 0) {
        $Coms.Comment = @()
        Foreach ($task in $existingTasks) {
            Unregister-ScheduledTask -TaskName $task -Confirm:$false
            $Coms.Comment += "Removed existing scheduled task: $task`n`r"
        }
    }
    # If the video needs to be installed, install it to the folder.
    if ($InstallVideo) {
        $Coms.Comment = "Verifying dependencies..."
        # Verify that the File-Installer script exists
        $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
        if (-not (Test-Path -Path $fileInstallerPath)) {
            Throw "File-Installer.ps1 script not found in $ScriptRoot\Scripts\Install-Scripts"
        }
        # Call the File-Installer script to copy the demo video
        . $fileInstallerPath -ScriptRoot $ScriptRoot -RefName "DEMOVIDEO" -TimeoutSeconds 1200
        # Check the result of the installation
        if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
            $Coms.Comment = "Demo Video installation completed successfully."
        } else {
            Throw "Demo Video installation failed: $($ComsChannel.EndMessage)"
        }
    } else {
        $Coms.Comment = "Demo video already in place, skipping installation."
    }
    # Update progress
    $Coms.Progress = 50
    # Create the scheduled tasks
    # Close at 17h task
    

} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Comment = "Failed to configure Demo PC"
    $Coms.Progress = 0
    $Coms.Status = "Failed"

    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}