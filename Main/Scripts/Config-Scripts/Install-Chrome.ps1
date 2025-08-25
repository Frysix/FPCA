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
        $chromeInstallerUrl = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        $installerPath = Join-Path -Path $env:USERPROFILE "\Downloads\googlechromestandaloneenterprise64.msi"
        $InstallerComs = @{}
        $Coms.Comment = "Trying to download Chrome installer from $chromeInstallerUrl"
        $Coms.Progress = 10
        . "$ScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1" -Url $chromeInstallerUrl -OutputFile $installerPath -Coms $InstallerComs -TaskName $TaskName -ChunkNumber 1
        if ($InstallerComs.Status -eq "Completed" -and (Test-Path $installerPath)) {
            $Coms.Comment = "Download completed. Starting Chrome installation."
            $Coms.Progress = 50
            $installProcess = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait -PassThru -Verb RunAs
            if ($installProcess.ExitCode -eq 0) {
                $InstallSuccess = $true
                $Coms.Progress = 80
                $Coms.Comment = "Google Chrome installed successfully."
            } else {
                $Coms.Comment = "Chrome installation failed with exit code $($installProcess.ExitCode)."
                $firstTryFailed = $true
            }
        } else {
            $Coms.Comment = "Failed to download Chrome installer from primary URL."
            $firstTryFailed = $true
        }
        # Try second option to download Chrome installer
        if ($firstTryFailed) {
            $Coms.Comment = "Failed to download Chrome installer, trying alternative URL."
            $chromeInstallerUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
            $installerPath2 = Join-Path -Path $env:USERPROFILE "\Downloads\chrome_installer.exe"
            $InstallerComs = @{}
            $Coms.Progress = 10
            . "$ScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1" -Url $chromeInstallerUrl -OutputFile $installerPath2 -Coms $InstallerComs -TaskName $TaskName -ChunkNumber 1
            if ($InstallerComs.Status -eq "Completed" -and (Test-Path $installerPath2)) {
                $Coms.Comment = "Download completed. Starting Chrome installation."
                $Coms.Progress = 50
                $installProcess = Start-Process -FilePath $installerPath2 -ArgumentList "/silent /install" -Wait -PassThru -Verb RunAs
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
                $Coms.Comment = "Failed to download Chrome installer from alternative URL."
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
    if (Test-Path -Path $installerPath) {
        Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path -Path $installerPath2) {
        Remove-Item -Path $installerPath2 -Force -ErrorAction SilentlyContinue
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