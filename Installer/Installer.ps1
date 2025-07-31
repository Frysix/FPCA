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
$OnlineInfo = $OnlineRawInfo.Content | ConvertFrom-StringData

# Checks if there is an existing installation on any of the drives
# If an installation is found, it reads the fpca.info file and displays the version and start file.
foreach ($Letter in $DriveLetters) {
    if (test-path -path "$Letter\FPCA\fpca.info") {
        $InstallToDo = "Installed"
        $FPCAPath = "$Letter\FPCA"
        Write-Host "Found existing installation at: $FPCAPath" -ForegroundColor Green
    }
}

# If the script is already installed it checks if the start file exists and starts it.
# If the start file does not exist, it prompts the user to install the online version.
if ($InstallToDo -eq "Installed") {
    if (Test-Path -Path "$FPCAPath\Start.bat") {
        Write-Host "Start batch file found. Starting FPCA..." -ForegroundColor Green
        $LogContent = @(
            "$env:TEMP\Installer.ps1",
            "$env:TEMP\FPCAinstaller.bat"
        )
        # Create a log of the files used in the launch
        $LogFilePath = "$env:TEMP\Install.log"
        if (Test-Path -Path $LogFilePath) {
            Remove-Item -Path $LogFilePath -Force -ErrorAction SilentlyContinue
        }
        # Add the installation details to the log content
        New-Item -Path $LogFilePath -ItemType File -Force | Out-Null
        Set-Content -Path $LogFilePath -Value $LogContent -Encoding UTF8
        Start-Process -WindowStyle Hidden -FilePath "$FPCAPath\Start.bat" -WorkingDirectory $FPCAPath -Verb Runas
        Exit
    } else {
        Write-Host "Start batch file not found" -ForegroundColor Red
        $result = [System.Windows.Forms.MessageBox]::Show("Cannot find Start file. Do you want to install version: $($OnlineInfo['version'])?","FPCA - Installer",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information)
        if (-not ($result -eq [System.Windows.Forms.DialogResult]::Yes)) {
            Exit
        }
    }
}

# If the script is not installed, it will download the online version and install it.
# display the folder browser dialog
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserDialog.Description = "Please select a folder where FPCA will install."
$FolderBrowserDialog.ShowNewFolderButton = $true
$FolderBrowserDialog.SelectedPath = "C:\"

# Loop to ensure a valid installation path is selected
# If the user selects an invalid path or cancels the dialog, it will prompt the user to select a valid folder.
# If the user selects a valid path, it will proceed with the installation.
# If the user cancels the dialog, it will prompt the user to exit the installation.
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

Write-Host "Downloading new installation from: https://fpca-app.frysix.com" -ForegroundColor Cyan
# Download Threaded-Installer.ps1 from the online repository
Invoke-WebRequest -Uri "https://github.com/Frysix/FPCA/raw/refs/heads/main/Main/Scripts/Install-Scripts/Threaded-InstallerV2.ps1" -OutFile "$env:TEMP\Threaded-InstallerV2.ps1"
if (-not (Test-Path -Path "$env:TEMP\Threaded-InstallerV2.ps1")) {
    Write-Host "Failed to download Threaded-InstallerV2.ps1. Exiting installation." -ForegroundColor Red
    Exit
}

# Start the Threaded-Installer script to download the files
Write-Host "Starting Threaded-InstallerV2 script..." -ForegroundColor Cyan
$loops = 0
$NotInstalled = $true
While ($NotInstalled) {
    if ($loops -lt 3) {
        # Launch the Threaded-Installer script with the required parameters
        $Coms = [hashtable]::Synchronized(@{})
        & "$env:TEMP\Threaded-InstallerV2.ps1" -Coms $Coms -Url "https://fpca-app.frysix.com" -OutputFile "$InstallPath\FPCA.zip" -ChunkNumber 1 -ConnectionLimit 10
        # Check if the Threaded-Installer script was successful
        if (test-path -path "$InstallPath\FPCA.zip") {
            Write-Host "Installation completed successfully. Extracting..." -ForegroundColor Green
            # Extract the downloaded zip file
            Expand-Archive -Path "$InstallPath\FPCA.zip" -DestinationPath $InstallPath -Force
            if (test-path -path "$InstallPath\FPCA\fpca.info") {
                Write-Host "Extraction completed successfully. Cleaning Up" -ForegroundColor Green
                # Remove the zip file after extraction
                Remove-Item -Path "$InstallPath\FPCA.zip" -Force
                if (-not (test-path -path "$InstallPath\FPCA.zip")) {
                    Write-Host "Cleanup completed successfully." -ForegroundColor Green
                } else {
                    Write-Host "Cleanup failed." -ForegroundColor Red
                }
                $NotInstalled = $false
            } else {
                Write-Host "Extraction failed. fpca.info file not found in the installation directory." -ForegroundColor Red
                $result = [System.Windows.Forms.MessageBox]::Show("Extraction failed. fpca.info file not found. Do you want to retry?","FPCA Installer",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information)
                if (-not ($result -eq [System.Windows.Forms.DialogResult]::Yes)) {
                    Exit
                }
            }
        } else {
            Write-Host "Installation failed. WebInstaller script did not complete successfully." -ForegroundColor Red
            $result = [System.Windows.Forms.MessageBox]::Show("Installation failed. Do you want to retry?","FPCA Installer",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Information)
            if (-not ($result -eq [System.Windows.Forms.DialogResult]::Yes)) {
                Exit
            }
        }
        # Increment the loop counter
        $loops++
    } else {
        Write-Host "Too many attempts to install. Exiting installation." -ForegroundColor Red
        $result = [System.Windows.Forms.MessageBox]::Show("Too many failed attempts to install. Exitting...","FPCA Installer",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        Exit
    }
}

# Read the fpca.info file from the installed directory to prevent issues with version mismatches
# and to get the start file path and version information.
Write-Host "Reading fpca.info file from the installed directory..." -ForegroundColor Cyan
$newrawinfo = Get-Content -Path "$InstallPath\FPCA\fpca.info"
$newinfo = $newrawinfo | ConvertFrom-StringData

# Writes the installation log for the files used in the installation
# This segment creates a log file in the TEMP directory with the paths of the files used during the installation.
# This later helps Start-Check.ps1 delete the temporary files after the installation is complete.
$LogContent = @(
    "$env:TEMP\Threaded-InstallerV2.ps1",
    "$env:TEMP\InternetHelper.psm1",
    "$env:TEMP\Installer.ps1",
    "$env:TEMP\FPCAinstaller.bat"
)
# Create a log of the files used in the installation
$LogFilePath = "$env:TEMP\Install.log"
if (Test-Path -Path $LogFilePath) {
    Remove-Item -Path $LogFilePath -Force -ErrorAction SilentlyContinue
}
# Add the installation details to the log content
New-Item -Path $LogFilePath -ItemType File -Force | Out-Null
Set-Content -Path $LogFilePath -Value $LogContent -Encoding UTF8

# Start the installed script
Write-Host "Starting installed App Version: $($newinfo['version'])" -ForegroundColor Cyan
$LaunchFailed = $false
Try {
    Start-Process -WindowStyle Hidden -FilePath "$InstallPath\FPCA\Start.bat" -WorkingDirectory "$InstallPath\FPCA" -Verb Runas
} Catch {
    Write-Host "Failed to start the FPCA App. Error: $($_.Exception.Message)" -ForegroundColor Red
    $LaunchFailed = $true
}

if ($LaunchFailed) {
    Try {
        Start-Process explorer.exe -ArgumentList "$InstallPath\FPCA\" -Verb Runas
    } Catch {
        Write-Host "Failed to open the FPCA directory. Error: $($_.Exception.Message)" -ForegroundColor Red
    } Finally {
        Exit
    }
}

# Exit the installer script
Write-Host "FPCA App launched successfully. Closing installer script in 2 seconds..." -ForegroundColor Green
Start-Sleep -Seconds 2
Exit