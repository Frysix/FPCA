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

Try {

    $Coms.Status = "Running"
    $Coms.Progress = 10
    $Coms.Comment = "Starting Quick Assist to Desktop task"

    # Get the desktop path for the current user
    $DesktopPath = [Environment]::GetFolderPath("Desktop")
    $Coms.Comment = "Located desktop path: $DesktopPath. `n`rPlacing icon in AppData folder..."
    $IconCopied = $false
    if (Test-Path -Path "$ScriptRoot\Assets\img\icons\OutlookNew_Icon.ico") {
        if (-not (Test-Path -Path "$env:APPDATA\outlooknewicon")) {
            New-Item -ItemType Directory -Path "$env:APPDATA\outlooknewicon" -force
        }
        Copy-Item -Path "$ScriptRoot\Assets\img\icons\OutlookNew_Icon.ico" -Destination "$env:APPDATA\outlooknewicon\OutlookNew_Icon.ico" -Force
        if (Test-Path -Path "$env:APPDATA\outlooknewicon\OutlookNew_Icon.ico") {
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
        $ShortcutDescription = "Outlook New - Accédez facilement à vos courriels et calendriers"
    } elseif ($TaskSettings.InputCombo -eq "English") {
        $Coms.Comment = "Creating shortcut in english..."
        $ShortcutDescription = "Outlook New - Easily access your emails and calendars"
    }
    # Define the shortcut path
    $ShortcutPath = Join-Path $DesktopPath "Outlook New.lnk"

    $Coms.Progress = 50
    $Coms.Comment = "Creating shortcut at path: $ShortcutPath"

    # Create WScript.Shell COM object to create shortcut
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)

    # Identify the new outlook app id
    $shell = New-Object -ComObject shell.application
    $apps = $shell.Namespace('shell:AppsFolder').Items()
    $OlkApps = $apps | Where-Object { $_.Name -match 'Outlook' } | Select-Object Name, @{n='AppID';e={$_.Path}}
    Foreach ($app in $OlkApps) {
        if (-not ($app.Name -match "(classic)")) {
            $OutlookAppId = $app.AppID
            Break
        }
    }

    $Shortcut.TargetPath = "${env:WINDIR}\System32\cmd.exe"
    $Shortcut.Arguments = "/c powershell -ExecutionPolicy ByPass -Command `"Start-Process shell:AppsFolder\$OutlookAppId`""
    $Shortcut.WindowStyle = 7  # Minimized
    $Shortcut.Description = $ShortcutDescription
    if ($IconCopied) {
        $Shortcut.IconLocation = "$env:APPDATA\outlooknewicon\OutlookNew_Icon.ico"
        $Coms.Comment = "Applying custom icon to shortcut."
    } else {
        # Use default app icon
        $Shortcut.IconLocation = "${env:WINDIR}\System32\imageres.dll, -5302"
        $Coms.Comment = "Applying default Outlook New icon to shortcut."
    }
    $Shortcut.Save()

    # Release COM object
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
        
    $Coms.Progress = 90
    $Coms.Comment = "Verifying shortcut..."

    # Verify shortcut was created
    if (Test-Path $ShortcutPath) {
        Write-Host "Outlook New shortcut successfully created on desktop: $ShortcutPath"
        $Coms.Status = "Completed"
        $Coms.Comment = "Outlook New shortcut created successfully."
        $Coms.Progress = 100
        $Coms.EndTime = Get-Date
    } else {
        throw "Failed to create shortcut file"
    }
} Catch {
    Write-Host "Error creating Quick Assist shortcut: $($_.Exception.Message)" -ForegroundColor Red
    $Coms.Status = "Failed"
    $Coms.Progress = 0
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.EndTime = Get-Date
}