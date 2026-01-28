# Script to install Amd Adrenalin using File-Installer.ps1
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
    $amdInstalled = $false
    $Coms.Comment = "Starting AMD Adrenalin installation..."

    $arpRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    $RegistryResults = Get-ChildItem $arpRoots -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object { $_.DisplayName -like 'AMD Software*' -or $_.DisplayName -like 'AMD Adrenalin*' } | Select-Object DisplayName, DisplayVersion, InstallLocation, UninstallString
    if ($RegistryResults.Count -gt 0) {
        $amdInstalled = $true
    }

    if ($amdInstalled -eq $false) {
        $lnks = @(
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\AMD Software\AMD Adrenalin.lnk",
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\AMD Adrenalin.lnk"
        )
        $StartMenuResults = $lnks | Where-Object { Test-Path $_ }
        if ($StartMenuResults.Count -gt 0) {
            $amdInstalled = $true
        }
    }

    if ($amdInstalled -eq $false) {
        $paths = @(
            "$Env:ProgramFiles\AMD\CNext\CNext.exe",
            "$Env:ProgramFiles(x86)\AMD\CNext\CNext.exe"
        )
        $FileResults = $paths | Where-Object { Test-Path $_ } | ForEach-Object { Get-Item $_ | Select-Object FullName,@{n='FileVersion';e={$_.VersionInfo.FileVersion}} }
        if ($FileResults.Count -gt 0) {
            $amdInstalled = $true
        }
    }

    if ($amdInstalled) {
        $Coms.Comment = "AMD Adrenalin is already installed."
        $Coms.Status = "Completed"
        Write-Host "AMD Adrenalin is already installed. Skipping installation."
        Exit
    }

    # Verify that the File-Installer script exists
    $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
    if (-not (Test-Path -Path $fileInstallerPath)) {
        Throw "File-Installer.ps1 script not found in $ScriptRoot\Scripts\Install-Scripts"
    }
    # Call the File-Installer script to install AMD Adrenalin
    . $fileInstallerPath -ScriptRoot $ScriptRoot -RefName "AMDADRENALIN" -ComsChannel $Coms -TimeoutSeconds 300
    # Check the result of the installation
    if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
        $Coms.Comment = "AMD Adrenalin installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "AMD Adrenalin installation failed: $($ComsChannel.EndMessage)"
    }

    # Define max tries and delay between tries
    $maxTries = 3
    $currentTry = 0
    $ErrorCodeLog = @()
    $LogPath = "$Env:Temp\Adrenalin_log.txt"
    $failPatterns = 'error','failed','return code','status:\s*fail','Install failed'
    $Installed = $false
    While ($Installed -eq $false -and $maxTries -gt 0) {
        # Start the installation process
        $currentTry += 1
        $Coms.InstallProgress = 0
        $installProcess = Start-Process -FilePath $ComsChannel.EndFilePath -ArgumentList "-install -log ${LogPath}" -PassThru -Verb RunAs
        While ($true) {
            Start-Sleep -Seconds 2
            if ($installProcess.HasExited) {
                if ($installProcess.ExitCode -eq 0) {
                    if (Test-Path -Path $LogPath) {
                        $matches = Select-String -Path $LogPath -Pattern $failPatterns -SimpleMatch
                        if ($matches) {
                            Write-Host "AMD Adrenalin installation failed with exit code: $($installProcess.ExitCode). Retrying..."
                            $ErrorCodeLog += "Try ${currentTry} failed with Exit code: $($installProcess.ExitCode)`n`r"
                            $maxTries -= 1
                        } else {
                            $Coms.InstallProgress = 100
                            $Installed = $true
                        }
                    } else {
                        Write-Host "AMD Adrenalin installation failed Could not find log file. Retrying..."
                        $ErrorCodeLog += "Try ${currentTry} failed Could not find log file`n`r"
                        $maxTries -= 1
                    }
                } elseif ($installProcess.ExitCode -eq 1618) {
                    Write-Host "Another installation is already in progress. Retrying..."
                    $ErrorCodeLog += "Try ${currentTry} failed with Exit code: $($installProcess.ExitCode)`n`r"
                    Start-Sleep -Seconds 5
                    # ** Do not decrement maxTries for this case **
                } else {
                    Write-Host "AMD Adrenalin installation failed with exit code: $($installProcess.ExitCode). Retrying..."
                    $ErrorCodeLog += "Try ${currentTry} failed with Exit code: $($installProcess.ExitCode)`n`r"
                    $maxTries -= 1
                }
                Break
            }
        }
    }
    if ($Installed) {
        $Coms.Comment = "AMD Adrenalin installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "AMD Adrenalin installation failed after multiple attempts.`n`r$($ErrorCodeLog -join '')"
    }
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Status = "Error"
}