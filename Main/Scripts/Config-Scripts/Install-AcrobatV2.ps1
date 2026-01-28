# Revamp of Acrobat installation script to support new File-Installer method
# This script is part of the FPCA project and is used to install Adobe Acrobat 
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
# First enter try catch block to catch all errors
Try {
    # Since this is an installation script, set InstallMode to true in the communication channel. 
    # Set the mode to waiting to indicate to the config script that the installation is waiting for approval.
    $Coms.InstallMode = $true
    $Coms.Status = "Waiting"
    While ($true) {
        Start-Sleep -Milliseconds 500
        if ($Coms.Status -eq "Starting") {
            Break
        } elseif ($Coms.Status -ne "Waiting" -and $Coms.Status -ne "Starting") {
            Throw "Installation of ${TaskName} was cancelled or encountered an error before starting."
        }
    }
    $acrobatInstalled = $false
    $Coms.Comment = "Starting Acrobat installation..."

    # Check if Acrobat Reader is already installed multiple ways
    $acrobatPaths = @(
        "$env:ProgramFiles\Adobe\Acrobat DC\Acrobat\Acrobat.exe",
        "$env:ProgramFiles(x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe",
        "$env:ProgramFiles\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe",
        "$env:ProgramFiles(x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe"
    )
    
    foreach ($path in $acrobatPaths) {
        if (Test-Path -Path $path) {
            $acrobatInstalled = $true
            Write-Host "Found Adobe Acrobat/Reader at: $path"
            break
        }
    }

    # Try to find Adobe Acrobat/Reader via registry if not found in standard paths
    if ($acrobatInstalled -eq $false) {
        $registryPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*Adobe*Reader*",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*Adobe*Reader*",
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*Adobe*Reader*",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*Adobe*Acrobat*",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*Adobe*Acrobat*"
        )
        
        foreach ($regPath in $registryPaths) {
            try {
                $apps = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
                if ($apps) {
                    foreach ($app in $apps) {
                        if ($app.DisplayName -like "*Adobe*Reader*" -or $app.DisplayName -like "*Adobe*Acrobat*") {
                            Write-Host "Found Adobe product in registry: $($app.DisplayName)"
                            $acrobatInstalled = $true
                            break
                        }
                    }
                }
                if ($acrobatInstalled) { break }
            } catch {
                # Ignore errors, just means Adobe isn't installed in this registry path
            }
        }
    }

    # Try to find Adobe via WMI if not found in standard paths or registry
    if ($acrobatInstalled -eq $false) {
        $wmiQuery = "SELECT * FROM Win32_Product WHERE Name LIKE '%Adobe%Reader%' OR Name LIKE '%Adobe%Acrobat%'"
        $acrobatProduct = Get-WmiObject -Query $wmiQuery -ErrorAction SilentlyContinue
        if ($acrobatProduct) {
            Write-Host "Found Adobe product via WMI: $($acrobatProduct.Name)"
            $acrobatInstalled = $true
        }
    }

    # If Acrobat is installed, skip installation
    if ($acrobatInstalled) {
        $Coms.Comment = "Acrobat is already installed. Skipping installation."
        $Coms.Status = "Completed"
        Write-Host "Acrobat is already installed. Skipping installation." -ForegroundColor Yellow
        Exit
    }
    
    # Verify that the File-Installer script exists
    $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
    if (-not (Test-Path -Path $fileInstallerPath)) {
        Throw "File-Installer.ps1 script not found in $ScriptRoot\Scripts\Install-Scripts"
    }
    # Call the File-Installer script to install Acrobat Reader
    . $fileInstallerPath -ScriptRoot $ScriptRoot -RefName "ACROBAT" -RefVersion "latest" -ComsChannel $Coms -TimeoutSeconds 300
    # Check the result of the installation
    if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
        $Coms.Comment = "Acrobat download completed successfully."
        $Coms.Status = "Installing"
    } else {
        Throw "Acrobat download failed: $($ComsChannel.EndMessage)"
    }
    # define install arguments
    $installArgs = @(
        "/sAll",           # Silent install all
        "/rs",             # Suppress restart
        "/msi",            # Use MSI mode
        "/norestart",      # No restart
        "/quiet",          # Quiet mode
        "EULA_ACCEPT=YES", # Accept EULA
        "SUPPRESS_APP_LAUNCH=YES" # Don't launch after install
    )
    # Define max tries and delay between tries
    $maxTries = 3
    $currentTry = 0
    $ErrorCodeLog = @()
    $Installed = $false
    While ($Installed -eq $false -and $maxTries -gt 0) {
        # Start the installation process
        $currentTry += 1
        $Coms.InstallProgress = 0
        $installProcess = Start-Process -FilePath $ComsChannel.EndFilePath -ArgumentList $installArgs -PassThru -Verb RunAs
        While ($true) {
            # Check if installation was successful
            if ($Coms.InstallProgress -lt 95) {
                $Coms.InstallProgress += 1
            }
            $installProcess.Refresh()
            if ($installProcess.HasExited) {
                if ($installProcess.ExitCode -eq 0) {
                    $Coms.InstallProgress = 100
                    $Installed = $true
                } elseif ($installProcess.ExitCode -eq 1618) {
                    Write-Host "Another installation is already in progress. Retrying..."
                    $ErrorCodeLog += "Try ${currentTry} failed with Exit code: $($installProcess.ExitCode)`n`r"
                    Start-Sleep -Seconds 5
                    # ** Do not decrement maxTries for this case **
                } else {
                    Write-Host "Acrobat installation failed with exit code: $($installProcess.ExitCode). Retrying..."
                    $ErrorCodeLog += "Try ${currentTry} failed with Exit code: $($installProcess.ExitCode)`n`r"
                    $maxTries -= 1
                }
                Break
            }
            # Sleep for a short period before checking again
            Start-Sleep -Milliseconds 500
        }
    }
    # Clean up the installer file
    if (Test-Path -Path $ComsChannel.EndFilePath) {
        Remove-Item -Path $ComsChannel.EndFilePath -Force -ErrorAction SilentlyContinue
    }
    # Final check after exiting loop
    if ($Installed) {
        if ($TaskSettings.ContainsKey('RemindDefault') -and $TaskSettings.RemindDefault -eq $true) {
            $Coms.RemindDefault = $true
        }
        $Coms.Comment = "Acrobat installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "Acrobat installation failed after multiple attempts.`n`r$($ErrorCodeLog -join '')"
    }
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Status = "Error"
}