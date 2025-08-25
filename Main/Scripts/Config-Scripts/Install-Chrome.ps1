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
        
        # Use simple download method instead of Threaded-InstallerV2.ps1 to avoid runspace issues
        try {
            $Coms.Comment = "Downloading Chrome MSI installer..."
            $Coms.Progress = 15
            
            # Ensure output directory exists
            $OutputDir = Split-Path $msiInstallerPath -Parent
            if (-not (Test-Path $OutputDir)) {
                New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
            }
            
            # Use Invoke-WebRequest with progress updates
            Write-Host "Downloading MSI installer..."
            Invoke-WebRequest -Uri $chromeMsiUrl -OutFile $msiInstallerPath -UseBasicParsing
            
            $Coms.Progress = 45
            $Coms.Comment = "MSI download completed"
            
            # Verify download
            if (Test-Path -Path $msiInstallerPath) {
                $fileSize = (Get-Item $msiInstallerPath).Length
                Write-Host "Downloaded file size: $([math]::Round($fileSize/1MB, 2)) MB"
                if ($fileSize -gt 1MB) {
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
            $Coms.Progress = 10
            
            Write-Host "Starting Chrome EXE download from: $chromeExeUrl"
            Write-Host "Target path: $exeInstallerPath"
            
            try {
                $Coms.Comment = "Downloading Chrome EXE installer..."
                $Coms.Progress = 15
                
                # Ensure output directory exists
                $OutputDir = Split-Path $exeInstallerPath -Parent
                if (-not (Test-Path $OutputDir)) {
                    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
                }
                
                # Use Invoke-WebRequest for EXE download
                Write-Host "Downloading EXE installer..."
                Invoke-WebRequest -Uri $chromeExeUrl -OutFile $exeInstallerPath -UseBasicParsing
                
                $Coms.Progress = 45
                $Coms.Comment = "EXE download completed"
                
                # Verify download
                if (Test-Path -Path $exeInstallerPath) {
                    $fileSize = (Get-Item $exeInstallerPath).Length
                    Write-Host "Downloaded EXE file size: $([math]::Round($fileSize/1MB, 2)) MB"
                    if ($fileSize -gt 500KB) {
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