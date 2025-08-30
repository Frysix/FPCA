# This script checks for updates and ensures that the first application launch leaves no trace.
# It is designed to be run from the main directory of the application on each launch.
# Start.bat file will call this script to perform the necessary checks and updates.
# It also handles the creation of the Settings.ini file if it does not exist, and updates the fpca.info file on the first launch.

# Ensure the script is run from the main directory
Add-Type -AssemblyName System.Windows.Forms

# Checks if fpca.info exists in the script's directory
if (-not (test-path -path "$Psscriptroot\fpca.info")) {
    [System.Windows.Forms.MessageBox]::Show("Something went terribly wrong! fpca.info file is missing. Please reinstall using FPCA installer.exe!","FPCA - (Frysix's Powershell Configurator App)",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
    Exit
}

# Gather the app info from fpca.info
# This segment reads the fpca.info file, which contains relevant information about the application.
$info = Get-Content -Path "$PSScriptRoot\fpca.info" | ConvertFrom-StringData

# This part only executes if the application is launched for the first time.
# It sets the firstlaunch flag to false and records the installation date.
$IsFirstLaunch = $false
$WasUpdated = $false
if ($info.firstlaunch -eq "true") {
    # Update the fpca.info file to set firstlaunch to false and record the installation date.
    $installdate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $infoContent = [System.Collections.Generic.List[string]]::new()
    foreach ($key in $info.Keys) {
        if ($key -eq "firstlaunch") {
            $infoContent.Add("$key=false")
        } elseif ($key -eq "installdate") {
            $infoContent.Add("$key=$installdate")
        } else {
            $infoContent.Add("$key=$($info.$key)")
        }
    }
    # Write the updated info back to fpca.info file.
    Set-Content -Path "$PSScriptRoot\fpca.info" -Value $infoContent -Encoding UTF8 -Force
    # Set the IsFirstLaunch flag to true for further processing.
    $IsFirstLaunch = $true
} elseif ($info.firstlaunch -eq "update") {
    # If the firstlaunch is set to "update", it means the application was updated.
    # Set the firstlaunch flag to false and record the installation date.
    $infoContent = [System.Collections.Generic.List[string]]::new()
    foreach ($key in $info.Keys) {
        if ($key -eq "firstlaunch") {
            $infoContent.Add("$key=false")
        } else {
            $infoContent.Add("$key=$($info.$key)")
        }
    }
    # Write the updated info back to fpca.info file.
    Set-Content -Path "$PSScriptRoot\fpca.info" -Value $infoContent -Encoding UTF8 -Force
    $WasUpdated = $true
}
# Initialize the requireupdate flag to false.
$RequiresUpdate = $false
# This section compares the current version with the latest version available on github.
if (test-connection 8.8.8.8 -count 1 -quiet) {
    if (test-connection github.com -count 1 -quiet) {
        $GitInfo = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/fpca.info" -UseBasicParsing
        $GitInfoContent = $GitInfo.Content | ConvertFrom-StringData
        if (-not ($info.version -match $GitInfoContent.version)) {
            $RequiresUpdate = $true
        }
    }
}

# Makes the checks for temp files usually installed during setup and deletes them.
# Might make this more modular in the future.
    
# Read the log file and store each line as a string in an array
$LogFilePath = "$env:TEMP\Install.log"
if (Test-Path -Path $LogFilePath) {
    $LogEntries = Get-Content $LogFilePath
    foreach ($entry in $LogEntries) {
        if (test-path -path $entry) {
            # If the entry exists, delete it.
            Remove-Item -Path $entry -Force -ErrorAction SilentlyContinue
        }
    }
    # After processing all entries, delete the log file itself.
    Remove-Item -Path $LogFilePath -Force -ErrorAction SilentlyContinue
}
# Looks for old temp folder and deletes it if it exists.
if (Test-Path -Path "$env:TEMP\FPCA_Temp") {
    Remove-Item -Path "$env:TEMP\FPCA_Temp" -Recurse -Force -ErrorAction SilentlyContinue
}

# This script checks for the existence of Settings.ini in the script's directory.
# If it exists, it reads the settings; if not, it creates a default Settings.ini file.
# The Settings.ini file contains startup settings and general settings for the application.
$loops = 0
$SettingsNotFetched = $true
While ($SettingsNotFetched) {
    if ($loops -lt 5) {
        if (test-path -path "$Psscriptroot\Settings.ini") {
            # Fetch Startup settings from Settings.ini
            $Settings = @{}
            $section = ""
            foreach ($line in Get-Content "$Psscriptroot\Settings.ini") {
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
            # If the Settings.ini file is successfully read, set the flag to false.
            if (-not ($Settings -eq $null)) {
                $SettingsNotFetched = $false
            }
        } else {
            # If Settings.ini does not exist, create a default one by fetching the default settings from the GitHub repository.
            Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/Settings.ini" -Outfile "$Psscriptroot\Settings.ini" -ErrorAction Stop
        }
    } else {
        # If the Settings.ini file cannot be fetched after 5 attempts, show an error message and exit.
        [System.Windows.Forms.MessageBox]::Show("Something went terribly wrong! Settings.ini file is missing or could not be fetched. Please reinstall using FPCA installer.exe!","FPCA - (Frysix's Powershell Configurator App)",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        Exit
    }
    # Wait for a short period before retrying to fetch the Settings.ini file.
    Start-Sleep -Milliseconds 250
    # Increment the loop counter to avoid infinite loops.
    $loops++
}

# This section checks if the application requires an update based on the gathered version information
if ($RequiresUpdate) {
    # Silently update the application if the SilentUpdate setting is true.
    if ($Settings['Update']['UpdateOnStartup'] -eq 'Auto') {
        $null | Out-File "$Psscriptroot\UpdateApp.txt" -Encoding ASCII -Force
        Exit
    } elseif ($Settings['Update']['UpdateOnStartup'] -eq 'Prompt') {
        # If the setting is false or not set, prompt the user to update the application.
        $result = [System.Windows.Forms.MessageBox]::Show("Application version: $($info.version), is obselete.`nDo you want to update to version: $($GitInfoContent.version)?","FPCA - (Frysix's Powershell Configurator App)",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            $null | Out-File "$Psscriptroot\UpdateApp.txt" -Encoding ASCII -Force
            Exit
        }
    }
    $OutdatedLaunch = $true
}

# Checks the integrity of the application files if the IntegrityCheckup setting is true.
if ($Settings['Startup']['IntegrityCheckup'] -eq 'true') {
    # INSERT CODE HERE TO CHECK THE INTEGRITY OF THE APPLICATION FILES
}
# If this is the first launch, create a file to indicate that the first launch has occurred.
if ($IsFirstLaunch) {
    $Null | Out-File "$Psscriptroot\FirstLaunch.txt" -Encoding ASCII -Force
} elseif ($WasUpdated) {
    # If the application was updated, create a file to indicate that the update has occurred.
    $Null | Out-File "$Psscriptroot\UpdatedLaunch.txt" -Encoding ASCII -Force
} elseif ($OutdatedLaunch) {
    # If the application is outdated, create a file to indicate that the application is outdated.
    $Null | Out-File "$Psscriptroot\OutdatedLaunch.txt" -Encoding ASCII -Force
}