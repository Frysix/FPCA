# Standardized Installer Script for Windows

# Starting Message
Write-Host "Starting Installer script..."

# Adding the required assembly for Windows Forms to display message boxes
Add-Type -AssemblyName System.Windows.Forms

# Checks if there is an existing installation
# Ininitializes the $DriveLetters array
$DriveLetters = @()
# Get all logical disks with DriveType 2 (Removable) and 3 (Local Disk)
$Drives = Get-CimInstance Win32_LogicalDisk | Where-Object {
    $_.DriveType -in 2, 3
}
# Collects the DeviceID of each drive into the $DriveLetters array
foreach ($Drive in $Drives) {
    $DriveLetters += $Drive.DeviceID
}

# Display the found drives
Write-Host "Drives found:" -ForegroundColor Cyan
$DriveLetters | ForEach-Object { Write-Host $_ }

# Get the online fpca.info file from the GitHub repository
$OnlineRawInfo = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/fpca.info" -UseBasicParsing
$lines = $OnlineRawInfo.Content -split "`n"
$OnlineInfo = @{}
$section = ""
# Parse the online fpca.info online content
foreach ($line in $lines) {
    $line = $line.Trim()
    if ($line -match "^\s*#|^\s*;|^\s*$") {
        continue
    }
    if ($line -match "^\[(.+)\]$") {
        $section = $matches[1]
        $OnlineInfo[$section] = @{}
    } elseif ($line -match "^(.*?)=(.*)$") {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        if ($section -ne "") {
            $OnlineInfo[$section][$key] = $value
        }
    }
}

# Checks if there is an existing installation on any of the drives
# If an installation is found, it reads the fpca.info file and displays the version and start file.
foreach ($Letter in $DriveLetters) {
    if (test-path -path "$Letter\FPCA\fpca.info") {
        $FPCAPath = "$Letter\FPCA"
        $info = @{}
        $section = ""
        # Parse the fpca.info content
        foreach ($line in Get-Content "$Letter\FPCA\fpca.info") {
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
        Write-Host "Existing installation found on drive $Letter" -ForegroundColor Yellow
        Write-Host "Version: $($info['General']['Version'])" -ForegroundColor Yellow
        # Compare the online version with the local version and launch the installed script if the versions match
        if ($OnlineInfo['General']['Version'] -eq $info['General']['Version']) {
            $InstallToDo = "Installed"
        } else {
            $result = [System.Windows.Forms.MessageBox]::Show("A New version of FPCA is available. Do you want to update to version: $($OnlineInfo['General']['Version'])?","FPCA Installer",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information)
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                $InstallToDo = "Update"
            } else {
                $InstallToDo = "Installed"
            }
        }
    }
}

# If the script is already installed it checks if the start file exists and starts it.
# If the start file does not exist, it prompts the user to install the online version.
if ($InstallToDo -eq "Installed") {
    if (Test-Path -Path "$Letter\FPCA\$($info['Files']['start'])") {
        Write-Host "Start file found: $($info['Files']['start'])" -ForegroundColor Yellow
        Start-Process -WindowStyle Hidden -FilePath "$Letter\FPCA\$($info['Files']['start'])" -WorkingDirectory $FPCAPath -Verb Runas
        Exit
    } else {
        Write-Host "Start file not found: $($info['Files']['start'])" -ForegroundColor Red
        $result = [System.Windows.Forms.MessageBox]::Show("Cannot find Start file. Do you want to install version: $($OnlineInfo['General']['Version'])?","FPCA Installer",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information)
        if (-not ($result -eq [System.Windows.Forms.DialogResult]::Yes)) {
            Exit
        }
    }
}

# If the script is installed but the user wants to update it, it will download the online version and update in the current installation directory.
if ($InstallToDo -eq "Update") {

}

# If the script is not installed, it will download the online version and install it.
# display the folder browser dialog
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserDialog.Description = "Please select a folder where FPCA will install."
$FolderBrowserDialog.ShowNewFolderButton = $true
$FolderBrowserDialog.SelectedPath = "C:\"

# Show the dialog and check if the user selected a folder
$loops = 0
$InstallPath = ""
$PathNull = $true
While ($PathNull) {
    if ($loops -lt 5) {
        $result = $FolderBrowserDialog.ShowDialog()
        if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
            $InstallPath = $FolderBrowserDialog.SelectedPath
            if (test-path -path $InstallPath) {
                Write-Host "Selected installation path: $InstallPath" -ForegroundColor Green
                $PathNull = $false
            } else {
                Write-Host "Selected path does not exist. Please select a valid folder." -ForegroundColor Red
                $FolderBrowserDialog.SelectedPath = "C:\"
            }
        } else {
            Write-Host "Installation cancelled." -ForegroundColor Red
            $result = [System.Windows.Forms.MessageBox]::Show("Installation cancelled. Do you want to exit?","FPCA Installer",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information)
            if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                Exit
            }
        }
        $loops++
    } else {
        Write-Host "Too many attempts to select a folder. Exiting installation." -ForegroundColor Red
        $result = [System.Windows.Forms.MessageBox]::Show("Too many attempts to select a folder. Do you want to exit?","FPCA Installer",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Exit
        } else {
            $loops = 0
            $FolderBrowserDialog.SelectedPath = "C:\"
        }
    }
}

Write-Host "Downloading new installation from: $OnlineInfo['General']['Link']" -ForegroundColor Cyan
# Download WebInstaller.ps1 from the online repository
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/InternetHelper/WebInstaller.ps1" -OutFile "$env:TEMP\WebInstaller.ps1"
if (-not (Test-Path -Path "$env:TEMP\WebInstaller.ps1")) {
    Write-Host "Failed to download WebInstaller.ps1. Exiting installation." -ForegroundColor Red
    Exit
}

# Start the WebInstaller script to download the files
Write-Host "Starting WebInstaller script..." -ForegroundColor Cyan

# Initialize the global progress table for the WebInstaller script
$Global:ProgressTable = [hashtable]::Synchronized(@{})
# Launch the WebInstaller script with the required parameters
& "$env:TEMP\WebInstaller.ps1" -ProgressTable $Global:ProgressTable -Url $OnlineInfo['General']['Link'] -OutputFile "$InstallPath\FPCA" -ChunkNumber 4 -ConnectionLimit 10