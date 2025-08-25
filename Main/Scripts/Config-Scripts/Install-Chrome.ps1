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

$chromeInstalled = $false
$firstTryFailed = $false
$InstallSuccess = $false
$msiInstallerPath = $null
$exeInstallerPath = $null
$Coms.Status = "Running"
$Coms.Comment = "Starting Chrome Installation Script"
$Coms.Progress = 1
Try {

    $Coms.Comment = "Checking if Chrome is already installed"
    # Check if chrome is already installed multiple ways
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

    if ($chromeInstalled) {
        $Coms.Comment = "Google Chrome is already installed. No action needed."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    } else {
        $Coms.Comment = "Google Chrome not found. Proceeding with installation."
        $Coms.Progress = 5
        # Download and install Chrome from the latest sources
        $chromeMsiUrl = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        $chromeExeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
        $msiInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\googlechromestandaloneenterprise64.msi"
        $exeInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\chrome_installer.exe"
        $InstallerComs = [hashtable]::Synchronized(@{})
        $Coms.Comment = "Trying to download Chrome installer from Google's MSI source"
        $Coms.Progress = 10
        
        Write-Host "Starting Chrome MSI download from: $chromeMsiUrl"
        Write-Host "Target path: $msiInstallerPath"
        
        # Call the threaded installer with error handling
        try {
            . "$ScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1" -Url $chromeMsiUrl -OutputFile $msiInstallerPath -Coms $InstallerComs -TaskName $TaskName -ChunkNumber 1
            
            # Wait for completion with timeout and better status checking
            $timeout = 60  # 1 minute timeout - more reasonable
            $elapsed = 0
            $checkInterval = 2  # Check every 2 seconds
            
            while ($elapsed -lt $timeout) {
                Start-Sleep -Seconds $checkInterval
                $elapsed += $checkInterval
                
                # Debug: Show what's in the communication hashtable
                Write-Host "InstallerComs Status: '$($InstallerComs.Status)'"
                Write-Host "InstallerComs Keys: $($InstallerComs.Keys -join ', ')"
                
                $Coms.Comment = "Downloading Chrome installer... ($elapsed/$timeout seconds)"
                
                # Check if the file exists (more reliable than waiting for status)
                if (Test-Path -Path $msiInstallerPath) {
                    $fileSize = (Get-Item $msiInstallerPath).Length
                    Write-Host "Downloaded file size: $([math]::Round($fileSize/1MB, 2)) MB"
                    
                    # If file is reasonable size (>1MB), consider download complete
                    if ($fileSize -gt 1MB) {
                        Write-Host "File download appears complete based on size"
                        $InstallerComs.Status = "Completed"  # Force completion status
                        break
                    }
                }
                
                # Also check if InstallerComs reports completion
                if ($InstallerComs.Status -eq "Completed" -or $InstallerComs.Status -eq "Failed") {
                    Write-Host "Download completed with status: $($InstallerComs.Status)"
                    break
                }
                
                # Update progress based on installer progress if available
                if ($InstallerComs.ContainsKey('Progress') -and $InstallerComs.Progress -gt 0) {
                    $downloadProgress = [Math]::Max(10, [Math]::Min(45, 10 + ($InstallerComs.Progress * 0.35)))
                    $Coms.Progress = $downloadProgress
                }
            }
            
            # Final check after timeout
            if ($elapsed -ge $timeout) {
                Write-Host "Timeout reached, checking file existence..."
                if (Test-Path -Path $msiInstallerPath) {
                    $fileSize = (Get-Item $msiInstallerPath).Length
                    if ($fileSize -gt 1MB) {
                        Write-Host "File exists and is valid size, treating as successful download"
                        $InstallerComs.Status = "Completed"
                    } else {
                        Write-Host "File too small ($fileSize bytes), download likely failed"
                        $firstTryFailed = $true
                    }
                } else {
                    Write-Host "No file found after timeout, download failed"
                    $firstTryFailed = $true
                }
            }
            
        } catch {
            Write-Host "Error during download: $($_.Exception.Message)"
            $Coms.Comment = "Download error - trying alternative method"
            $firstTryFailed = $true
        }
        
        # Final decision based on file existence rather than just status
        if (($InstallerComs.Status -eq "Completed" -or (Test-Path -Path $msiInstallerPath)) -and -not $firstTryFailed) {
            $Coms.Comment = "Download completed. Starting Chrome installation."
            $Coms.Progress = 50
            $installProcess = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiInstallerPath`" /qn /norestart" -Wait -PassThru -Verb RunAs
            if ($installProcess.ExitCode -eq 0) {
                $InstallSuccess = $true
                $Coms.Progress = 80
                $Coms.Comment = "Google Chrome installed successfully."
            } else {
                $Coms.Comment = "Chrome installation failed with exit code $($installProcess.ExitCode)."
                $firstTryFailed = $true
            }
        } else {
            $Coms.Comment = "Failed to download Chrome installer from primary MSI URL."
            $firstTryFailed = $true
        }
        # Try second option to download Chrome installer
        if ($firstTryFailed) {
            $Coms.Comment = "Failed to download Chrome installer, trying alternative EXE URL."
            $InstallerComs = [hashtable]::Synchronized(@{})  # Reset with synchronized hashtable
            $Coms.Progress = 10
            
            Write-Host "Starting Chrome EXE download from: $chromeExeUrl"
            Write-Host "Target path: $exeInstallerPath"
            
            try {
                . "$ScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1" -Url $chromeExeUrl -OutputFile $exeInstallerPath -Coms $InstallerComs -TaskName $TaskName -ChunkNumber 1
                
                # Wait for completion with file-based checking
                $timeout = 60  # 1 minute timeout
                $elapsed = 0
                $checkInterval = 2  # Check every 2 seconds
                
                while ($elapsed -lt $timeout) {
                    Start-Sleep -Seconds $checkInterval
                    $elapsed += $checkInterval
                    
                    Write-Host "EXE InstallerComs Status: '$($InstallerComs.Status)'"
                    $Coms.Comment = "Downloading Chrome EXE installer... ($elapsed/$timeout seconds)"
                    
                    # Check if the file exists (more reliable than waiting for status)
                    if (Test-Path -Path $exeInstallerPath) {
                        $fileSize = (Get-Item $exeInstallerPath).Length
                        Write-Host "Downloaded EXE file size: $([math]::Round($fileSize/1MB, 2)) MB"
                        
                        # If file is reasonable size (>500KB), consider download complete
                        if ($fileSize -gt 500KB) {
                            Write-Host "EXE file download appears complete based on size"
                            $InstallerComs.Status = "Completed"  # Force completion status
                            break
                        }
                    }
                    
                    # Also check if InstallerComs reports completion
                    if ($InstallerComs.Status -eq "Completed" -or $InstallerComs.Status -eq "Failed") {
                        Write-Host "EXE download completed with status: $($InstallerComs.Status)"
                        break
                    }
                    
                    # Update progress based on installer progress if available
                    if ($InstallerComs.ContainsKey('Progress') -and $InstallerComs.Progress -gt 0) {
                        $downloadProgress = [Math]::Max(10, [Math]::Min(45, 10 + ($InstallerComs.Progress * 0.35)))
                        $Coms.Progress = $downloadProgress
                    }
                }
                
                # Final check after timeout
                if ($elapsed -ge $timeout) {
                    Write-Host "EXE timeout reached, checking file existence..."
                    if (Test-Path -Path $exeInstallerPath) {
                        $fileSize = (Get-Item $exeInstallerPath).Length
                        if ($fileSize -gt 500KB) {
                            Write-Host "EXE file exists and is valid size, treating as successful download"
                            $InstallerComs.Status = "Completed"
                        } else {
                            Write-Host "EXE file too small ($fileSize bytes), download likely failed"
                            $Coms.Progress = 0
                            $Coms.Status = "Failed"
                        }
                    } else {
                        Write-Host "No EXE file found after timeout, download failed"
                        $Coms.Progress = 0
                        $Coms.Status = "Failed"
                    }
                }
                
            } catch {
                Write-Host "Error during EXE download: $($_.Exception.Message)"
                $Coms.Comment = "EXE download error"
                $Coms.Progress = 0
                $Coms.Status = "Failed"
            }
            
            # Final decision based on file existence rather than just status
            if (($InstallerComs.Status -eq "Completed" -or (Test-Path -Path $exeInstallerPath)) -and $Coms.Status -ne "Failed") {
                $Coms.Comment = "Download completed. Starting Chrome installation."
                $Coms.Progress = 50
                $installProcess = Start-Process -FilePath $exeInstallerPath -ArgumentList "/silent /install" -Wait -PassThru -Verb RunAs
                if ($installProcess.ExitCode -eq 0) {
                    $InstallSuccess = $true
                    $Coms.Progress = 80
                    $Coms.Comment = "Google Chrome installed successfully."
                } else {
                    $Coms.Comment = "Chrome installation failed with exit code $($installProcess.ExitCode)."
                    $Coms.Progress = 0
                    $Coms.Status = "Failed"
                }
            } else {
                $Coms.Comment = "Failed to download Chrome installer from alternative EXE URL."
                $Coms.Progress = 0
                $Coms.Status = "Failed"
            }
        }
    }
} Catch {
    $Coms.ErrorMessage = "An error occurred: $_"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
} Finally {
    if ($msiInstallerPath -and (Test-Path -Path $msiInstallerPath -ErrorAction SilentlyContinue)) {
        Remove-Item -Path $msiInstallerPath -Force -ErrorAction SilentlyContinue
    }
    if ($exeInstallerPath -and (Test-Path -Path $exeInstallerPath -ErrorAction SilentlyContinue)) {
        Remove-Item -Path $exeInstallerPath -Force -ErrorAction SilentlyContinue
    }
    if ($InstallSuccess) {
        $Coms.Comment = "Finalizing Chrome installation according to settings."
        if ($TaskSettings.ContainsKey('RemindDefault') -and $TaskSettings.RemindDefault -eq $true) {
            $Coms.Comment = "Setting Reminder for chrome"
            $Coms.RemindDefault = $true
        }
        if ($TaskSettings.ContainsKey('CreateShortcut') -and $TaskSettings.CreateShortcut -eq $true) {
            $Coms.Comment = "Creating Desktop Shortcut for Chrome"
            $shortcutPath = Join-Path -Path ([Environment]::GetFolderPath('Desktop')) -ChildPath "Google Chrome.lnk"
            $targetPath = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
            if (-not (Test-Path -Path $targetPath)) {
                $targetPath = "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
            }
            if (Test-Path -Path $targetPath) {
                $WScriptShell = New-Object -ComObject WScript.Shell
                $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
                $shortcut.TargetPath = $targetPath
                $shortcut.IconLocation = "$targetPath, 0"
                $shortcut.Save()
                $Coms.Comment = "Desktop shortcut for Chrome created."
            } else {
                $Coms.Comment = "Could not find Chrome executable to create shortcut."
            }
        }
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    }
}