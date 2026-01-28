# Installation script for Asus Driver Hub using File-Installer.ps1
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
    $asusdriverhubInstalled = $false
    $Coms.Comment = "Starting Asus Driver Hub installation..."

    # Multiple methods to check if Asus Driver Hub is already installed
    $arpRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    $RegistryResults = Get-ChildItem $arpRoots -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object { $_.DisplayName -like 'Asus Driver Hub*' } | Select-Object DisplayName, DisplayVersion, InstallLocation, UninstallString
    if ($RegistryResults.Count -gt 0) {
        $asusdriverhubInstalled = $true
    }

    if ($asusdriverhubInstalled -eq $false) {
        $lnks = @(
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\ASUS\ASUS Driver Hub.lnk",
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\ASUS Driver Hub.lnk"
        )
        $StartMenuResults = $lnks | Where-Object { Test-Path $_ }
        if ($StartMenuResults.Count -gt 0) {
            $asusdriverhubInstalled = $true
        }
    }

    if ($asusdriverhubInstalled -eq $false) {
        $paths = @(
            "$Env:ProgramFiles\ASUS\ASUS Driver Hub\AsusDriverHub.exe",
            "$Env:ProgramFiles(x86)\ASUS\ASUS Driver Hub\AsusDriverHub.exe"
        )
        $FileResults = $paths | Where-Object { Test-Path $_ } | ForEach-Object { Get-Item $_ | Select-Object FullName,@{n='FileVersion';e={$_.VersionInfo.FileVersion}} }
        if ($FileResults.Count -gt 0) {
            $asusdriverhubInstalled = $true
        }
    }

    if ($asusdriverhubInstalled -eq $false) {
        $processResults = Get-Process -ErrorAction SilentlyContinue | Where-Object {
            $_.ProcessName -like 'AsusDriverHub*' -or ($_.Path -and $_.Path -like '*\ASUS\ASUS Driver Hub\*')
        } | Select-Object ProcessName, Path, FileVersion
        if ($processResults.Count -gt 0) {
            $asusdriverhubInstalled = $true
        }
    }

    if ($asusdriverhubInstalled) {
        $Coms.Comment = "Asus Driver Hub is already installed."
        $Coms.Status = "Completed"
        Write-Host "Asus Driver Hub is already installed. Skipping installation."
        Exit
    }

    # Verify that File-Installer.ps1 exists
    $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
    if (-not (Test-Path -Path $fileInstallerPath)) {
        Throw "File-Installer.ps1 not found, cannot install Asus Driver Hub."
    }
    # Install Asus Driver Hub using File-Installer.ps1
    . "$fileInstallerPath" -ScriptRoot $ScriptRoot -RefName "ASUSDRIVERHUB" -ComsChannel $Coms -TimeoutSeconds 300
    # Check the result of the installation
    if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
        $Coms.Comment = "Asus Driver Hub download completed successfully."
        $Coms.Status = "Installing"
    } else {
        Throw "Asus Driver Hub download failed: $($ComsChannel.EndMessage)"
    }
    # Define max tries and delay between tries
    $maxTries = 3
    $currentTry = 0
    $ErrorCodeLog = @()
    $Installed = $false
    While ($Installed -eq $false -and $maxTries -gt 0) {
        # Start the installation process
        $currentTry += 1
        $Coms.InstallProgress = 0
        $installProcess = Start-Process -FilePath $ComsChannel.EndFilePath -ArgumentList "/s" -PassThru -Verb RunAs
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
        $Coms.Comment = "Asus Driver Hub installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "Asus Driver Hub installation failed after multiple attempts.`n`r$($ErrorCodeLog -join '')"
    }
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Status = "Error"
}