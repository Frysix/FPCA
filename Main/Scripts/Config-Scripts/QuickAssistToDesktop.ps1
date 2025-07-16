Param(
    $Coms,
    $TaskName
)

$Coms.Status = "Running"
$Coms.Progress = 10

try {
    Write-Host "Starting Quick Assist to Desktop task..."
    
    # Get the desktop path for the current user
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    Write-Host "Desktop path: $DesktopPath"
    
    $Coms.Progress = 25
    $Coms.Comment = "Searching for Quick Assist..."
    
    # Possible locations for Quick Assist
    $QuickAssistExe = $null
    $QuickAssistPaths = @(
        "${env:WINDIR}\System32\quickassist.exe",
        "${env:WINDIR}\SysWOW64\quickassist.exe"
    )
    
    # First try the standard Windows locations
    foreach ($Path in $QuickAssistPaths) {
        Write-Host "Checking: $Path"
        if (Test-Path $Path) {
            $QuickAssistExe = $Path
            Write-Host "Found Quick Assist at: $QuickAssistExe"
            break
        }
    }
    
    # If not found in standard locations, try WindowsApps
    if (-not $QuickAssistExe) {
        Write-Host "Searching in WindowsApps..."
        $WindowsAppsPath = "${env:ProgramFiles}\WindowsApps"
        if (Test-Path $WindowsAppsPath) {
            $QuickAssistFolders = Get-ChildItem -Path $WindowsAppsPath -Directory -Filter "*QuickAssist*" -ErrorAction SilentlyContinue
            foreach ($folder in $QuickAssistFolders) {
                $ExePath = Join-Path $folder.FullName "QuickAssist.exe"
                if (Test-Path $ExePath) {
                    $QuickAssistExe = $ExePath
                    Write-Host "Found Quick Assist in WindowsApps: $QuickAssistExe"
                    break
                }
            }
        }
    }
    
    # If still not found, try using Get-AppxPackage
    if (-not $QuickAssistExe) {
        Write-Host "Trying Get-AppxPackage..."
        $QuickAssistApp = Get-AppxPackage -Name "*QuickAssist*" -ErrorAction SilentlyContinue
        if ($QuickAssistApp) {
            $AppPath = $QuickAssistApp.InstallLocation
            Write-Host "Found AppxPackage at: $AppPath"
            $ExePath = Join-Path $AppPath "QuickAssist.exe"
            if (Test-Path $ExePath) {
                $QuickAssistExe = $ExePath
                Write-Host "Found executable via AppxPackage: $QuickAssistExe"
            }
        }
    }
    
    # If still not found, try using ms-quick-assist protocol
    if (-not $QuickAssistExe) {
        Write-Host "Quick Assist executable not found. Creating protocol shortcut..."
        $QuickAssistExe = "ms-quick-assist:"
    }
    
    $Coms.Progress = 50
    $Coms.Comment = "Creating shortcut..."
    
    # Create shortcut on desktop
    $ShortcutPath = Join-Path $DesktopPath "Quick Assist.lnk"
    Write-Host "Creating shortcut at: $ShortcutPath"
    
    # Create WScript.Shell COM object to create shortcut
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    
    if ($QuickAssistExe -eq "ms-quick-assist:") {
        # Use protocol handler for UWP app
        $Shortcut.TargetPath = "${env:WINDIR}\System32\cmd.exe"
        $Shortcut.Arguments = "/c start ms-quick-assist:"
        $Shortcut.WindowStyle = 7  # Minimized
    } else {
        # Use direct executable path
        $Shortcut.TargetPath = $QuickAssistExe
        $Shortcut.WorkingDirectory = Split-Path $QuickAssistExe -Parent
    }
    
    $Shortcut.Description = "Windows Quick Assist - Help someone or get help"
    $Shortcut.IconLocation = "${env:WINDIR}\System32\quickassist.exe,0"
    
    $Coms.Progress = 75
    $Coms.Comment = "Saving shortcut..."
    
    # Save the shortcut
    $Shortcut.Save()
    
    # Release COM object
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
    
    $Coms.Progress = 90
    $Coms.Comment = "Verifying shortcut..."
    
    # Verify shortcut was created
    if (Test-Path $ShortcutPath) {
        Write-Host "Quick Assist shortcut successfully created on desktop: $ShortcutPath"
        $Coms.Status = "Completed"
        $Coms.Progress = 100
        $Coms.EndTime = Get-Date
    } else {
        throw "Failed to create shortcut file"
    }
    
} catch {
    Write-Host "Error creating Quick Assist shortcut: $($_.Exception.Message)" -ForegroundColor Red
    $Coms.Status = "Failed"
    $Coms.Progress = 0
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.EndTime = Get-Date
}