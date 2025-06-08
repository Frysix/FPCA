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
        # Check the online version and ask for update if the online version is newer
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
        if (-not ($result -eq [System.Windows.Forms.MessageBoxDialogResult]::Yes)) {
            Exit
        }
    }
}

# If the script is installed but the user wants to update it, it will download the online version and update in the current insallation directory.
if ($InstallToDo -eq "Update") {

}

# If the script is not installed, it will download the online version and install it.
# display the folder browser dialog
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserDialog.Description = "Please select a folder where FPCA will install."
$FolderBrowserDialog.ShowNewFolderButton = $true
$FolderBrowserDialog.SelectedPath = "C:\"

# Show the dialog and check if the user selected a folder
$result = $FolderBrowserDialog.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $InstallPath = $FolderBrowserDialog.SelectedPath
    Write-Host "Selected installation path: $InstallPath" -ForegroundColor Green
    # Download the online version of the application
    Write-Host $OnlineInfo['General']['Link']
    Pause
} else {
    Write-Host "Installation cancelled." -ForegroundColor Red
    Exit
}