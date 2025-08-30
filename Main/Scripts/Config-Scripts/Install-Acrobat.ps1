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

$acrobatInstalled = $false
$firstTryFailed = $false
$InstallSuccess = $false
$ShortCutExists = $false
$msiInstallerPath = $null
$exeInstallerPath = $null
$Coms.Status = "Running"
$Coms.Comment = "Starting Adobe Acrobat Reader Installation Script"
$Coms.Progress = 1

Try {
    $Coms.Comment = "Checking if Adobe Acrobat Reader is already installed"
    
    # Check if Acrobat Reader is already installed multiple ways
    $acrobatPaths = @(
        "$env:ProgramFiles\Adobe\Acrobat DC\Acrobat\Acrobat.exe",
        "$env:ProgramFiles(x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe",
        "$env:ProgramFiles\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe",
        "$env:ProgramFiles(x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe"
    )
    
    foreach ($path in $acrobatPaths) {
        if (Test-Path $path) {
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

    if ($acrobatInstalled) {
        $Coms.Comment = "Adobe Acrobat Reader is already installed. No action needed."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    } else {
        $Coms.Comment = "Adobe Acrobat Reader not found. Proceeding with installation."
        $Coms.Progress = 5
        
        # Download and install Adobe Acrobat Reader from the latest sources
        # Using Adobe's FTP download URLs which are more reliable
        $acrobatMsiUrl = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/misc/AcroRdrDCUpd2300820360.msp"
        $acrobatExeUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820533/AcroRdrDC2300820533_en_US.exe"
        # Fallback to the web installer
        $webInstallerUrl = "https://get.adobe.com/reader/download/?installer=Reader_DC_English_Windows&os=Windows%2010&browser_type=KHTML"
        
        $msiInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\AdobeReaderDC.msi"
        $exeInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\AdobeReaderDC.exe"
        
        $Coms.Comment = "Trying to download Adobe Acrobat Reader installer"
        $Coms.Progress = 10
        
        Write-Host "Starting Adobe Reader download"
        Write-Host "Primary URL: $acrobatExeUrl"
        Write-Host "Target path: $exeInstallerPath"
        
        # Use simple download method to avoid runspace issues
        try {
            $Coms.Comment = "Downloading Adobe Reader installer..."
            $Coms.Progress = 15
            
            # Ensure output directory exists
            $OutputDir = Split-Path $exeInstallerPath -Parent
            if (-not (Test-Path $OutputDir)) {
                New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
            }
            
            # Try the EXE installer first (more reliable)
            Write-Host "Downloading EXE installer..."
            try {
                Invoke-WebRequest -Uri $acrobatExeUrl -OutFile $exeInstallerPath -UseBasicParsing -TimeoutSec 300
                $Coms.Progress = 45
                $Coms.Comment = "Download completed"
                
                # Verify download
                if (Test-Path -Path $exeInstallerPath) {
                    $fileSize = (Get-Item $exeInstallerPath).Length
                    Write-Host "Downloaded file size: $([math]::Round($fileSize/1MB, 2)) MB"
                    if ($fileSize -gt 5MB) { # Adobe Reader should be at least 5MB
                        Write-Host "EXE download successful"
                        $firstTryFailed = $false
                    } else {
                        Write-Host "Downloaded file too small ($([math]::Round($fileSize/1MB, 2)) MB), trying alternative"
                        Remove-Item $exeInstallerPath -Force -ErrorAction SilentlyContinue
                        $firstTryFailed = $true
                    }
                } else {
                    Write-Host "EXE download failed - file not found"
                    $firstTryFailed = $true
                }
            } catch {
                Write-Host "Primary EXE download failed: $($_.Exception.Message)"
                $firstTryFailed = $true
            }
            
        } catch {
            Write-Host "Error during download setup: $($_.Exception.Message)"
            $Coms.Comment = "Download error - trying alternative method"
            $firstTryFailed = $true
        }
        
        if (-not $firstTryFailed -and (Test-Path -Path $exeInstallerPath)) {
            $Coms.Comment = "Download completed. Starting Adobe Reader installation."
            $Coms.Progress = 50
            
            # Install Adobe Reader using EXE with silent parameters
            Write-Host "Installing Adobe Reader from EXE..."
            try {
                $installArgs = @(
                    "/sAll",           # Silent install all
                    "/rs",             # Suppress restart
                    "/msi",            # Use MSI mode
                    "/norestart",      # No restart
                    "/quiet",          # Quiet mode
                    "EULA_ACCEPT=YES", # Accept EULA
                    "SUPPRESS_APP_LAUNCH=YES" # Don't launch after install
                )
                
                Write-Host "Install command: $exeInstallerPath $($installArgs -join ' ')"
                $installProcess = Start-Process -FilePath $exeInstallerPath -ArgumentList $installArgs -Wait -PassThru -Verb RunAs
                
                Write-Host "Installation exit code: $($installProcess.ExitCode)"
                
                if ($installProcess.ExitCode -eq 0) {
                    $InstallSuccess = $true
                    $Coms.Progress = 80
                    $Coms.Comment = "Adobe Acrobat Reader installed successfully."
                } else {
                    Write-Host "Adobe Reader installation failed with exit code $($installProcess.ExitCode)."
                    $Coms.Comment = "Adobe Reader installation failed with exit code $($installProcess.ExitCode)."
                    $firstTryFailed = $true
                }
            } catch {
                Write-Host "Error during installation: $($_.Exception.Message)"
                $Coms.Comment = "Installation error: $($_.Exception.Message)"
                $firstTryFailed = $true
            }
        } else {
            $Coms.Comment = "Failed to download Adobe Reader installer from primary URL."
            $firstTryFailed = $true
        }
        
        # Try alternative download method (direct from Adobe with different approach)
        if ($firstTryFailed) {
            $Coms.Comment = "Trying alternative Adobe Reader download method."
            $Coms.Progress = 10
            
            # Try a different approach - download the web installer and let it handle the download
            $webInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\AdobeReaderDC_web.exe"
            
            Write-Host "Attempting to download Adobe web installer"
            
            try {
                # Use a more generic Adobe Reader download URL
                $genericUrl = "https://get.adobe.com/reader/"
                
                # Try to get the actual download URL by parsing Adobe's page (simplified approach)
                $alternativeDirectUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820533/AcroRdrDC2300820533_en_US.exe"
                
                $Coms.Comment = "Downloading from alternative source..."
                $Coms.Progress = 20
                
                Invoke-WebRequest -Uri $alternativeDirectUrl -OutFile $webInstallerPath -UseBasicParsing -TimeoutSec 300
                
                $Coms.Progress = 45
                $Coms.Comment = "Alternative download completed"
                
                # Verify download
                if (Test-Path -Path $webInstallerPath) {
                    $fileSize = (Get-Item $webInstallerPath).Length
                    Write-Host "Alternative download file size: $([math]::Round($fileSize/1MB, 2)) MB"
                    if ($fileSize -gt 1MB) {
                        Write-Host "Alternative download successful"
                        
                        # Try installation with the alternative download
                        $Coms.Comment = "Installing Adobe Reader from alternative download."
                        $Coms.Progress = 50
                        
                        try {
                            # Try simpler installation arguments
                            $simpleArgs = @("/S")  # Just silent install
                            
                            Write-Host "Alternative install command: $webInstallerPath $($simpleArgs -join ' ')"
                            $installProcess = Start-Process -FilePath $webInstallerPath -ArgumentList $simpleArgs -Wait -PassThru -Verb RunAs
                            
                            Write-Host "Alternative installation exit code: $($installProcess.ExitCode)"
                            
                            if ($installProcess.ExitCode -eq 0) {
                                $InstallSuccess = $true
                                $Coms.Progress = 80
                                $Coms.Comment = "Adobe Acrobat Reader installed successfully (alternative method)."
                            } else {
                                Write-Host "Alternative installation also failed with exit code: $($installProcess.ExitCode)"
                                $Coms.Comment = "All installation methods failed. Exit code: $($installProcess.ExitCode)"
                                $Coms.Progress = 0
                                $Coms.Status = "Failed"
                            }
                        } catch {
                            Write-Host "Alternative installation error: $($_.Exception.Message)"
                            $Coms.Comment = "Alternative installation error: $($_.Exception.Message)"
                            $Coms.Progress = 0
                            $Coms.Status = "Failed"
                        }
                        
                        # Clean up alternative installer
                        Remove-Item $webInstallerPath -Force -ErrorAction SilentlyContinue
                        
                    } else {
                        Write-Host "Alternative download file too small"
                        $Coms.Comment = "All download methods failed."
                        $Coms.Progress = 0
                        $Coms.Status = "Failed"
                    }
                } else {
                    Write-Host "Alternative download failed - file not found"
                    $Coms.Comment = "All download methods failed."
                    $Coms.Progress = 0
                    $Coms.Status = "Failed"
                }
                
            } catch {
                Write-Host "Alternative download error: $($_.Exception.Message)"
                $Coms.Comment = "All download methods failed: $($_.Exception.Message)"
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
    # Clean up downloaded installers (only if they exist and variables are defined)
    $cleanupPaths = @()
    
    if ($msiInstallerPath) { $cleanupPaths += $msiInstallerPath }
    if ($exeInstallerPath) { $cleanupPaths += $exeInstallerPath }
    if ($webInstallerPath) { $cleanupPaths += $webInstallerPath }
    
    foreach ($path in $cleanupPaths) {
        try {
            if (Test-Path -Path $path -ErrorAction SilentlyContinue) {
                Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
                Write-Host "Cleaned up: $path"
            }
        } catch {
            Write-Host "Could not clean up $path : $($_.Exception.Message)"
        }
    }
    
    if ($InstallSuccess) {
        $Coms.Comment = "Finalizing Adobe Reader installation according to settings."
        Start-Sleep -Seconds 5
        if ($TaskSettings.ContainsKey('SetAsDefault') -and $TaskSettings.SetAsDefault -eq $true) {
            $Coms.Comment = "Setting Adobe Reader as default PDF reader"
            # Set file associations for PDF files
            try {
                $acrobatPath = ""
                foreach ($path in $acrobatPaths) {
                    if (Test-Path $path) {
                        $acrobatPath = $path
                        break
                    }
                }
                if ($acrobatPath) {
                    # Register Adobe Reader as the default PDF handler
                    cmd /c "assoc .pdf=AcroExch.Document"
                    cmd /c "ftype AcroExch.Document=`"$acrobatPath`" `"%1`""
                    $Coms.Comment = "Adobe Reader set as default PDF reader."
                } else {
                    $Coms.Comment = "Could not find Adobe Reader executable to set as default."
                }
            } catch {
                Write-Host "Error setting Adobe Reader as default: $($_.Exception.Message)"
            }
        }
        if ($TaskSettings.ContainsKey('CreateShortcut') -and $TaskSettings.CreateShortcut -eq $true) {
            $DesktopIcons = Get-ChildItem -Path "$env:USERPROFILE\Desktop" -ErrorAction SilentlyContinue
            if ($DekstopIcons) {
                foreach ($icon in $DesktopIcons) {
                    if ($icon.Name -match "Acrobat") {
                        Write-Host "Desktop shortcut already exists: $($icon.FullName)"
                        $Coms.Comment = "Desktop shortcut already exists."
                        $ShortCutExists = $true
                        break
                    }
                }
            }
            if (-not ($ShortCutExists)) {
                $Coms.Comment = "Creating Desktop Shortcut for Adobe Reader"
                $shortcutPath = Join-Path -Path ([Environment]::GetFolderPath('Desktop')) -ChildPath "Adobe Acrobat Reader DC.lnk"
                $targetPath = ""
                
                # Find the correct executable path
                foreach ($path in $acrobatPaths) {
                    if (Test-Path -Path $path) {
                        $targetPath = $path
                        break
                    }
                }
                
                if ($targetPath) {
                    try {
                        $WScriptShell = New-Object -ComObject WScript.Shell
                        $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
                        $shortcut.TargetPath = $targetPath
                        $shortcut.IconLocation = "$targetPath, 0"
                        $shortcut.Save()
                        $Coms.Comment = "Desktop shortcut for Adobe Reader created."
                    } catch {
                        $Coms.Comment = "Error creating desktop shortcut: $($_.Exception.Message)"
                    }
                } else {
                    $Coms.Comment = "Could not find Adobe Reader executable to create shortcut."
                }
            }
        }
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    } else {
        # Make sure we have proper error status if installation failed
        if (-not $Coms.Status -or $Coms.Status -eq "") {
            $Coms.Status = "Failed"
            $Coms.Progress = 0
            if (-not $Coms.Comment -or $Coms.Comment -eq "") {
                $Coms.Comment = "Adobe Acrobat Reader installation failed."
            }
        }
    }
}