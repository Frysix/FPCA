# Install HP Support Assistant using File-Installer.ps1 script
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
# Since this is an installation script, set InstallMode to true in the communication channel
$Coms.InstallMode = $true
$hpSupportAssistantInstalled = $false
$Coms.Status = "Starting"
$Coms.Comment = "Starting HP Support Assistant installation..."

Try {
    # Multiple methods to check if HP Support Assistant is already installed
    $arpRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    $RegistryResults = Get-ChildItem $arpRoots -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object { $_.DisplayName -like 'HP Support Assistant*' } | Select-Object DisplayName, DisplayVersion, InstallLocation, UninstallString
    if ($RegistryResults.Count -gt 0) {
        $hpSupportAssistantInstalled = $true
    }

    if ($hpSupportAssistantInstalled -eq $false) {
        $lnks = @(
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\HP Support Assistant\HP Support Assistant.lnk",
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\HP Support Assistant.lnk"
        )
        $StartMenuResults = $lnks | Where-Object { Test-Path $_ }
        if ($StartMenuResults.Count -gt 0) {
            $hpSupportAssistantInstalled = $true
        }
    }

    if ($hpSupportAssistantInstalled -eq $false) {
        $paths = @(
            "$Env:ProgramFiles\Hewlett-Packard\HP Support Framework\HPSA.exe",
            "$Env:ProgramFiles(x86)\Hewlett-Packard\HP Support Framework\HPSA.exe"
        )
        $FileResults = $paths | Where-Object { Test-Path $_ } | ForEach-Object { Get-Item $_ | Select-Object FullName,@{n='FileVersion';e={$_.VersionInfo.FileVersion}} }
        if ($FileResults.Count -gt 0) {
            $hpSupportAssistantInstalled = $true
        }
    }

    if ($hpSupportAssistantInstalled -eq $false) {
        $processResults = Get-Process -ErrorAction SilentlyContinue | Where-Object {
            $_.ProcessName -like 'HPSA*' -or ($_.Path -and $_.Path -like '*\Hewlett-Packard\HP Support Framework\*')
        } | Select-Object ProcessName, Path, FileVersion
        if ($processResults.Count -gt 0) {
            $hpSupportAssistantInstalled = $true
        }
    }
    # If HP Support Assistant is already installed, update status and exit
    if ($hpSupportAssistantInstalled -eq $true) {
        $Coms.Status = "Completed"
        $Coms.Comment = "HP Support Assistant is already installed. No action needed."
        Exit
    }
    # Verify that File-Installer.ps1 exists
    $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
    if (-not (Test-Path -Path $fileInstallerPath)) {
        Throw "File-Installer.ps1 not found, cannot install HPSupportAssistant."
    }
    # Install HPSupportAssistant using File-Installer script
    . $fileInstallerPath -ScriptRoot $ScriptRoot -RefName "HPSUPPORTASSISTANT" -ComsChannel $Coms -TimeoutSeconds 300
    # Check the result of the installation
    if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
        $Coms.Comment = "HPSupportAssistant download completed successfully."
        $Coms.Status = "Installing"
    } else {
        Throw "HPSupportAssistant download failed: $($ComsChannel.EndMessage)"
    }
    # Proceed to install HPSupportAssistant
    $maxTries = 3
    $extracted = $false
    # Create a temp directory for the extraction
    $tempDir = Join-Path -Path $Env:TEMP -ChildPath "HPSA_Install"
    $installerPath = Join-Path -Path $tempDir -ChildPath "InstallHPSA.exe"
    if (Test-Path -Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -Path $tempDir -ItemType Directory | Out-Null
    While ($extracted -eq $false -and $maxTries -gt 0) {
        # Start the Extraction process
        $Coms.InstallProgress = 0
        $installProcess = Start-Process -FilePath $ComsChannel.EndFilePath -ArgumentList "/s /e /f `"$tempDir`"" -PassThru -Verb RunAs
        While ($true) {
            # Check if installation was successful
            if ($Coms.InstallProgress -lt 45) {
                $Coms.InstallProgress += 1
            }
            $installProcess.Refresh()
            if ($installProcess.HasExited) {
                if (Test-Path -Path $installerPath) {
                    $Coms.InstallProgress = 50
                    $extracted = $true
                } else {
                    Write-Host "HPSupportAssistant extraction did not produce expected installer. Retrying..."
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
    # Extraction check after exiting loop
    if ($extracted -eq $false) {
        Throw "HPSupportAssistant extraction failed after multiple attempts."
    }
    # Proceed to run the extracted installer
    $maxTries = 3
    $Installed = $false
    # Second loop to run the extracted installer
    While ($Installed -eq $false -and $maxTries -gt 0) {
        # Start the installation process
        $Coms.InstallProgress = 50
        $installProcess = Start-Process -FilePath $installerPath -ArgumentList "/s" -WorkingDirectory $tempDir -PassThru -Verb RunAs
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
                    Write-Host "HPSupportAssistant installation failed with exit code: $($installProcess.ExitCode). Retrying..."
                    $maxTries -= 1
                }
                Break
            }
            # Sleep for a short period before checking again
            Start-Sleep -Milliseconds 500
        }
    }
    # Clean up the temp directory
    if (Test-Path -Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    # Final check after exiting loop
    if ($Installed) {
        $Coms.Comment = "HPSupportAssistant installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "HPSupportAssistant installation failed after multiple attempts."
    }
} Catch {
    # Ensure temp directory is cleaned up
    if (Test-Path -Path "$Env:TEMP\HPSA_Install") {
        Remove-Item -Path "$Env:TEMP\HPSA_Install" -Recurse -Force -ErrorAction SilentlyContinue
    }
    # Set error message and status
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Status = "Error"
}