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
$Coms.Comment = "Starting Microsoft Store updates"
$Coms.Progress = 10

Try {
    # Check if Microsoft Store is available
    $Coms.Comment = "Checking Microsoft Store availability"
    $Coms.Progress = 20
    
    $storeApp = Get-AppxPackage -Name "Microsoft.WindowsStore" -ErrorAction SilentlyContinue
    if (-not $storeApp) {
        throw "Microsoft Store is not installed or available on this system"
    }
    
    Write-Host "Microsoft Store found: $($storeApp.PackageFullName)" -ForegroundColor Green
    
    # Launch Microsoft Store with downloads page
    $Coms.Comment = "Launching Microsoft Store"
    $Coms.Progress = 30
    
    # Start Microsoft Store and navigate to downloads/updates page
    Start-Process "ms-windows-store://downloadsandupdates" -ErrorAction Stop
    Start-Sleep -Seconds 3
    
    # Wait for store to fully load
    $Coms.Comment = "Waiting for Microsoft Store to load"
    $Coms.Progress = 40
    
    $maxWait = 30
    $waitCount = 0
    $storeProcess = $null
    
    while ($waitCount -lt $maxWait) {
        $storeProcess = Get-Process -Name "WinStore.App" -ErrorAction SilentlyContinue
        if ($storeProcess) {
            Write-Host "Microsoft Store process detected" -ForegroundColor Green
            break
        }
        Start-Sleep -Seconds 1
        $waitCount++
    }
    
    if (-not $storeProcess) {
        throw "Microsoft Store failed to launch properly"
    }
    
    # Trigger update check using PowerShell commands
    $Coms.Comment = "Triggering update check for Store apps"
    $Coms.Progress = 50
    
    try {
        # Force refresh of Microsoft Store apps
        Write-Host "Checking for app updates..." -ForegroundColor Yellow
        
        # Use Windows Update PowerShell module if available
        if (Get-Module -ListAvailable -Name PSWindowsUpdate) {
            Import-Module PSWindowsUpdate -Force
            $storeUpdates = Get-WUList -MicrosoftUpdate -ErrorAction SilentlyContinue
            Write-Host "Found $($storeUpdates.Count) potential Microsoft updates" -ForegroundColor Cyan
        }
        
        # Alternative method: Use winget to check for store app updates
        $wingetAvailable = $false
        try {
            $wingetVersion = winget --version 2>$null
            if ($wingetVersion) {
                $wingetAvailable = $true
                Write-Host "Winget available: $wingetVersion" -ForegroundColor Green
            }
        } catch {
            Write-Host "Winget not available" -ForegroundColor Yellow
        }
        
        if ($wingetAvailable) {
            Write-Host "Checking for winget updates..." -ForegroundColor Yellow
            $wingetList = winget upgrade --source msstore --accept-source-agreements 2>$null
            Write-Host "Winget store updates check completed" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "Warning: Could not trigger automatic update check: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Monitor update progress
    $Coms.Comment = "Monitoring Microsoft Store update progress"
    $Coms.Progress = 60
    
    $monitoringTime = 0
    $maxMonitorTime = 300  # 5 minutes maximum monitoring
    $updateStatus = "Checking"
    
    Write-Host "Monitoring Microsoft Store for updates (max 5 minutes)..." -ForegroundColor Yellow
    Write-Host "Please check the Microsoft Store window for update progress" -ForegroundColor Cyan
    
    while ($monitoringTime -lt $maxMonitorTime) {
        # Check if store process is still running
        $currentStoreProcess = Get-Process -Name "WinStore.App" -ErrorAction SilentlyContinue
        
        if (-not $currentStoreProcess) {
            Write-Host "Microsoft Store closed by user" -ForegroundColor Yellow
            $updateStatus = "Store Closed"
            break
        }
        
        # Check for any download/install processes
        $downloadProcesses = Get-Process | Where-Object { 
            $_.ProcessName -like "*Download*" -or 
            $_.ProcessName -like "*Install*" -or 
            $_.ProcessName -like "*Update*" -or
            $_.ProcessName -like "*Store*" 
        } -ErrorAction SilentlyContinue
        
        if ($downloadProcesses) {
            $updateStatus = "Updates in Progress"
            $Coms.Comment = "Microsoft Store updates in progress"
        } else {
            $updateStatus = "Monitoring"
        }
        
        # Update progress based on monitoring time
        $progressPercent = 60 + (($monitoringTime / $maxMonitorTime) * 30)
        $Coms.Progress = [math]::Round($progressPercent)
        
        Start-Sleep -Seconds 5
        $monitoringTime += 5
        
        # Provide periodic updates
        if ($monitoringTime % 30 -eq 0) {
            Write-Host "Still monitoring... ($monitoringTime seconds elapsed)" -ForegroundColor Gray
        }
    }
    
    # Final status
    $Coms.Progress = 90
    
    if ($monitoringTime -ge $maxMonitorTime) {
        $Coms.Comment = "Monitoring completed - check Microsoft Store manually for final status"
        Write-Host "Monitoring timeout reached. Please check Microsoft Store manually for update status." -ForegroundColor Yellow
    } else {
        $Coms.Comment = "Microsoft Store update process completed"
        Write-Host "Microsoft Store update monitoring completed." -ForegroundColor Green
    }
    
    # Provide final instructions
    Write-Host "`nInstructions:" -ForegroundColor Cyan
    Write-Host "1. Check the Microsoft Store Downloads page for any pending updates" -ForegroundColor White
    Write-Host "2. Updates will download and install automatically if available" -ForegroundColor White
    Write-Host "3. Some apps may require restart after updating" -ForegroundColor White
    
    $Coms.Progress = 100
    $Coms.Status = "Completed"
    
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Comment = "Failed to update Microsoft Store apps"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You can manually open Microsoft Store and check for updates" -ForegroundColor Yellow
}