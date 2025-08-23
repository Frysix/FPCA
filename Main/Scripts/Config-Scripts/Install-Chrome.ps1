# Config Script for FPCA that installs Google Chrome browser
# Standard Parameters structure for config scripts
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

$Coms.Status = "Running"
$Coms.Progress = 5
$Coms.Comment = "Initializing Chrome installation..."

# Initialize variables for cleanup
$tempDownloadPath = $null
$chromeInstalled = $false

try {
    Write-Host "Starting Google Chrome installation process..."
    
    # Step 1: Check if Chrome is already installed
    $Coms.Progress = 10
    $Coms.Comment = "Checking for existing Chrome installation..."
    
    $chromeInstalled = $false
    $chromeVersions = @()
    
    # Method 1: Check standard installation paths
    $chromePaths = @(
        "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "${env:LOCALAPPDATA}\Google\Chrome\Application\chrome.exe"
    )
    
    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            try {
                $version = (Get-ItemProperty $path).VersionInfo.ProductVersion
                $chromeVersions += "Found at: $path (Version: $version)"
                $chromeInstalled = $true
            } catch {
                $chromeVersions += "Found at: $path (Version: Unknown)"
                $chromeInstalled = $true
            }
        }
    }
    
    # Method 2: Check via Registry
    if (-not $chromeInstalled) {
        $registryPaths = @(
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome",
            "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome",
            "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Google Chrome"
        )
        
        foreach ($regPath in $registryPaths) {
            try {
                $chromeReg = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
                if ($chromeReg) {
                    $chromeVersions += "Registry entry found: $($chromeReg.DisplayName) $($chromeReg.DisplayVersion)"
                    $chromeInstalled = $true
                    break
                }
            } catch {
                # Continue checking other paths
            }
        }
    }
    
    # Method 3: Check via Get-Package (if available)
    if (-not $chromeInstalled) {
        try {
            $chromePackage = Get-Package -Name "*Chrome*" -ErrorAction SilentlyContinue
            if ($chromePackage) {
                $chromeVersions += "Package manager: $($chromePackage.Name) $($chromePackage.Version)"
                $chromeInstalled = $true
            }
        } catch {
            # Package manager check failed, continue
        }
    }
    
    if ($chromeInstalled) {
        Write-Host "Chrome is already installed:"
        foreach ($version in $chromeVersions) {
            Write-Host "  - $version"
        }
        $Coms.Progress = 100
        $Coms.Comment = "Chrome is already installed: $($chromeVersions[0])"
        $Coms.Status = "Completed"
        return
    }
    
    Write-Host "Chrome not found. Proceeding with installation..."
    
    # Step 2: Check internet connectivity
    $Coms.Progress = 15
    $Coms.Comment = "Checking internet connectivity..."
    
    $internetConnected = $false
    $testUrls = @(
        "https://dl.google.com",
        "https://www.google.com",
        "https://8.8.8.8"
    )
    
    foreach ($url in $testUrls) {
        try {
            $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                $internetConnected = $true
                Write-Host "Internet connectivity confirmed via: $url"
                break
            }
        } catch {
            Write-Host "Failed to connect to: $url"
        }
    }
    
    if (-not $internetConnected) {
        throw "No internet connectivity detected. Chrome installation requires internet access."
    }
    
    # Step 3: Prepare download
    $Coms.Progress = 25
    $Coms.Comment = "Preparing Chrome download..."
    
    # Create temp directory for download
    $tempDir = Join-Path $env:TEMP "FPCA_Chrome_$(Get-Random)"
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    $tempDownloadPath = Join-Path $tempDir "ChromeSetup.exe"
    
    Write-Host "Temporary download directory: $tempDir"
    
    # Chrome download URLs (multiple fallbacks)
    $chromeUrls = @(
        "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe",
        "https://dl.google.com/chrome/install/ChromeStandaloneSetup.exe",
        "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi",
        "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise.msi"
    )
    
    # Step 4: Download Chrome installer
    $Coms.Progress = 35
    $Coms.Comment = "Downloading Chrome installer..."
    
    $downloadSuccess = $false
    $downloadedFile = $null
    
    foreach ($url in $chromeUrls) {
        try {
            Write-Host "Attempting download from: $url"
            $Coms.Comment = "Downloading from: $(Split-Path $url -Leaf)..."
            
            # Determine file extension
            $fileName = if ($url -like "*.msi") { "ChromeSetup.msi" } else { "ChromeSetup.exe" }
            $downloadPath = Join-Path $tempDir $fileName
            
            # Download with progress
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($url, $downloadPath)
            
            # Verify download
            if (Test-Path $downloadPath) {
                $fileSize = (Get-Item $downloadPath).Length
                if ($fileSize -gt 1MB) {  # Chrome installer should be larger than 1MB
                    Write-Host "Download successful: $downloadPath ($([math]::Round($fileSize/1MB, 2)) MB)"
                    $downloadSuccess = $true
                    $downloadedFile = $downloadPath
                    break
                } else {
                    Write-Host "Downloaded file is too small ($fileSize bytes), trying next URL..."
                    Remove-Item $downloadPath -Force -ErrorAction SilentlyContinue
                }
            }
        } catch {
            Write-Host "Download failed from $url`: $($_.Exception.Message)"
            continue
        }
    }
    
    if (-not $downloadSuccess) {
        throw "Failed to download Chrome installer from all available sources."
    }
    
    # Step 5: Install Chrome
    $Coms.Progress = 60
    $Coms.Comment = "Installing Google Chrome..."
    
    Write-Host "Starting Chrome installation from: $downloadedFile"
    
    $installSuccess = $false
    $installationMethod = ""
    
    # Installation method based on file type
    if ($downloadedFile -like "*.msi") {
        # MSI Installation
        try {
            Write-Host "Installing Chrome via MSI..."
            $Coms.Comment = "Installing Chrome (MSI)..."
            
            $msiArgs = @(
                "/i",
                "`"$downloadedFile`"",
                "/quiet",
                "/norestart",
                "ALLUSERS=1"
            )
            
            # Handle task settings for MSI
            if ($TaskSettings) {
                if ($TaskSettings.ContainsKey('CreateShortcut') -and $TaskSettings.CreateShortcut -eq $false) {
                    $msiArgs += "DESKTOP_SHORTCUT=0"
                }
                if ($TaskSettings.ContainsKey('RemindDefault') -and $TaskSettings.RemindDefault -eq $false) {
                    $msiArgs += "SET_DEFAULT_BROWSER=0"
                }
            }
            
            $processInfo = New-Object System.Diagnostics.ProcessStartInfo
            $processInfo.FileName = "msiexec.exe"
            $processInfo.Arguments = $msiArgs -join " "
            $processInfo.RedirectStandardOutput = $true
            $processInfo.RedirectStandardError = $true
            $processInfo.UseShellExecute = $false
            $processInfo.CreateNoWindow = $true
            
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $processInfo
            $process.Start() | Out-Null
            
            # Wait for installation with timeout
            $timeout = 300  # 5 minutes
            $process.WaitForExit($timeout * 1000)
            
            if (-not $process.HasExited) {
                $process.Kill()
                throw "MSI installation timed out after $timeout seconds"
            }
            
            $exitCode = $process.ExitCode
            $stdout = $process.StandardOutput.ReadToEnd()
            $stderr = $process.StandardError.ReadToEnd()
            
            Write-Host "MSI Exit Code: $exitCode"
            if ($stdout) { Write-Host "MSI Output: $stdout" }
            if ($stderr) { Write-Host "MSI Error: $stderr" }
            
            if ($exitCode -eq 0 -or $exitCode -eq 3010) {  # 3010 = restart required
                $installSuccess = $true
                $installationMethod = "MSI"
            } else {
                throw "MSI installation failed with exit code: $exitCode"
            }
            
        } catch {
            Write-Host "MSI installation failed: $($_.Exception.Message)"
        }
    }
    
    if (-not $installSuccess -and $downloadedFile -like "*.exe") {
        # EXE Installation
        try {
            Write-Host "Installing Chrome via EXE..."
            $Coms.Comment = "Installing Chrome (EXE)..."
            
            $exeArgs = @(
                "/silent",
                "/install"
            )
            
            # Handle task settings for EXE
            if ($TaskSettings) {
                if ($TaskSettings.ContainsKey('CreateShortcut') -and $TaskSettings.CreateShortcut -eq $false) {
                    $exeArgs += "/no-desktop-shortcut"
                }
                if ($TaskSettings.ContainsKey('RemindDefault') -and $TaskSettings.RemindDefault -eq $false) {
                    $exeArgs += "/no-default-browser-check"
                }
            }
            
            $processInfo = New-Object System.Diagnostics.ProcessStartInfo
            $processInfo.FileName = $downloadedFile
            $processInfo.Arguments = $exeArgs -join " "
            $processInfo.RedirectStandardOutput = $true
            $processInfo.RedirectStandardError = $true
            $processInfo.UseShellExecute = $false
            $processInfo.CreateNoWindow = $true
            
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $processInfo
            $process.Start() | Out-Null
            
            # Wait for installation with timeout
            $timeout = 300  # 5 minutes
            $process.WaitForExit($timeout * 1000)
            
            if (-not $process.HasExited) {
                $process.Kill()
                throw "EXE installation timed out after $timeout seconds"
            }
            
            $exitCode = $process.ExitCode
            $stdout = $process.StandardOutput.ReadToEnd()
            $stderr = $process.StandardError.ReadToEnd()
            
            Write-Host "EXE Exit Code: $exitCode"
            if ($stdout) { Write-Host "EXE Output: $stdout" }
            if ($stderr) { Write-Host "EXE Error: $stderr" }
            
            if ($exitCode -eq 0) {
                $installSuccess = $true
                $installationMethod = "EXE"
            } else {
                throw "EXE installation failed with exit code: $exitCode"
            }
            
        } catch {
            Write-Host "EXE installation failed: $($_.Exception.Message)"
        }
    }
    
    if (-not $installSuccess) {
        throw "All Chrome installation methods failed."
    }
    
    # Step 6: Verify installation
    $Coms.Progress = 85
    $Coms.Comment = "Verifying Chrome installation..."
    
    Write-Host "Verifying Chrome installation..."
    Start-Sleep -Seconds 5  # Give installation time to complete
    
    $verificationSuccess = $false
    $installedVersion = "Unknown"
    
    # Re-check for Chrome installation
    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            try {
                $version = (Get-ItemProperty $path).VersionInfo.ProductVersion
                $installedVersion = $version
                $verificationSuccess = $true
                Write-Host "Chrome verification successful: $path (Version: $version)"
                break
            } catch {
                $verificationSuccess = $true
                Write-Host "Chrome verification successful: $path (Version: Unknown)"
                break
            }
        }
    }
    
    if (-not $verificationSuccess) {
        # Check registry again
        foreach ($regPath in $registryPaths) {
            try {
                $chromeReg = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue
                if ($chromeReg) {
                    $installedVersion = $chromeReg.DisplayVersion
                    $verificationSuccess = $true
                    Write-Host "Chrome verification successful via registry: $($chromeReg.DisplayName) $installedVersion"
                    break
                }
            } catch {
                continue
            }
        }
    }
    
    if (-not $verificationSuccess) {
        $Coms.Status = "Warning"
        $Coms.Comment = "Chrome installation completed but verification failed. Please check manually."
        $Coms.Progress = 95
    } else {
        # Step 7: Handle post-installation settings
        $Coms.Progress = 95
        $Coms.Comment = "Configuring post-installation settings..."
        
        # Create desktop shortcut if requested
        if ($TaskSettings -and $TaskSettings.ContainsKey('CreateShortcut') -and $TaskSettings.CreateShortcut -eq $true) {
            try {
                $Coms.Comment = "Creating desktop shortcut..."
                $desktopPath = [Environment]::GetFolderPath("Desktop")
                $shortcutPath = Join-Path $desktopPath "Google Chrome.lnk"
                
                # Find Chrome executable
                $chromeExe = $null
                foreach ($path in $chromePaths) {
                    if (Test-Path $path) {
                        $chromeExe = $path
                        break
                    }
                }
                
                if ($chromeExe) {
                    $WshShell = New-Object -ComObject WScript.Shell
                    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
                    $Shortcut.TargetPath = $chromeExe
                    $Shortcut.Description = "Google Chrome"
                    $Shortcut.Save()
                    Write-Host "Desktop shortcut created: $shortcutPath"
                }
            } catch {
                Write-Host "Failed to create desktop shortcut: $($_.Exception.Message)"
            }
        }
        
        # Set as default browser reminder
        if ($TaskSettings -and $TaskSettings.ContainsKey('RemindDefault') -and $TaskSettings.RemindDefault -eq $true) {
            $Coms.Comment = "Chrome installed. Remember to set as default browser if desired."
        }
        
        $Coms.Progress = 100
        $Coms.Comment = "Chrome installation completed successfully. Version: $installedVersion (Method: $installationMethod)"
        $Coms.Status = "Completed"
        
        Write-Host "Google Chrome installation completed successfully!"
        Write-Host "Installation Method: $installationMethod"
        Write-Host "Version: $installedVersion"
    }
    
} catch {
    Write-Host "Error during Chrome installation: $($_.Exception.Message)" -ForegroundColor Red
    $Coms.Status = "Failed"
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Progress = 0
    $Coms.Comment = "Chrome installation failed: $($_.Exception.Message)"
} finally {
    # Cleanup: Remove temporary files
    if ($tempDownloadPath -and (Test-Path (Split-Path $tempDownloadPath -Parent))) {
        try {
            Write-Host "Cleaning up temporary files..."
            Remove-Item (Split-Path $tempDownloadPath -Parent) -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "Warning: Could not clean up temporary files: $($_.Exception.Message)"
        }
    }
}

Write-Host "Install-Chrome script completed with status: $($Coms.Status)"

