# FPCA main updater script
# This script is responsible for updating the FPCA application.

# Define variables
$Global:UiHash = [hashtable]::Synchronized(@{})
$Global:UpdaterHash = [hashtable]::Synchronized(@{})
# Define Paths
$Global:UiHash.PSScriptRoot = $PSScriptRoot
$Global:UpdaterHash.PSScriptRoot = $PSScriptRoot
# Define Bools
$Global:UiHash.UiLoaded = $false
$Global:UiHash.UiClosed = $false
$Global:UpdaterHash.MainListernerLoop = $false
# Define Strings
$Global:UiHash.ClosedBy = ""
$Global:UiHash.UpdaterState = "Initializing"
$Global:UpdaterHash.State = "Initializing"
# Define Arrays
$Global:UiHash.LatestLog = @()
# Define hashtables
$Global:UiHash.Versions = @{
    New = ""
    Old = ""
}
$Global:UpdaterHash.Versions = @{
    New = ""
    Old = ""
}
$OldLog = ""
# Define Ints
$Global:UpdaterHash.Progress = 0

# Prepare both runspaces for the updater UI and main logic
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

        # Create a timer to do subtle updates to the UI
        $Timer = New-Object System.Windows.Forms.Timer
        $Timer.Interval = 200 # 0.2 second
        $Timer.Add_Tick({
            # Update the live status label with a subtle animation
            if ($LIVESTATUS_TEXT_LABEL.Text -eq "$($Global:UiHash.UpdaterState)...") {
                $LIVESTATUS_TEXT_LABEL.Text = "$($Global:UiHash.UpdaterState).."
            } elseif ($LIVESTATUS_TEXT_LABEL.Text -eq "$($Global:UiHash.UpdaterState)..") {
                $LIVESTATUS_TEXT_LABEL.Text = "$($Global:UiHash.UpdaterState)."
            } elseif ($LIVESTATUS_TEXT_LABEL.Text -eq "$($Global:UiHash.UpdaterState).") {
                $LIVESTATUS_TEXT_LABEL.Text = "$($Global:UiHash.UpdaterState)..."
            } else {
                $LIVESTATUS_TEXT_LABEL.Text = "$($Global:UiHash.UpdaterState)..."
            }
            if ($Global:UiHash.Versions.New -ne $UPDATINGTO_NUM_LABEL.Text) {
                $UPDATINGTO_NUM_LABEL.Text = $Global:UiHash.Versions.New
            }
            if ($Global:UiHash.Versions.Old -ne $CURRENTVERSION_NUM_LABEL.Text) {
                $CURRENTVERSION_NUM_LABEL.Text = $Global:UiHash.Versions.Old
            }
            # Scroll the live info textbox to the bottom
            $LIVEINFO_TEXTBOX.ScrollToCaret()
        })

        # Assign controls to the UiHash
        $Global:UiHash.UPDATER_MAIN_FORM = $UPDATER_MAIN_FORM
        $Global:UiHash.PROGRESS_NUM_LABEL = $PROGRESS_NUM_LABEL
        $Global:UiHash.MAIN_UPDATE_PROGRESSBAR = $MAIN_UPDATE_PROGRESSBAR
        $Global:UiHash.LIVEINFO_TEXTBOX = $LIVEINFO_TEXTBOX
        $Global:UiHash.UPDATINGTO_NUM_LABEL = $UPDATINGTO_NUM_LABEL
        $Global:UiHash.CURRENTVERSION_NUM_LABEL = $CURRENTVERSION_NUM_LABEL
        $Global:UiHash.LIVESTATUS_TEXT_LABEL = $LIVESTATUS_TEXT_LABEL
        $Global:UiHash.TIMER = $Timer

        # Add load event to the main form
        $UPDATER_MAIN_FORM.Add_Load({
            # Indicate that the UI has been loaded
            $Timer.Start()
            $Global:UiHash.UiLoaded = $true
        })

        # Show the main form
        $UPDATER_MAIN_FORM.ShowDialog()

        # Checks for form closing reasons
        if ($Global:UiHash.ClosedBy -eq "UpdateFinished") {
            # If the update was successful, show a message box
            [System.Windows.Forms.MessageBox]::Show("Update completed successfully. The application will now restart.", "FPCA - Update Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $Global:UiHash.UiClosed = $true
        } elseif ($Global:UiHash.ClosedBy -eq "UpdateFailed") {
            # If the update failed, show a message box
            [System.Windows.Forms.MessageBox]::Show("Update failed. Please try again later.", "FPCA - Update Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            $Global:UiHash.UiClosed = $true
        } else {
            # If the user cancelled the update, show a message box
            [System.Windows.Forms.MessageBox]::Show("Update cancelled by user.", "FPCA - Update Cancelled", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $Global:UiHash.UiClosed = $true
        }

    } Catch {
        # Handle any exceptions that occur during the UI script execution
        Write-Host "Error in Updater UI script: $($_.Exception.Message)" -ForegroundColor Red
        [System.Windows.Forms.MessageBox]::Show("An error occurred while loading the updater UI. Please check the logs for more details.", "FPCA - UI Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $Global:UiHash.UiClosed = $true
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
# Create new runspace for the main updater logic
$UpdaterRunspace = [runspacefactory]::CreateRunspace()
$UpdaterRunspace.ApartmentState = "STA"
$UpdaterRunspace.ThreadOptions = "ReuseThread"
$UpdaterRunspace.Open()
$UpdaterRunspace.SessionStateProxy.SetVariable('UpdaterHash',$Global:UpdaterHash)
$UpdaterPowershell = [powershell]::Create()
$UpdaterPowershell.Runspace = $UpdaterRunspace
# Load the main updater script
$Null = $UpdaterPowershell.AddScript({
    ### UPDATER SCRIPT ###
    # Wait for the UI to load before starting the updater logic
    $TimeoutCount = 0
    While ($Global:UpdaterHash.MainListernerLoop -eq $false) {
        Start-Sleep -Milliseconds 300 # 0.2 seconds refresh
        # Add a check to handle if the UI is frozen or not responding by adding a timeout
        if ($TimeoutCount -gt 1000) {
            $Global:UpdaterHash.State = "Failed"
            $Global:UpdaterHash.LatestLog += "Updater UI is not responding. Exiting updater script." + "`r`n"
            Write-Host "Updater UI is not responding. Exiting updater script." -ForegroundColor Red
            Exit
        } else {
            $TimeoutCount++
        }
    }
    Try {
        $Global:UpdaterHash.State = "Running"
        $Global:UpdaterHash.LatestLog += "Starting updater script...`r`n"
        $Global:UpdaterHash.Progress = 1
        $Global:UpdaterHash.LatestLog += "Fetching old installation's path...`r`n"
        # Get the old installation path
        if (Test-Path -Path "$env:TEMP\FPCA_Temp\OldInstall.txt") {
            $InstallPath = Get-Content -Path "$env:TEMP\FPCA_Temp\OldInstall.txt"
        } else {
            Throw "Old installation path not found in TEMP folder"
        }
        $InstallPath = $InstallPath.Trim()
        if (Test-Path -Path $InstallPath) {
            $Global:UpdaterHash.LatestLog += "Old installation path found: $InstallPath`r`n"
            $Global:UpdaterHash.Progress = 2
        } else {
            Throw "Old installation path does not exist: $InstallPath"
        }
        $Global:UpdaterHash.LatestLog += "Fetching old fpca.info`r`n"
        if (Test-Path -Path "$InstallPath\fpca.info") {
            $OldInfo = Get-Content -Path "$InstallPath\fpca.info" -Raw
            $Global:UpdaterHash.Versions.Old = ($OldInfo | ConvertFrom-StringData).version
            $Global:UpdaterHash.LatestLog += "Old version found: $($Global:UpdaterHash.Versions.Old)`r`n"
            $Global:UpdaterHash.Progress = 3
        } else {
            Throw "fpca.info file not found in old installation path"
        }
        $Global:UpdaterHash.LatestLog += "Fetching new fpca.info`r`n"
        $NewInfo = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/fpca.info" -UseBasicParsing
        if ($NewInfo) {
            $Global:UpdaterHash.Versions.New = ($NewInfo.Content | ConvertFrom-StringData).version
            $Global:UpdaterHash.LatestLog += "New version found: $($Global:UpdaterHash.Versions.New)`r`n"
            $Global:UpdaterHash.Progress = 4
        } else {
            Throw "Failed to fetch new fpca.info"
        }
        $Global:UpdaterHash.LatestLog += "Fetching update related settings from Settings.ini`r`n"
        if (Test-Path -Path "$InstallPath\Settings.ini") {
            $Settings = @{}
            $section = ""
            foreach ($line in Get-Content "$InstallPath\Settings.ini") {
                $line = $line.Trim()
                if ($line -match "^\s*#|^\s*;|^\s*$") {
                    continue
                }
                if ($line -match "^\[(.+)\]$") {
                    $section = $matches[1]
                    $Settings[$section] = @{}
                } elseif ($line -match "^(.*?)=(.*)$") {
                    $key = $matches[1].Trim()
                    $value = $matches[2].Trim()
                    if ($section -ne "") {
                        $Settings[$section][$key] = $value
                    }
                }
            }
            if ($Settings -ne $null) {
                $Global:UpdaterHash.LatestLog += "Settings fetched successfully`r`n"
                $SettingsFound = $true
            } else {
                $SettingsFound = $false
            }
        } else {
            $SettingsFound = $false
        }
        $Global:UpdaterHash.Progress = 5
        if ($SettingsFound) {
            $Global:UpdaterHash.LatestLog += "Applying found settings...`r`n"
            $UpdateSettings = @{
                AlwaysGitHubFirst = $Settings['Update']['AlwaysGitHubFirst']
                TransferSettings = $Settings['Update']['TransferSettings']
            }
        } else {
            $Global:UpdaterHash.LatestLog += "No settings found, using default settings...`r`n"
            $UpdateSettings = @{
                AlwaysGitHubFirst = "Disabled"
                TransferSettings = "false"
            }
        }
        $Global:UpdaterHash.Progress = 6
        if (Test-Path -Path "$($UpdaterHash.PSScriptRoot)\DownloadLinks.json") {
            $Global:UpdaterHash.LatestLog += "Fetching download links from DownloadLinks.json`r`n"
            $DownloadLinks = Get-Content -Path "$PSScriptRoot\DownloadLinks.json" | ConvertFrom-Json
            if ($DownloadLinks.Links -ne $null) {
                $Global:UpdaterHash.LatestLog += "Download links fetched successfully`r`n"
                $Global:UpdaterHash.Progress = 7
            } else {
                Throw "DownloadLinks.json file is empty or malformed"
            }
        } else {
            Throw "DownloadLinks.json file not found in script directory"
        }
        if ($UpdateSettings.AlwaysGitHubFirst -ne "disabled") {

        } else {

        }

    } Catch {
        $Global:UpdaterHash.State = "Failed"
        $Global:UpdaterHash.LatestLog += "An error ocurred during the updating process: $($_.Exception.Message)`r`n"
        Write-Host $($_.Exception.Message) -ForegroundColor Red
        Exit
    }
})
# Register object event to handle the end of the updater script
$Null = Register-ObjectEvent -InputObject $UpdaterPowershell -EventName InvocationStateChanged -Action {
    $State = $EventArgs.InvocationStateInfo.State
    if ($State -in 'Completed', 'Failed') {
        $UpdaterPowershell.EndInvoke($UpdaterHandle)
        $UpdaterPowershell.Runspace.Dispose()
    }
}

# Start the both the UI and updater scripts
$UiHandle = $UiPowershell.BeginInvoke()
$UpdaterHandle = $UpdaterPowershell.BeginInvoke()

# Wait for the UI to load and the Updater to be ready
While ($Global:UiHash.UiLoaded -eq $false) {
    Start-Sleep -Milliseconds 200 # 0.2 seconds refresh
    # Checks if the UI was closed
    if ($Global:UiHash.UiClosed) {
        # If the UI was closed, exit the script
        Write-Host "Updater UI was closed. Exiting updater script." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        Exit
    }
}

# Set the bool to indicate the main loop is running
$Global:UpdaterHash.MainListernerLoop = $true
# Main Listener loop to synchronize the UI and updater scripts
While ($Global:UpdaterHash.MainListernerLoop) {
    Start-Sleep -Milliseconds 50 # 0.05 seconds refresh
    # Check if the UI was closed
    if ($Global:UiHash.UiClosed) {
        # If the UI was closed, exit the script
        Write-Host "Updater UI was closed. Exiting updater script." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        Exit
    }
    # Check if the updater state has changed
    if ($Global:UiHash.UpdaterState -ne $Global:UpdaterHash.State) {
        $Global:UiHash.UpdaterState = $Global:UpdaterHash.State
        Write-Host "Ui ref to Updater state changed to: $($Global:UpdaterHash.State)"
    }
    if ($Global:UiHash.Versions.New -ne $Global:UpdaterHash.Versions.New) {
        $Global:UiHash.Versions.New = $Global:UpdaterHash.Versions.New
        Write-Host "Ui ref to Updater new version changed to: $($Global:UpdaterHash.Versions.New)"
    } elseif ($Global:UiHash.Versions.Old -ne $Global:UpdaterHash.Versions.Old) {
        $Global:UiHash.Versions.Old = $Global:UpdaterHash.Versions.Old
        Write-Host "Ui ref to Updater old version changed to: $($Global:UpdaterHash.Versions.Old)"
    }
    # Update the UI with the current state of the updater
    if ($Global:UpdaterHash.State -eq "Running") {
        if ($Global:UpdaterHash.LatestLog -ne $OldLog -or $Global:UpdaterHash.LatestLog -eq @()) {
            $OldLog = $Global:UpdaterHash.LatestLog
            $Global:UiHash.LIVEINFO_TEXTBOX.AppendText($Global:UpdaterHash.LatestLog)
            $Global:UiHash.LIVEINFO_TEXTBOX.ScrollToCaret()
            $Global:UiHash.LIVEINFO_TEXTBOX.Refresh()
            $Global:UpdaterHash.LatestLog = @()
        }
        if ($Global:UpdaterHash.Progress -ne $Global:UiHash.MAIN_UPDATE_PROGRESSBAR.Value) {
            $Global:UiHash.MAIN_UPDATE_PROGRESSBAR.Value = $Global:UpdaterHash.Progress
            $Global:UiHash.PROGRESS_NUM_LABEL.Text = "$($Global:UiHash.MAIN_UPDATE_PROGRESSBAR.Value)%"
        }
    } elseif ($Global:UpdaterHash.State -eq "Failed") {
        Write-Host "Updater failed with error: $($Global:UpdaterHash.LatestLog)" -ForegroundColor Red
        $Global:UiHash.PROGRESS_NUM_LABEL.Text = "$($Global:UiHash.MAIN_UPDATE_PROGRESSBAR.Value)%"
        $Global:UiHash.LIVEINFO_TEXTBOX.Text += "Update failed:`r`n$($Global:UpdaterHash.LatestLog)`r`n"
        $Global:UiHash.ClosedBy = "UpdateFailed"
        $Global:UiHash.TIMER.Stop()
        [System.Windows.Forms.MessageBox]::Show("An error occurred during the update process. Please check the logs for more details.", "FPCA - Update Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $Global:UiHash.UPDATER_MAIN_FORM.Close()
        While ($Global:UiHash.UiClosed -eq $false) {
            Start-Sleep -Milliseconds 100 # 0.1 seconds refresh
        }
        Exit
    } elseif ($Global:UpdaterHash.State -eq "Completed") {
        Write-Host "Updater completed successfully." -ForegroundColor Green
        $Global:UiHash.MAIN_UPDATE_PROGRESSBAR.Value = 100
        $Global:UiHash.PROGRESS_NUM_LABEL.Text = "100%"
        $Global:UiHash.LIVEINFO_TEXTBOX.Text += "$($Global:UpdaterHash.LatestLog)`r`nUpdate completed successfully.`r`n"
        $Global:UiHash.ClosedBy = "UpdateFinished"
        $Global:UiHash.TIMER.Stop()
        Start-Sleep -Seconds 2
        $Global:UiHash.UPDATER_MAIN_FORM.Close()
        While ($Global:UiHash.UiClosed -eq $false) {
            Start-Sleep -Milliseconds 100 # 0.1 seconds refresh
        }
        Exit
    }
}