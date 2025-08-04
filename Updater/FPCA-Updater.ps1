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
                AlwaysTryFirst = if ($Settings['Update']['AlwaysTryFirst']) { 
                    $Settings['Update']['AlwaysTryFirst'] 
                } else { 
                    "Disabled" 
                }
                TransferSettings = if ($Settings['Update']['TransferSettings']) { 
                    $Settings['Update']['TransferSettings'] 
                } else { 
                    "false" 
                }
            }
            $Global:UpdaterHash.LatestLog += "User preference: $($UpdateSettings.AlwaysTryFirst)`r`n"
        } else {
            $Global:UpdaterHash.LatestLog += "No settings found, using default settings...`r`n"
            $UpdateSettings = @{
                AlwaysTryFirst = "Disabled"
                TransferSettings = "false"
            }
        }
        $Global:UpdaterHash.Progress = 6
        if (Test-Path -Path "$($UpdaterHash.PSScriptRoot)\DownloadLinks.json") {
            $Global:UpdaterHash.LatestLog += "Fetching download links from DownloadLinks.json`r`n"
            $DownloadLinks = Get-Content -Path "$($UpdaterHash.PSScriptRoot)\DownloadLinks.json" | ConvertFrom-Json
            if ($DownloadLinks -ne $null) {
                $Global:UpdaterHash.LatestLog += "Download links fetched successfully`r`n"
            } else {
                Throw "DownloadLinks.json is empty or invalid"
            }
        } else {
            Throw "DownloadLinks.json file not found in script directory"
        }
        
        if ($UpdateSettings.AlwaysTryFirst -ne "GitHub") {
            # Get required modules and scripts
            $Global:UpdaterHash.LatestLog += "Checking for required modules and scripts...`r`n"
            if (Test-Path -Path "$env:TEMP\FPCA_Temp\InternetHelper.psm1") {
                $Global:UpdaterHash.LatestLog += "InternetHelper.psm1 found in TEMP folder`r`n"
            } else {
                $Global:UpdaterHash.LatestLog += "InternetHelper.psm1 not found in TEMP folder, downloading...`r`n"
                Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/Helper/InternetHelper.psm1" -OutFile "$env:TEMP\FPCA_Temp\InternetHelper.psm1"
                if (Test-Path -Path "$env:TEMP\FPCA_Temp\InternetHelper.psm1") {
                    Import-Module -Name "$env:TEMP\FPCA_Temp\InternetHelper.psm1" -Force
                    $Global:UpdaterHash.LatestLog += "InternetHelper.psm1 downloaded and imported successfully`r`n"
                } else {
                    $UpdateSettings.AlwaysTryFirst = "GitHub"
                    $Global:UpdaterHash.LatestLog += "Failed to download InternetHelper.psm1, switching to GitHub fallback`r`n"
                }
            }
        }
        if ($UpdateSettings.AlwaysTryFirst -ne "GitHub") {
            if (Test-Path -Path "$env:TEMP\FPCA_Temp\Threaded-InstallerV2.ps1") {
                $Global:UpdaterHash.LatestLog += "Threaded-InstallerV2.ps1 found in TEMP folder`r`n"
            } else {
                $Global:UpdaterHash.LatestLog += "Threaded-InstallerV2.ps1 not found in TEMP folder, downloading...`r`n"
                Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/Scripts/Install-Scripts/Threaded-InstallerV2.ps1" -OutFile "$env:TEMP\FPCA_Temp\Threaded-InstallerV2.ps1"
                if (Test-Path -Path "$env:TEMP\FPCA_Temp\Threaded-InstallerV2.ps1") {
                    $Global:UpdaterHash.LatestLog += "Threaded-InstallerV2.ps1 downloaded successfully`r`n"
                } else {
                    $UpdateSettings.AlwaysTryFirst = "GitHub"
                    $Global:UpdaterHash.LatestLog += "Failed to download Threaded-InstallerV2.ps1, switching to GitHub fallback`r`n"
                }
            }
        }

        $DownloadSuccessful = $false

        # Check if user has a preferred download source
        if ($UpdateSettings.AlwaysTryFirst -ne "Disabled" -and $UpdateSettings.AlwaysTryFirst -ne "GitHub") {
            $Global:UpdaterHash.LatestLog += "User preference: Always try $($UpdateSettings.AlwaysTryFirst) first`r`n"
            
            # Find the user's preferred link
            $PreferredLink = $DownloadLinks.Links.PSObject.Properties | Where-Object { $_.Name -eq $UpdateSettings.AlwaysTryFirst }
            
            if ($PreferredLink) {
                $LinkName = $PreferredLink.Name
                $LinkData = $PreferredLink.Value
                
                $Global:UpdaterHash.LatestLog += "Testing preferred link: $LinkName`r`n"
                
                # Test the preferred link first
                $Status = Get-HttpWebSiteStatus -Url $LinkData.Url
                if ($Status) {
                    $Global:UpdaterHash.LatestLog += "Preferred link $LinkName is reachable, attempting download...`r`n"
                    $Global:UpdaterHash.State = "Downloading"
                    
                    try {
                        $Global:UpdaterHash.DownloadComs = [hashtable]::Synchronized(@{})
                        . "$env:TEMP\FPCA_Temp\Threaded-InstallerV2.ps1" -Coms $Global:UpdaterHash.DownloadComs -Url $LinkData.Url -OutputFile "$env:TEMP\FPCA_Temp\FPCA.zip" -ChunkNumber 2
                        
                        if ($Global:UpdaterHash.DownloadComs.Status -eq "Completed") {
                            $Global:UpdaterHash.LatestLog += "Download successful from preferred source: $LinkName`r`n"
                            $DownloadSuccessful = $true
                        } else {
                            $Global:UpdaterHash.LatestLog += "Download failed from preferred source ${LinkName}: $($Global:UpdaterHash.DownloadComs.Comment)`r`n"
                        }
                    } catch {
                        $Global:UpdaterHash.LatestLog += "Error downloading from preferred source ${LinkName}: $($_.Exception.Message)`r`n"
                    }
                    
                    $Global:UpdaterHash.State = "Running"
                } else {
                    $Global:UpdaterHash.LatestLog += "Preferred link $LinkName is not reachable`r`n"
                }
            } else {
                $Global:UpdaterHash.LatestLog += "Warning: Preferred source '$($UpdateSettings.AlwaysTryFirst)' not found in download links`r`n"
            }
        }

        # If preferred source failed or wasn't set, try remaining links in priority order
        if (-not $DownloadSuccessful) {
            $Global:UpdaterHash.LatestLog += "Trying remaining download sources in priority order...`r`n"
            
            $ReachableLinks = @()
            
            # Get all links except GitHub and the already-tried preferred link, then sort by priority
            $LinksToTest = $DownloadLinks.Links.PSObject.Properties | Where-Object { 
                $_.Name -ne "GitHub" -and $_.Name -ne $UpdateSettings.AlwaysTryFirst 
            } | Sort-Object { [int]$_.Value.Priority }
            
            $Global:UpdaterHash.LatestLog += "Testing $($LinksToTest.Count) remaining links in priority order...`r`n"
            
            # Test remaining links
            Foreach ($LinkProperty in $LinksToTest) {
                $LinkName = $LinkProperty.Name
                $LinkData = $LinkProperty.Value
                
                $Global:UpdaterHash.LatestLog += "Testing link: $LinkName (Priority: $($LinkData.Priority))`r`n"
                
                # Test the link URL
                $Status = Get-HttpWebSiteStatus -Url $LinkData.Url
                if ($Status) {
                    $Global:UpdaterHash.LatestLog += "Link $LinkName is reachable`r`n"
                    $ReachableLinks += [PSCustomObject]@{
                        Name = $LinkName
                        Url = $LinkData.Url
                        Priority = [int]$LinkData.Priority
                    }
                } else {
                    $Global:UpdaterHash.LatestLog += "Link $LinkName is not reachable`r`n"
                }
                
                $Global:UpdaterHash.Progress += 1
            }
            
            # Sort reachable links by priority for download order
            $ReachableLinks = $ReachableLinks | Sort-Object Priority
            $Global:UpdaterHash.LatestLog += "Found $($ReachableLinks.Count) additional reachable links in priority order`r`n"
            
            # Try downloading from each reachable link
            if ($ReachableLinks.Count -gt 0) {
                $Global:UpdaterHash.State = "Downloading"
                
                foreach ($Link in $ReachableLinks) {
                    if (-not $DownloadSuccessful) {
                        $Global:UpdaterHash.LatestLog += "Attempting download from: $($Link.Name) (Priority: $($Link.Priority))`r`n"
                        
                        try {
                            $Global:UpdaterHash.DownloadComs = [hashtable]::Synchronized(@{})
                            . "$env:TEMP\FPCA_Temp\Threaded-InstallerV2.ps1" -Coms $Global:UpdaterHash.DownloadComs -Url $Link.Url -OutputFile "$env:TEMP\FPCA_Temp\FPCA.zip" -ChunkNumber 2
                            
                            if ($Global:UpdaterHash.DownloadComs.Status -eq "Completed") {
                                $Global:UpdaterHash.LatestLog += "Download successful from $($Link.Name)`r`n"
                                $DownloadSuccessful = $true
                            } else {
                                $Global:UpdaterHash.LatestLog += "Download failed from $($Link.Name): $($Global:UpdaterHash.DownloadComs.Comment)`r`n"
                            }
                        } catch {
                            $Global:UpdaterHash.LatestLog += "Error downloading from $($Link.Name): $($_.Exception.Message)`r`n"
                        }
                    }
                }
                
                $Global:UpdaterHash.State = "Running"
            }
        }

        # GitHub fallback (if all other sources failed)
        if (-not $DownloadSuccessful) {
            $Global:UpdaterHash.LatestLog += "All priority links failed, falling back to GitHub...`r`n"
            
            # Check if GitHub is reachable
            $GitHubReachable = Test-Connection github.com -Count 1 -Quiet
            if ($GitHubReachable) {
                $Global:UpdaterHash.LatestLog += "GitHub is reachable, attempting download...`r`n"
                $Global:UpdaterHash.State = "Downloading"
                
                try {
                    # GitHub download using direct Invoke-WebRequest
                    $GitHubUrl = $DownloadLinks.Links.GitHub.Url
                    $OutputPath = "$env:TEMP\FPCA_Temp\FPCA.zip"
                    
                    $Global:UpdaterHash.LatestLog += "Downloading from GitHub: $GitHubUrl`r`n"
                    Invoke-WebRequest -Uri $GitHubUrl -OutFile $OutputPath
                    
                    if (Test-Path $OutputPath) {
                        $Global:UpdaterHash.LatestLog += "Download successful from GitHub`r`n"
                        $DownloadSuccessful = $true
                    } else {
                        $Global:UpdaterHash.LatestLog += "GitHub download failed - file not found`r`n"
                    }
                    
                } catch {
                    $Global:UpdaterHash.LatestLog += "Error downloading from GitHub: $($_.Exception.Message)`r`n"
                }
                
                $Global:UpdaterHash.State = "Running"
            } else {
                $Global:UpdaterHash.LatestLog += "GitHub is not reachable`r`n"
            }
        }

        # Final check
        if (-not $DownloadSuccessful) {
            Throw "Failed to download the update from all available sources"
        } else {
            $Global:UpdaterHash.LatestLog += "Download phase completed successfully`r`n"
            $Global:UpdaterHash.Progress = 50
        }
        # Extract the downloaded file
        $Global:UpdaterHash.LatestLog += "Extracting downloaded file...`r`n"
        $ExtractPath = "$env:TEMP\FPCA_Temp\"
        if (Test-Path -Path "$env:TEMP\FPCA_Temp\FPCA.zip") {
            Expand-Archive -Path "$env:TEMP\FPCA_Temp\FPCA.zip" -DestinationPath $ExtractPath -Force
            $Global:UpdaterHash.LatestLog += "Extraction completed successfully`r`n"
            $Global:UpdaterHash.Progress = 60
        } else {
            Throw "Downloaded file not found at $env:TEMP\FPCA_Temp\FPCA.zip"
        }

        # Check if the setting to transfer settings is enabled
        if ($UpdateSettings.TransferSettings -eq "true") {
            $Global:UpdaterHash.LatestLog += "Transferring settings from old installation...`r`n"
            # Transfer settings from old installation
            if (Test-Path -Path "$InstallPath\Settings.ini") {
                $NewSettings = @{}
                $section = ""
                foreach ($line in Get-Content "$ExtractPath\FPCA\Settings.ini") {
                    $line = $line.Trim()
                    if ($line -match "^\s*#|^\s*;|^\s*$") {
                        continue
                    }
                    if ($line -match "^\[(.+)\]$") {
                        $section = $matches[1]
                        $NewSettings[$section] = @{}
                    } elseif ($line -match "^(.*?)=(.*)$") {
                        $key = $matches[1].Trim()
                        $value = $matches[2].Trim()
                        if ($section -ne "") {
                            $NewSettings[$section][$key] = $value
                        }
                    }
                }
                if ($NewSettings -ne $null) {
                    $Global:UpdaterHash.LatestLog += "Settings transferred successfully`r`n"
                    # Once the new settings are parsed, replace existing Entries in NewSettings with old settings and write to the new Settings.ini file
                    foreach ($section in $NewSettings.Keys) {
                        if ($Settings[$section]) {
                            foreach ($key in $Settings[$section].Keys) {
                                $NewSettings[$section][$key] = $Settings[$section][$key]
                            }
                        }
                    }
                    # Write the new settings to the new Settings.ini file
                    $NewSettingsContent = ""
                    foreach ($section in $NewSettings.Keys) {
                        $NewSettingsContent += "[$section]`r`n"
                        foreach ($key in $NewSettings[$section].Keys) {
                            $NewSettingsContent += "$key=$($NewSettings[$section][$key])`r`n"
                        }
                        $NewSettingsContent += "`r`n"
                    }
                    Set-Content -Path "$ExtractPath\FPCA\Settings.ini" -Value $NewSettingsContent -Force
                    $Global:UpdaterHash.LatestLog += "New Settings.ini file created successfully`r`n"
                } else {
                    Throw "Failed to parse new Settings.ini file"
                }
            } else {
                Throw "Can't find new Settings.ini file."
            }
        } else {
            $Global:UpdaterHash.LatestLog += "Transfer settings option is disabled, skipping transfer`r`n"
        }
        $Global:UpdaterHash.Progress = 65

        # Check if the setting to transfer Mods is enabled
        if ($UpdateSettings.TransferMods -eq "true") {
            $Global:UpdaterHash.LatestLog += "Transferring Mods from old installation...`r`n"
            # Transfer Mods from old installation
        } else {
            $Global:UpdaterHash.LatestLog += "Transfer Mods option is disabled, skipping transfer`r`n"
        }
        $Global:UpdaterHash.Progress = 70

        # Check if the setting to transfer PortableApps is enabled
        if ($UpdateSettings.TransferPortableApps -eq "true") {
            $Global:UpdaterHash.LatestLog += "Transferring PortableApps from old installation...`r`n"
            # Transfer PortableApps from old installation
        } else {
            $Global:UpdaterHash.LatestLog += "Transfer PortableApps option is disabled, skipping transfer`r`n"
        }
        $Global:UpdaterHash.Progress = 75

        # Delete the old installation
        $Global:UpdaterHash.LatestLog += "Deleting old installation...`r`n"
        if (Test-Path -Path $InstallPath) {
            Remove-Item -Path $InstallPath -Recurse -Force
            $Global:UpdaterHash.LatestLog += "Old installation deleted successfully`r`n"
        } else {
            $Global:UpdaterHash.LatestLog += "Old installation path does not exist, skipping deletion`r`n"
        }
        $Global:UpdaterHash.Progress = 80
        # Move the new installation to the old installation path
        $Global:UpdaterHash.LatestLog += "Moving new installation to old installation path...`r`n"
        if (Test-Path -Path "$ExtractPath\FPCA") {
            Move-Item -Path "$ExtractPath\FPCA" -Destination $InstallPath -Force
            $Global:UpdaterHash.LatestLog += "New installation moved successfully to $InstallPath`r`n"
        } else {
            Throw "New installation folder not found at $ExtractPath\FPCA"
        }
        $Global:UpdaterHash.Progress = 90
        # Create a new fpca.info file
        $Global:UpdaterHash.LatestLog += "Creating new fpca.info file...`r`n"
        $NewInfoContent = "version=$($Global:UpdaterHash.Versions.New)`r`n"
        $NewInfoContent += "firstlaunch=update"
        $NewInfoContent += "installdate=$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`r`n"
        Set-Content -Path "$InstallPath\fpca.info" -Value $NewInfoContent -Force
        $Global:UpdaterHash.LatestLog += "New fpca.info file created successfully`r`n"
        $Global:UpdaterHash.Progress = 95
        # Give Launch Path to the main loop
        $Global:UpdaterHash.StartPath = $InstallPath
        # Indicate that the update was successful
        $Global:UpdaterHash.State = "Completed"
    } Catch {
        Start-Sleep -Seconds 3
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
        if ($Global:UpdaterHash.LatestLog -ne $OldLog -or $Global:UpdaterHash.LatestLog -ne @()) {
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
        $Global:UiHash.PROGRESS_NUM_LABEL.Text = "$($Global:UpdaterHash.Progress)%"
        $Global:UiHash.MAIN_UPDATE_PROGRESSBAR.Value = 0
        $Global:UiHash.LIVEINFO_TEXTBOX.Text += "Update failed:`r`n$($Global:UpdaterHash.LatestLog)`r`n"
        [System.Windows.Forms.MessageBox]::Show("An error occurred during the update process.", "FPCA - Update Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $Global:UiHash.ClosedBy = "UpdateFailed"
        $Global:UiHash.TIMER.Stop()
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
        Start-Sleep -Seconds 5
        $Global:UiHash.TIMER.Stop()
        $Global:UiHash.UPDATER_MAIN_FORM.Close()
        While ($Global:UiHash.UiClosed -eq $false) {
            Start-Sleep -Milliseconds 100 # 0.1 seconds refresh
        }
        Start-Process -FilePath "$($Global:UpdaterHash.StartPath)\Start.bat" -WorkingDirectory $Global:UpdaterHash.StartPath -WindowStyle Hidden -Verb RunAs
        Exit
    } elseif ($Global:UpdaterHash.State -eq "Downloading") {
        Write-Host "Updater is downloading files..." -ForegroundColor Cyan
        $Global:UiHash.LIVESTATUS_TEXT_LABEL.Text = "Downloading..."
        $lines = $Global:UiHash.LIVEINFO_TEXTBOX.Text -split "`r`n"
        $lastLineIndex = $lines.Length - 1
        if ($lines[$lastLineIndex] -match "Downloading...") {
            $lines[$lastLineIndex] = $($Global:UpdaterHash.DownloadComs.Comment)
            $Global:UiHash.LIVEINFO_TEXTBOX.Text = $lines -join "`r`n"
            $Global:UiHash.LIVEINFO_TEXTBOX.ScrollToCaret()
        } else {
            $Global:UiHash.LIVEINFO_TEXTBOX.Text += "`r`nDownloading..."
        }
    } else {
        Write-Host "Updater is in an unknown state: $($Global:UpdaterHash.State)" -ForegroundColor Yellow
    }
}