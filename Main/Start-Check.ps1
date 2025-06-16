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
$info = @{}
$section = ""
foreach ($line in Get-Content "$Psscriptroot\fpca.info") {
    $line = $line.Trim()
    if ($line -match "^\s*#|^\s*;|^\s*$") {
        continue
    }
    if ($line -match "^\[(.+)\]$") {
        $section = $matches[1]
        $info[$section] = @{}
    } elseif ($line -match "^(.*?)=(.*)$") {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        if ($section -ne "") {
            $info[$section][$key] = $value
        }
    }
}

# This part only executes if the application is launched for the first time.
# It sets the firstlaunch flag to false and records the installation date.
$IsFirstLaunch = $false
if ($info['General']['firstlaunch'] -eq "true") {
    $infoContent = [System.Collections.Generic.List[string]]::new()
    $sectionCount = $info.Keys.Count
    $sectionIndex = 0

    foreach ($section in $info.Keys) {
        $infoContent.Add("[$section]")
        foreach ($key in $info[$section].Keys) {
            $infoContent.Add("$key=$($info[$section][$key])")
        }
        $sectionIndex++
        # Only add a blank line if not the last section
        if ($sectionIndex -lt $sectionCount) {
            $infoContent.Add("")
        }
    }

    # Remove the file if it exists
    if (Test-Path -Path "$PSScriptRoot\fpca.info") {
        Remove-Item -Path "$PSScriptRoot\fpca.info" -Force -ErrorAction SilentlyContinue
    }
    # Write the updated info back to fpca.info file.
    Set-Content -Path "$PSScriptRoot\fpca.info" -Value $infoContent -Encoding UTF8
    # Set the IsFirstLaunch flag to true for further processing.
    $IsFirstLaunch = $true
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

# Silently update the application if the SilentUpdate setting is true.
if ($Settings['Startup']['SilentUpdate'] -eq 'true') {
    # INSERT CODE HERE TO CHECK FOR UPDATES AND APPLY THEM SILENTLY
} else {
    # INSERT CODE HERE TO CHECK FOR UPDATES AND PROMPT THE USER IF AN UPDATE IS AVAILABLE
}
# Checks the integrity of the application files if the IntegrityCheckup setting is true.
if ($Settings['Startup']['IntegrityCheckup'] -eq 'true') {
    # INSERT CODE HERE TO CHECK THE INTEGRITY OF THE APPLICATION FILES
}

# If this is the first launch, create a file to indicate that the first launch has occurred.
if ($IsFirstLaunch) {
    $Null | Out-File "$Psscriptroot\FirstLaunch.txt" -Encoding ASCII -Force
} else {
    # Ensure FirstLaunch.txt is deleted if not first launch
    if (Test-Path -Path "$Psscriptroot\FirstLaunch.txt") {
        Remove-Item -Path "$Psscriptroot\FirstLaunch.txt" -Force -ErrorAction SilentlyContinue
    }
}