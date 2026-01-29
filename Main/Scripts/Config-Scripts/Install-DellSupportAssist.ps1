# Installs Dell SupportAssist application using the File-Installer.ps1 script
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
    $dellsupportAssistInstalled = $false
    $Coms.Comment = "Starting Dell SupportAssist installation..."

    # Check if Dell SupportAssist is already installed via registry
    $arpRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    $RegistryResults = Get-ChildItem $arpRoots -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object { $_.DisplayName -like 'Dell SupportAssist*' } | Select-Object DisplayName, DisplayVersion, InstallLocation, UninstallString
    if ($RegistryResults.Count -gt 0) {
        $dellsupportAssistInstalled = $true
    }

    if ($dellsupportAssistInstalled -eq $false) {
        $lnks = @(
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Dell SupportAssist\Dell SupportAssist.lnk",
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\Dell SupportAssist.lnk"
        )
        $StartMenuResults = $lnks | Where-Object { Test-Path $_ }
        if ($StartMenuResults.Count -gt 0) {
            $dellsupportAssistInstalled = $true
        }
    }

    if ($dellsupportAssistInstalled -eq $false) {
        $paths = @(
            "$Env:ProgramFiles\Dell\SupportAssist\SupportAssist.exe",
            "$Env:ProgramFiles(x86)\Dell\SupportAssist\SupportAssist.exe"
        )
        $FileResults = $paths | Where-Object { Test-Path $_ } | ForEach-Object { Get-Item $_ | Select-Object FullName,@{n='FileVersion';e={$_.VersionInfo.FileVersion}} }
        if ($FileResults.Count -gt 0) {
            $dellsupportAssistInstalled = $true
        }
    }

    if ($dellsupportAssistInstalled -eq $false) {
        $processResults = Get-Process -ErrorAction SilentlyContinue | Where-Object {
            $_.ProcessName -like 'SupportAssist*' -or ($_.Path -and $_.Path -like '*\Dell\SupportAssist\*')
        } | Select-Object ProcessName, Path, FileVersion
        if ($processResults.Count -gt 0) {
            $dellsupportAssistInstalled = $true
        }
    }

    # If Dell SupportAssist is already installed, update status and exit
    if ($dellsupportAssistInstalled) {
        $Coms.Comment = "Dell SupportAssist is already installed. Skipping installation."
        $Coms.Status = "Completed"
        Exit
    }
    # Verify that File-Installer.ps1 exists
    $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
    if (-not (Test-Path -Path $fileInstallerPath)) {
        Throw "File-Installer.ps1 not found, cannot install Dell SupportAssist."
    }
    # Install Dell SupportAssist using File-Installer script
    . $fileInstallerPath -ScriptRoot $ScriptRoot -RefName "DELLSUPPORTASSIST" -ComsChannel $Coms -TimeoutSeconds 300
    # Check the result of the installation
    if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
        $Coms.Comment = "Dell SupportAssist download completed successfully."
        $Coms.Status = "Installing"
    } else {
        Throw "Dell SupportAssist download failed: $($ComsChannel.EndMessage)"
    }
    # Proceed to install Dell SupportAssist
    $maxTries = 3
    $currentTry = 0
    $ErrorCodeLog = @()
    $Installed = $false
    While ($Installed -eq $false -and $maxTries -gt 0) {
        # Start the installation process
        $currentTry += 1
        $Coms.InstallProgress = 0
        $installProcess = Start-Process -FilePath $ComsChannel.EndFilePath -ArgumentList "/silent" -PassThru -Verb RunAs
        While ($true) {
            # Check if installation was successful
            if ($Coms.InstallProgress -lt 95) {
                $Coms.InstallProgress += 1
            }
            Try{
                $installProcess.Refresh()
            } Catch {
                # Process may have exited, ignore errors
            }
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
                    Write-Host "Dell SupportAssist installation failed with exit code: $($installProcess.ExitCode). Retrying..."
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
        $Coms.Comment = "Dell SupportAssist installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "Dell SupportAssist installation failed after multiple attempts.`n`r$($ErrorCodeLog -join '')"
    }
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Status = "Error"
}