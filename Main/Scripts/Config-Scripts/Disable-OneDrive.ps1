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

$changesApplied = 0
$Coms.Status = "Running"
$Coms.Comment = "Starting OneDrive disable process"
$Coms.Progress = 1

Try {
    $Coms.Comment = "Checking OneDrive status and stopping processes"
    $Coms.Progress = 10
    
    # Check if running as administrator (recommended for complete removal)
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    Write-Host "OneDrive disable process starting..."
    Write-Host "Administrator privileges: $isAdmin"
    
    if (-not $isAdmin) {
        Write-Host "Note: Some OneDrive components may require Administrator privileges for complete removal" -ForegroundColor Yellow
    }
    
    # Stop OneDrive processes
    $Coms.Comment = "Stopping OneDrive processes"
    $Coms.Progress = 15
    
    $onedriveProcesses = @("OneDrive", "OneDriveStandaloneUpdater", "OneDriveSetup")
    $stoppedProcesses = 0
    
    foreach ($processName in $onedriveProcesses) {
        try {
            $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
            if ($processes) {
                Write-Host "Stopping $processName processes..."
                $processes | Stop-Process -Force -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 1
                
                # Verify process stopped
                $remainingProcesses = Get-Process -Name $processName -ErrorAction SilentlyContinue
                if (-not $remainingProcesses) {
                    Write-Host "✓ $processName process stopped successfully"
                    $stoppedProcesses++
                } else {
                    Write-Host "⚠ Some $processName processes may still be running" -ForegroundColor Yellow
                }
            } else {
                Write-Host "$processName process not running"
            }
        } catch {
            Write-Host "Error stopping $processName process: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    # Unregister OneDrive synchronization provider
    $Coms.Comment = "Disabling OneDrive synchronization provider"
    $Coms.Progress = 25
    
    try {
        Write-Host "Unregistering OneDrive synchronization provider..."
        
        # Find OneDrive installation paths
        $oneDrivePaths = @(
            "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe",
            "$env:ProgramFiles\Microsoft OneDrive\OneDrive.exe",
            "$env:ProgramFiles(x86)\Microsoft OneDrive\OneDrive.exe"
        )
        
        $oneDriveExePath = $null
        foreach ($path in $oneDrivePaths) {
            if (Test-Path $path) {
                $oneDriveExePath = $path
                Write-Host "Found OneDrive executable: $path"
                break
            }
        }
        
        if ($oneDriveExePath) {
            # Unregister OneDrive
            Write-Host "Unregistering OneDrive sync provider..."
            try {
                $unregisterResult = & "$oneDriveExePath" /uninstall 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "✓ OneDrive unregister command completed successfully"
                } else {
                    Write-Host "⚠ OneDrive unregister command completed with warnings: $unregisterResult" -ForegroundColor Yellow
                }
                $changesApplied++
            } catch {
                Write-Host "Error executing OneDrive unregister command: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "OneDrive executable not found in standard locations"
        }
        
    } catch {
        Write-Host "Error unregistering OneDrive: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Disable OneDrive via registry settings
    $Coms.Comment = "Disabling OneDrive via registry modifications"
    $Coms.Progress = 40
    
    # Registry paths for OneDrive configuration
    $oneDriveRegPaths = @(
        @{
            Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
            Values = @{
                "DisableFileSyncNGSC" = 1
                "DisableFileSync" = 1
                "DisableMeteredNetworkFileSync" = 1
                "DisableLibrariesDefaultSaveToOneDrive" = 1
            }
        },
        @{
            Path = "HKCU:\SOFTWARE\Microsoft\OneDrive"
            Values = @{
                "DisablePersonalSync" = 1
                "DisableBusinessSync" = 1
            }
        },
        @{
            Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
            Action = "Remove"  # Remove OneDrive from File Explorer sidebar
        }
    )
    
    foreach ($regConfig in $oneDriveRegPaths) {
        try {
            if ($regConfig.Action -eq "Remove") {
                # Remove registry key (OneDrive from sidebar)
                if (Test-Path $regConfig.Path) {
                    Remove-Item -Path $regConfig.Path -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Host "✓ Removed OneDrive from File Explorer sidebar"
                    $changesApplied++
                }
            } else {
                # Create/modify registry values
                if (-not (Test-Path $regConfig.Path)) {
                    New-Item -Path $regConfig.Path -Force | Out-Null
                    Write-Host "Created registry path: $($regConfig.Path)"
                }
                
                foreach ($valueName in $regConfig.Values.Keys) {
                    Set-ItemProperty -Path $regConfig.Path -Name $valueName -Value $regConfig.Values[$valueName] -Type DWord -Force
                    Write-Host "✓ Set $valueName = $($regConfig.Values[$valueName])"
                    $changesApplied++
                }
            }
        } catch {
            Write-Host "Error modifying registry path $($regConfig.Path): $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    # Disable OneDrive startup entries
    $Coms.Comment = "Removing OneDrive from startup"
    $Coms.Progress = 60
    
    $startupLocations = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    )
    
    foreach ($startupPath in $startupLocations) {
        try {
            $runEntries = Get-ItemProperty -Path $startupPath -ErrorAction SilentlyContinue
            if ($runEntries) {
                $oneDriveEntries = $runEntries.PSObject.Properties | Where-Object { $_.Name -like "*OneDrive*" }
                foreach ($entry in $oneDriveEntries) {
                    Remove-ItemProperty -Path $startupPath -Name $entry.Name -Force -ErrorAction SilentlyContinue
                    Write-Host "✓ Removed OneDrive startup entry: $($entry.Name)"
                    $changesApplied++
                }
            }
        } catch {
            Write-Host "Error removing OneDrive startup entries from $startupPath`: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    # Remove OneDrive from File Explorer integration
    $Coms.Comment = "Removing OneDrive File Explorer integration"
    $Coms.Progress = 75
    
    try {
        # Remove OneDrive context menu entries
        $contextMenuPaths = @(
            "HKCR:\*\shellex\ContextMenuHandlers\{CB3D0F55-BC2C-4C1A-85ED-23ED75B5106B}",
            "HKCR:\Directory\shellex\ContextMenuHandlers\{CB3D0F55-BC2C-4C1A-85ED-23ED75B5106B}",
            "HKCR:\Directory\Background\shellex\ContextMenuHandlers\{CB3D0F55-BC2C-4C1A-85ED-23ED75B5106B}"
        )
        
        foreach ($contextPath in $contextMenuPaths) {
            if (Test-Path $contextPath) {
                Remove-Item -Path $contextPath -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "✓ Removed OneDrive context menu: $contextPath"
                $changesApplied++
            }
        }
        
    } catch {
        Write-Host "Error removing OneDrive File Explorer integration: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Disable OneDrive service (if exists)
    $Coms.Comment = "Disabling OneDrive services"
    $Coms.Progress = 85
    
    $oneDriveServices = @("OneSyncSvc", "OneSyncSvc_*")
    
    foreach ($serviceName in $oneDriveServices) {
        try {
            if ($serviceName -like "*`**") {
                # Handle wildcard service names
                $services = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            } else {
                $services = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
            }
            
            if ($services) {
                foreach ($service in $services) {
                    if ($service.Status -eq "Running") {
                        Stop-Service -Name $service.Name -Force -ErrorAction SilentlyContinue
                        Write-Host "✓ Stopped service: $($service.Name)"
                    }
                    
                    Set-Service -Name $service.Name -StartupType Disabled -ErrorAction SilentlyContinue
                    Write-Host "✓ Disabled service: $($service.Name)"
                    $changesApplied++
                }
            }
        } catch {
            Write-Host "Error managing OneDrive service $serviceName`: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    # Final verification
    $Coms.Progress = 95
    
    try {
        Write-Host "Performing final verification..."
        
        # Check if OneDrive processes are still running
        $remainingProcesses = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
        if (-not $remainingProcesses) {
            Write-Host "✓ No OneDrive processes running"
        } else {
            Write-Host "⚠ Some OneDrive processes may still be running" -ForegroundColor Yellow
        }
        
        # Check registry settings
        $policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
        if (Test-Path $policyPath) {
            $disableSync = Get-ItemProperty -Path $policyPath -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
            if ($disableSync -and $disableSync.DisableFileSyncNGSC -eq 1) {
                Write-Host "✓ OneDrive sync disabled in registry"
            }
        }
        
    } catch {
        Write-Host "Could not perform complete verification: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Final status
    if ($changesApplied -gt 0) {
        $Coms.Comment = "OneDrive disabled successfully. Applied $changesApplied configuration(s). OneDrive can be re-enabled if needed."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    } else {
        $Coms.Comment = "Could not disable OneDrive - no changes were applied."
        $Coms.Progress = 0
        $Coms.Status = "Failed"
        Write-Host "No changes were successfully applied to disable OneDrive" -ForegroundColor Red
    }
    
} Catch {
    # Provide detailed error information
    $errorDetails = $_.Exception.Message
    $errorType = $_.Exception.GetType().Name
    $scriptLineNumber = $_.InvocationInfo.ScriptLineNumber
    
    $detailedError = "OneDrive disable failed - Type: $errorType, Line: $scriptLineNumber, Message: $errorDetails"
    
    Write-Host "Critical error in OneDrive disable process:" -ForegroundColor Red
    Write-Host "  Error Type: $errorType" -ForegroundColor Red
    Write-Host "  Line Number: $scriptLineNumber" -ForegroundColor Red
    Write-Host "  Message: $errorDetails" -ForegroundColor Red
    
    # Set detailed error information for the UI
    $Coms.ErrorMessage = $detailedError
    $Coms.Comment = "OneDrive disable failed: $errorDetails"
    $Coms.Progress = 0
    $Coms.Status = "Failed"

}
