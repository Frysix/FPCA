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

try {

    $Coms.Status = "Running"
    $Coms.Progress = 10
    $Coms.Comment = "Starting Quick Assist to Desktop task"

    # Get the desktop path for the current user
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $Coms.Comment = "Located desktop path: $DesktopPath. `n`rPlacing icon in AppData folder..."
    $IconCopied = $false
    if (Test-Path -Path "$ScriptRoot\Assets\img\icons\QuickAssist_Icon.ico") {
        if (-not (Test-Path -Path "$env:APPDATA\quickassisticon")) {
            New-Item -ItemType Directory -Path "$env:APPDATA\quickassisticon" | Out-Null
        }
        Copy-Item -Path "$ScriptRoot\Assets\img\icons\QuickAssist_Icon.ico" -Destination "$env:APPDATA\quickassisticon\QuickAssist_Icon.ico" -Force
        if (Test-Path -Path "$env:APPDATA\quickassisticon\QuickAssist_Icon.ico") {
            $Coms.Comment = "Icon file copied to AppData folder."
            $IconCopied = $true
        }
    } else {
        $Coms.Comment = "Icon file not found in Assets folder not applying any icon"
    }

    $Coms.Progress = 30
    
    # Create shortcut on desktop
    if ($TaskSettings.InputCombo -eq "French") {
        $Coms.Comment = "Creating shortcut in french..."
        $ShortcutPath = Join-Path $DesktopPath "Assistance Rapide.lnk"
        $ShortcutDescription = "Assistance Rapide - Aidez quelqu'un ou obtenez de l'aide"
    } elseif ($TaskSettings.InputCombo -eq "English") {
        $Coms.Comment = "Creating shortcut in english..."
        $ShortcutPath = Join-Path $DesktopPath "Quick Assist.lnk"
        $ShortcutDescription = "Windows Quick Assist - Help someone or get help"
    }
    $Coms.Progress = 50
    $Coms.Comment = "Creating shortcut at path: $ShortcutPath"
    # Create WScript.Shell COM object to create shortcut
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)

    # Use protocol handler for UWP app
    $Shortcut.TargetPath = "${env:WINDIR}\System32\cmd.exe"
    $Shortcut.Arguments = "/c start ms-quick-assist:"
    $Shortcut.WindowStyle = 7  # Minimized
    
    $Shortcut.Description = $ShortcutDescription
    if ($IconCopied) {
        $Shortcut.IconLocation = "$env:APPDATA\quickassisticon\QuickAssist_Icon.ico"
        $Coms.Comment = "Applying custom icon to shortcut."
    } else {
         # Use default Quick Assist icon if custom icon not copied
        $Shortcut.IconLocation = "${env:WINDIR}\System32\quickassist.exe,0"
        $Coms.Comment = "Trying to apply default Quick Assist icon to shortcut."
    }
    
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
        $Coms.Comment = "Quick Assist shortcut created successfully."
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