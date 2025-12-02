# Installation Script for Nvidia App using File-Installer.ps1
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
    $nvidiaInstalled = $false
    $Coms.Comment = "Starting Nvidia App installation..."

    $arpRoots = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    $RegistryResults = Get-ChildItem $arpRoots -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object { $_.DisplayName -like 'NVIDIA App*' -or $_.DisplayName -like 'NVIDIA App Beta*' } | Select-Object DisplayName, DisplayVersion, InstallLocation, UninstallString
    if ($RegistryResults.Count -gt 0) {
        $nvidiaInstalled = $true
    }

    if ($nvidiaInstalled -eq $false) {
        $lnks = @(
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\NVIDIA Corporation\NVIDIA App.lnk",
            "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\NVIDIA App.lnk"
        )
        $StartMenuResults = $lnks | Where-Object { Test-Path $_ }
        if ($StartMenuResults.Count -gt 0) {
            $nvidiaInstalled = $true
        }
    }

    if ($nvidiaInstalled -eq $false) {
        $paths = @(
            "$Env:ProgramFiles\NVIDIA Corporation\NVIDIA App\NVIDIA App.exe",
            "$Env:ProgramFiles\NVIDIA Corporation\NVIDIA App\NVIDIAApp.exe",
            "$Env:ProgramFiles(x86)\NVIDIA Corporation\NVIDIA App\NVIDIA App.exe"
        )
        $FileResults = $paths | Where-Object { Test-Path $_ } | ForEach-Object { Get-Item $_ | Select-Object FullName,@{n='FileVersion';e={$_.VersionInfo.FileVersion}} }
        if ($FileResults.Count -gt 0) {
            $nvidiaInstalled = $true
        }
    }

    if ($nvidiaInstalled -eq $false) {
        $processResults = Get-Process -ErrorAction SilentlyContinue | Where-Object {
            $_.ProcessName -like 'NVIDIA*App*' -or ($_.Path -and $_.Path -like '*\NVIDIA Corporation\NVIDIA App\*')
        } | Select-Object ProcessName, Path, FileVersion
        if ($processResults.Count -gt 0) {
            $nvidiaInstalled = $true
        }
    }

    if ($nvidiaInstalled) {
        $Coms.Comment = "Nvidia App is already installed. Skipping installation."
        $Coms.Status = "Completed"
        Write-Host "Nvidia App is already installed. Skipping installation."
        Exit
    }

    # Figure out latest install link for Nvidia app
    # Import Internet Helper module to use Get-WebPageWithLinks
    if (-not (Test-Path -Path "$ScriptRoot\Helper\InternetHelper.psm1")) {
        Throw "InternetHelper module not found in $ScriptRoot\Helper"
    }
    Import-Module "$ScriptRoot\Helper\InternetHelper.psm1" -Force
    # Get the webpage with download links
    $page = Get-WebPageWithLinks -Url "https://www.nvidia.com/fr-fr/software/nvidia-app/"
    # Parse links to find the installer
    foreach ($link in $page.Links.href) {
        if ($link -match "https://fr\.download\.nvidia\.com/nvapp/client/[^/]+/NVIDIA_app_v[\d\.]+\.exe") {
            $NvidiaAppUrl = $matches[0]
            Write-Host "Url Found: $NvidiaAppUrl"
            Break
        }
    }
    # Ensure file installer script exists
    $fileInstallerPath = "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1"
    if (-not (Test-Path -Path $fileInstallerPath)) {
        Throw "File-Installer.ps1 not found, cannot install Nvidia App."
    }
    # Install Nvidia App using File-Installer script
    if (-not $NvidiaAppUrl) {
        Write-Host "Trying to use default download Ref for Nvidia App"
        . $fileInstallerPath -ScriptRoot $ScriptRoot -RefName "NVIDIA-APP" -ComsChannel $Coms -TimeoutSeconds 300
    } else {
        Write-Host "Using dynamically found download URL for Nvidia App"
        . $fileInstallerPath -ScriptRoot $ScriptRoot -CustomUrl $NvidiaAppUrl -RefName "NVIDIA-APP" -ComsChannel $Coms -TimeoutSeconds 300
    }
    # Check the result of the installation
    if ($ComsChannel.ContainsKey("ConfigReturn") -and $ComsChannel.ConfigReturn -eq 'Completed') {
        $Coms.Comment = "Nvidia App download completed successfully."
        $Coms.Status = "Installing"
    } else {
        Throw "Nvidia App download failed: $($ComsChannel.EndMessage)"
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
        $installProcess = Start-Process -FilePath $ComsChannel.EndFilePath -ArgumentList "-s -noreboot -noeula -nofinish -nosplash" -PassThru -Verb RunAs
        While ($true) {
            # Check if installation was successful
            if ($Coms.InstallProgress -lt 95) {
                $Coms.InstallProgress += 1
            }
            if ($installProcess.HasExited) {
                if ($installProcess.ExitCode -eq 0) {
                    $Coms.InstallProgress = 100
                    $Installed = $true
                } else {
                    Write-Host "Nvidia App installation failed with exit code: $($installProcess.ExitCode). Retrying..."
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
        $Coms.Comment = "Nvidia App installation completed successfully."
        $Coms.Status = "Completed"
    } else {
        Throw "Nvidia App installation failed after multiple attempts.`n`r$($ErrorCodeLog -join '')"
    }
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Status = "Error"
}