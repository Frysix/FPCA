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
        # Note: Adobe uses a complex URL structure, using known direct download URLs
        $acrobatMsiUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820360/AcroRdrDC2300820360_en_US.msi"
        $acrobatExeUrl = "https://get.adobe.com/reader/download/?installer=Reader_DC_English_Windows&os=Windows%2011&browser_type=KHTML&browser_dist=Chrome&d=McAfee_Security_Scan_Plus&d=McAfee_Safe_Connect"
        $msiInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\AdobeReaderDC.msi"
        $exeInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\AdobeReaderDC.exe"
        
        $Coms.Comment = "Trying to download Adobe Acrobat Reader installer from Adobe's MSI source"
        $Coms.Progress = 10
        
        Write-Host "Starting Adobe Reader MSI download from: $acrobatMsiUrl"
        Write-Host "Target path: $msiInstallerPath"
        
        # Use simple download method to avoid runspace issues
        try {
            $Coms.Comment = "Downloading Adobe Reader MSI installer..."
            $Coms.Progress = 15
            
            # Ensure output directory exists
            $OutputDir = Split-Path $msiInstallerPath -Parent
            if (-not (Test-Path $OutputDir)) {
                New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
            }
            
            # Use Invoke-WebRequest with progress updates
            Write-Host "Downloading MSI installer..."
            Invoke-WebRequest -Uri $acrobatMsiUrl -OutFile $msiInstallerPath -UseBasicParsing
            
            $Coms.Progress = 45
            $Coms.Comment = "MSI download completed"
            
            # Verify download
            if (Test-Path -Path $msiInstallerPath) {
                $fileSize = (Get-Item $msiInstallerPath).Length
                Write-Host "Downloaded file size: $([math]::Round($fileSize/1MB, 2)) MB"
                if ($fileSize -gt 10MB) { # Adobe Reader is usually 100+ MB
                    Write-Host "MSI download successful"
                } else {
                    Write-Host "Downloaded file too small, treating as failed"
                    $firstTryFailed = $true
                }
            } else {
                Write-Host "MSI download failed - file not found"
                $firstTryFailed = $true
            }
            
        } catch {
            Write-Host "Error during MSI download: $($_.Exception.Message)"
            $Coms.Comment = "MSI download error - trying alternative method"
            $firstTryFailed = $true
        }
        
        if (-not $firstTryFailed) {
            $Coms.Comment = "Download completed. Starting Adobe Reader installation."
            $Coms.Progress = 50
            
            # Install Adobe Reader using MSI with quiet parameters
            $installProcess = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$msiInstallerPath`" /qn /norestart EULA_ACCEPT=YES" -Wait -PassThru -Verb RunAs
            if ($installProcess.ExitCode -eq 0) {
                $InstallSuccess = $true
                $Coms.Progress = 80
                $Coms.Comment = "Adobe Acrobat Reader installed successfully."
            } else {
                $Coms.Comment = "Adobe Reader installation failed with exit code $($installProcess.ExitCode)."
                $firstTryFailed = $true
            }
        } else {
            $Coms.Comment = "Failed to download Adobe Reader installer from primary MSI URL."
            $firstTryFailed = $true
        }
        
        # Try alternative download method (using Adobe's web installer)
        if ($firstTryFailed) {
            $Coms.Comment = "Trying alternative Adobe Reader download method."
            $Coms.Progress = 10
            
            # Use a more reliable direct download URL for the offline installer
            $alternativeUrl = "https://get.adobe.com/reader/download/?installer=Reader_DC_English_Windows&os=Windows%2011"
            $exeInstallerPath = Join-Path -Path $env:USERPROFILE "\Downloads\AdobeReaderDC_installer.exe"
            
            Write-Host "Starting Adobe Reader alternative download from Adobe"
            Write-Host "Target path: $exeInstallerPath"
            
            try {
                $Coms.Comment = "Downloading Adobe Reader installer (alternative method)..."
                $Coms.Progress = 15
                
                # Ensure output directory exists
                $OutputDir = Split-Path $exeInstallerPath -Parent
                if (-not (Test-Path $OutputDir)) {
                    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
                }
                
                # Try to get the actual installer using web scraping approach
                # Since Adobe's download page is complex, we'll use a known working direct URL
                $directInstallerUrl = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2300820360/AcroRdrDC2300820360_en_US.exe"
                
                Write-Host "Downloading EXE installer from direct URL..."
                Invoke-WebRequest -Uri $directInstallerUrl -OutFile $exeInstallerPath -UseBasicParsing
                
                $Coms.Progress = 45
                $Coms.Comment = "EXE download completed"
                
                # Verify download
                if (Test-Path -Path $exeInstallerPath) {
                    $fileSize = (Get-Item $exeInstallerPath).Length
                    Write-Host "Downloaded EXE file size: $([math]::Round($fileSize/1MB, 2)) MB"
                    if ($fileSize -gt 1MB) {
                        Write-Host "EXE download successful"
                    } else {
                        Write-Host "Downloaded EXE file too small"
                        $Coms.Progress = 0
                        $Coms.Status = "Failed"
                    }
                } else {
                    Write-Host "EXE download failed - file not found"
                    $Coms.Progress = 0
                    $Coms.Status = "Failed"
                }
                
            } catch {
                Write-Host "Error during EXE download: $($_.Exception.Message)"
                $Coms.Comment = "EXE download error"
                $Coms.Progress = 0
                $Coms.Status = "Failed"
            }
            
            if ((Test-Path -Path $exeInstallerPath) -and $Coms.Status -ne "Failed") {
                $Coms.Comment = "Download completed. Starting Adobe Reader installation."
                $Coms.Progress = 50
                
                # Install Adobe Reader using EXE with silent parameters
                $installProcess = Start-Process -FilePath $exeInstallerPath -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES" -Wait -PassThru -Verb RunAs
                if ($installProcess.ExitCode -eq 0) {
                    $InstallSuccess = $true
                    $Coms.Progress = 80
                    $Coms.Comment = "Adobe Acrobat Reader installed successfully."
                } else {
                    $Coms.Comment = "Adobe Reader installation failed with exit code $($installProcess.ExitCode)."
                    $Coms.Progress = 0
                    $Coms.Status = "Failed"
                }
            } else {
                $Coms.Comment = "Failed to download Adobe Reader installer from alternative URL."
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
        $Coms.Comment = "Finalizing Adobe Reader installation according to settings."
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
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    }
}