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

$configurationSuccess = $false
$changesApplied = 0
$Coms.Status = "Running"
$Coms.Comment = "Starting File Explorer configuration"
$Coms.Progress = 1

Try {
    $Coms.Comment = "Configuring File Explorer to open to 'This PC'"
    $Coms.Progress = 10
    
    # Check if running as administrator for some registry changes
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    Write-Host "Configuring File Explorer settings..."
    Write-Host "Administrator privileges: $isAdmin"
    
    # Registry paths for Explorer configuration
    $explorerAdvancedPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $explorerRibbonPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon"
    $explorerCabinetStatePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState"
    
    $Coms.Comment = "Setting File Explorer to open to 'This PC'"
    $Coms.Progress = 20
    
    # Ensure the registry paths exist
    if (-not (Test-Path $explorerAdvancedPath)) {
        New-Item -Path $explorerAdvancedPath -Force | Out-Null
        Write-Host "Created Explorer Advanced registry path"
    }
    
    if (-not (Test-Path $explorerRibbonPath)) {
        New-Item -Path $explorerRibbonPath -Force | Out-Null
        Write-Host "Created Explorer Ribbon registry path"
    }
    
    if (-not (Test-Path $explorerCabinetStatePath)) {
        New-Item -Path $explorerCabinetStatePath -Force | Out-Null
        Write-Host "Created Explorer CabinetState registry path"
    }
    
    # Set File Explorer to open to "This PC" instead of Quick Access
    try {
        Write-Host "Setting LaunchTo registry value to 1 (This PC)..."
        Set-ItemProperty -Path $explorerAdvancedPath -Name "LaunchTo" -Value 1 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ File Explorer will now open to 'This PC'"
    } catch {
        Write-Host "Error setting LaunchTo: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    $Coms.Comment = "Configuring additional Explorer settings for better experience"
    $Coms.Progress = 40
    
    # Additional helpful Explorer configurations
    try {
        # Show file extensions
        Write-Host "Enabling file extensions display..."
        Set-ItemProperty -Path $explorerAdvancedPath -Name "HideFileExt" -Value 0 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ File extensions will be shown"
    } catch {
        Write-Host "Error setting HideFileExt: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    try {
        # Show hidden files and folders
        Write-Host "Enabling hidden files and folders display..."
        Set-ItemProperty -Path $explorerAdvancedPath -Name "Hidden" -Value 1 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ Hidden files and folders will be shown"
    } catch {
        Write-Host "Error setting Hidden: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    try {
        # Show full path in title bar
        Write-Host "Enabling full path in title bar..."
        Set-ItemProperty -Path $explorerCabinetStatePath -Name "FullPath" -Value 1 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ Full path will be shown in title bar"
    } catch {
        Write-Host "Error setting FullPath: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    $Coms.Progress = 60
    
    # Additional Quick Access related settings
    try {
        # Disable showing recent files in Quick Access
        Write-Host "Disabling recent files in Quick Access..."
        Set-ItemProperty -Path $explorerAdvancedPath -Name "ShowRecent" -Value 0 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ Recent files in Quick Access disabled"
    } catch {
        Write-Host "Error setting ShowRecent: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    try {
        # Disable showing frequent folders in Quick Access
        Write-Host "Disabling frequent folders in Quick Access..."
        Set-ItemProperty -Path $explorerAdvancedPath -Name "ShowFrequent" -Value 0 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ Frequent folders in Quick Access disabled"
    } catch {
        Write-Host "Error setting ShowFrequent: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    $Coms.Comment = "Applying additional Explorer optimizations"
    $Coms.Progress = 80
    
    # Additional useful Explorer settings
    try {
        # Show status bar
        Write-Host "Enabling status bar..."
        Set-ItemProperty -Path $explorerAdvancedPath -Name "ShowStatusBar" -Value 1 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ Status bar enabled"
    } catch {
        Write-Host "Error setting ShowStatusBar: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    try {
        # Enable folder size display in tips
        Write-Host "Enabling folder size in tips..."
        Set-ItemProperty -Path $explorerAdvancedPath -Name "FolderContentsInfoTip" -Value 1 -Type DWord -Force
        $changesApplied++
        Write-Host "✓ Folder size tips enabled"
    } catch {
        Write-Host "Error setting FolderContentsInfoTip: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    try {
        # Show protected operating system files (advanced users)
        if ($TaskSettings -and $TaskSettings.ContainsKey('ShowSystemFiles') -and $TaskSettings.ShowSystemFiles -eq $true) {
            Write-Host "Enabling protected system files display..."
            Set-ItemProperty -Path $explorerAdvancedPath -Name "ShowSuperHidden" -Value 1 -Type DWord -Force
            $changesApplied++
            Write-Host "✓ Protected system files will be shown"
        }
    } catch {
        Write-Host "Error setting ShowSuperHidden: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    $Coms.Progress = 90
    
    # Force restart of Explorer to apply changes immediately
    $Coms.Comment = "Restarting Windows Explorer to apply changes"
    Write-Host "Restarting Windows Explorer process to apply changes..."
    
    try {
        # Get all explorer processes
        $explorerProcesses = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
        
        if ($explorerProcesses) {
            Write-Host "Stopping Explorer processes..."
            $explorerProcesses | Stop-Process -Force
            
            # Wait a moment for processes to stop
            Start-Sleep -Seconds 2
            
            # Start Explorer again
            Write-Host "Starting Explorer..."
            Start-Process "explorer.exe"
            
            # Wait for Explorer to start
            Start-Sleep -Seconds 3
            
            Write-Host "✓ Windows Explorer restarted successfully"
        } else {
            Write-Host "Explorer process not found - changes will apply on next login"
        }
    } catch {
        Write-Host "Could not restart Explorer automatically: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "Changes will take effect after logging out and back in, or restarting the computer" -ForegroundColor Yellow
    }
    
    # Final status
    if ($changesApplied -gt 0) {
        $configurationSuccess = $true
        $Coms.Comment = "File Explorer configured successfully. Applied $changesApplied setting(s)."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
        Write-Host "File Explorer configuration completed successfully!" -ForegroundColor Green
        Write-Host "Applied $changesApplied configuration changes" -ForegroundColor Green
    } else {
        $Coms.Comment = "No Explorer configuration changes were applied."
        $Coms.Progress = 0
        $Coms.Status = "Failed"
        Write-Host "No configuration changes were successfully applied" -ForegroundColor Red
    }
    
} Catch {
    # Provide detailed error information
    $errorDetails = $_.Exception.Message
    $errorType = $_.Exception.GetType().Name
    $scriptLineNumber = $_.InvocationInfo.ScriptLineNumber
    
    $detailedError = "Explorer configuration failed - Type: $errorType, Line: $scriptLineNumber, Message: $errorDetails"
    
    Write-Host "Critical error in Explorer configuration:" -ForegroundColor Red
    Write-Host "  Error Type: $errorType" -ForegroundColor Red
    Write-Host "  Line Number: $scriptLineNumber" -ForegroundColor Red
    Write-Host "  Message: $errorDetails" -ForegroundColor Red
    
    # Set detailed error information for the UI
    $Coms.ErrorMessage = $detailedError
    $Coms.Comment = "Explorer configuration failed: $errorDetails"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    # Additional context based on common error scenarios
    if ($errorDetails -match "Access.*denied|Unauthorized|Permission") {
        $Coms.Comment = "Registry access denied - some settings may require administrator privileges"
        Write-Host "Suggestion: Try running as Administrator for full configuration" -ForegroundColor Yellow
    } elseif ($errorDetails -match "Registry|Key.*not.*found") {
        $Coms.Comment = "Registry access issue - Windows version may not support all settings"
        Write-Host "Suggestion: Some settings may not be available on this Windows version" -ForegroundColor Yellow
    } elseif ($errorDetails -match "Explorer|Process") {
        $Coms.Comment = "Explorer restart failed - settings applied but may need manual restart"
        Write-Host "Suggestion: Log out and back in, or restart computer to see all changes" -ForegroundColor Yellow
    }
    
}
