# Revamp of Chrome installation script to support new File-Installer method
# This script is part of the FPCA project and is used to install Google Chrome
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
    $chromeInstalled = $false
    $Coms.Comment = "Starting Chrome installation..."

    $chromePaths = @(
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe",
        "$env:LocalAppData\Google\Chrome\Application\chrome.exe"
    )
    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            $chromeInstalled = $true
            break
        }
    }

    # Try to find Chrome via registry if not found in standard paths
    if ($chromeInstalled -eq $false) {
        $registryPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome",
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome"
        )
        foreach ($regPath in $registryPaths) {
            try {
                $installLocation = (Get-ItemProperty -Path $regPath -ErrorAction Stop).InstallLocation
                if ($installLocation) {
                    $chromeInstalled = $true
                    break
                }
            } catch {
                # Ignore errors, just means Chrome isn't installed in this registry path
            }
        }
    }

    # Try to find Chrome via WMI if not found in standard paths or registry
    if ($chromeInstalled -eq $false) {
        $wmiQuery = "SELECT * FROM Win32_Product WHERE Name LIKE 'Google Chrome%'"
        $chromeProduct = Get-WmiObject -Query $wmiQuery -ErrorAction SilentlyContinue
        if ($chromeProduct) {
            $chromeInstalled = $true
        }
    }

    # If Chrome is already installed, update status and exit
    if ($chromeInstalled) {
        $Coms.Comment = "Google Chrome is already installed."
        $Coms.Status = "Completed"
        Write-Host "Google Chrome is already installed." -ForegroundColor Green
        Exit
    }

    # Verify that File-Installer.ps1 exists
    $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
    if (-not (Test-Path -Path $fileInstallerPath)) {
        Throw "File-Installer.ps1 not found, cannot install Google Chrome."
    }
    # Install Chrome using File-Installer script
    . $fileInstallerPath -ScriptRoot $ScriptRoot -RefName "CHROME" -ComsChannel $Coms -TimeoutSeconds 300
    # Check the result of the installation
    if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
        $Coms.Comment = "Chrome download completed successfully."
        $Coms.Status = "Installing"
    } else {
        Throw "Chrome download failed: $($ComsChannel.EndMessage)"
    }
    # Define max tries and delay between tries
    $maxTries = 3
    $Installed = $false
    While ($Installed -eq $false -and $maxTries -gt 0) {
        # Start the installation process
        $Coms.InstallProgress = 0
        $installProcess = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$($ComsChannel.EndFilePath)`" /qn /norestart" -PassThru -Verb RunAs
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
                } else {
                    Write-Host "Acrobat installation failed with exit code: $($installProcess.ExitCode). Retrying..."
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
        $Coms.Comment = "Google Chrome installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "Google Chrome installation failed after multiple attempts."
    }
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Status = "Error"
}