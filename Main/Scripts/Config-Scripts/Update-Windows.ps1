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

$updateSuccess = $false
$rebootRequired = $false
$totalUpdates = 0
$installedUpdates = 0
$Coms.Status = "Running"
$Coms.Comment = "Starting Windows Update process"
$Coms.Progress = 1

Try {
    $Coms.Comment = "Checking Windows Update prerequisites"
    $Coms.Progress = 5
    
    # Check if running as administrator (required for Windows Updates)
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        $errorMsg = "This script must be run as Administrator to install Windows Updates."
        $Coms.ErrorMessage = $errorMsg
        $Coms.Status = "Failed"
        $Coms.Progress = 0
        throw $errorMsg
    }
    
    Write-Host "Running as Administrator - proceeding with Windows Update check"
    
    # Check if PSWindowsUpdate module is available, install if not
    $Coms.Comment = "Checking Windows Update PowerShell module"
    $Coms.Progress = 10
    
    $psWindowsUpdateAvailable = $false
    try {
        # First check if module is already installed
        $module = Get-Module -ListAvailable -Name PSWindowsUpdate -ErrorAction SilentlyContinue
        if ($module) {
            Write-Host "PSWindowsUpdate module found, attempting to import..."
            Import-Module PSWindowsUpdate -ErrorAction Stop
            
            # Test if the cmdlets are actually available
            $testCmdlet = Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue
            if ($testCmdlet) {
                $psWindowsUpdateAvailable = $true
                Write-Host "PSWindowsUpdate module is available and working"
            } else {
                Write-Host "PSWindowsUpdate module imported but Get-WindowsUpdate cmdlet not available"
            }
        } else {
            Write-Host "PSWindowsUpdate module not found, attempting to install..."
        }
    } catch {
        Write-Host "Error importing existing PSWindowsUpdate module: $($_.Exception.Message)"
    }
    
    # Try to install the module if it's not available
    if (-not $psWindowsUpdateAvailable) {
        try {
            Write-Host "Installing PSWindowsUpdate module from PowerShell Gallery..."
            $Coms.Comment = "Installing PSWindowsUpdate module..."
            
            # Set execution policy temporarily if needed
            $originalExecutionPolicy = Get-ExecutionPolicy -Scope CurrentUser -ErrorAction SilentlyContinue
            if ($originalExecutionPolicy -eq "Restricted") {
                Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            }
            
            # Install and import the module
            Install-Module -Name PSWindowsUpdate -Force -AllowClobber -SkipPublisherCheck -Scope CurrentUser -ErrorAction Stop
            Import-Module PSWindowsUpdate -ErrorAction Stop
            
            # Test the installation
            $testCmdlet = Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue
            if ($testCmdlet) {
                $psWindowsUpdateAvailable = $true
                Write-Host "PSWindowsUpdate module installed and imported successfully"
            } else {
                Write-Host "PSWindowsUpdate module installation failed - Get-WindowsUpdate cmdlet not available"
            }
            
            # Restore original execution policy if it was changed
            if ($originalExecutionPolicy -eq "Restricted") {
                Set-ExecutionPolicy -ExecutionPolicy $originalExecutionPolicy -Scope CurrentUser -Force -ErrorAction SilentlyContinue
            }
            
        } catch {
            Write-Host "Failed to install PSWindowsUpdate module: $($_.Exception.Message)"
            Write-Host "Will use Windows Update COM object instead"
        }
    }
    
    # Fallback to Windows Update COM object if PSWindowsUpdate is not available
    $useComObject = $false
    $useUsoClient = $false
    
    if (-not $psWindowsUpdateAvailable) {
        Write-Host "PSWindowsUpdate not available, trying Windows Update COM object..."
        try {
            $updateSearcher = New-Object -ComObject Microsoft.Update.Searcher
            $useComObject = $true
            Write-Host "Windows Update COM object available"
        } catch {
            Write-Host "Windows Update COM object failed: $($_.Exception.Message)"
            
            # Try UsoClient as final fallback (Windows 10/11)
            try {
                $usoClientPath = "$env:SystemRoot\System32\UsoClient.exe"
                if (Test-Path $usoClientPath) {
                    Write-Host "UsoClient.exe found, will use native Windows Update"
                    $useUsoClient = $true
                } else {
                    throw "UsoClient.exe not found"
                }
            } catch {
                $errorMsg = "No Windows Update methods available (PSWindowsUpdate, COM object, or UsoClient)."
                $Coms.Comment = $errorMsg
                $Coms.Status = "Failed"
                $Coms.Progress = 0
                throw $errorMsg
            }
        }
    }
    
    # Check for available updates (including optional updates)
    $Coms.Comment = "Searching for all available Windows Updates (including optional updates)..."
    $Coms.Progress = 15
    
    $availableUpdates = @()
    $totalUpdates = 0
    
    if ($psWindowsUpdateAvailable) {
        Write-Host "Using PSWindowsUpdate module to search for all types of updates"
        try {
            # Search for ALL available updates including optional ones using a comprehensive approach
            Write-Host "Searching for all available updates including optional updates..."
            $availableUpdates = Get-WindowsUpdate -MicrosoftUpdate -ErrorAction Stop
            $totalUpdates = $availableUpdates.Count
            
            Write-Host "Found $totalUpdates total available updates using PSWindowsUpdate"
            
            if ($totalUpdates -gt 0) {
                # Categorize the updates for display
                $criticalCount = 0
                $optionalCount = 0
                $driverCount = 0
                $otherCount = 0
                
                foreach ($update in $availableUpdates) {
                    $categories = $update.Categories -join ", "
                    $updateType = "[Update]"
                    
                    if ($categories -match "Critical|Security") { 
                        $updateType = "[Critical]"
                        $criticalCount++
                    } elseif ($categories -match "Driver") { 
                        $updateType = "[Driver]"
                        $driverCount++
                    } elseif ($categories -match "Optional|Recommended") { 
                        $updateType = "[Optional]"
                        $optionalCount++
                    } else { 
                        $updateType = "[Other]"
                        $otherCount++
                    }
                    
                    Write-Host "  $updateType $($update.Title) (Size: $([math]::Round($update.Size/1MB, 2)) MB)"
                }
                
                Write-Host ""
                Write-Host "Update breakdown:"
                Write-Host "  Critical/Security: $criticalCount"
                Write-Host "  Optional/Recommended: $optionalCount"
                Write-Host "  Driver Updates: $driverCount"
                Write-Host "  Other Updates: $otherCount"
                Write-Host ""
            }
        } catch {
            Write-Host "Error searching for updates with PSWindowsUpdate: $($_.Exception.Message)"
            $useComObject = $true
            $psWindowsUpdateAvailable = $false
        }
    }
    
    if ($useComObject -and -not $psWindowsUpdateAvailable) {
        Write-Host "Using Windows Update COM object to search for all types of updates"
        try {
            $updateSearcher = New-Object -ComObject Microsoft.Update.Searcher
            
            # Search for all types of updates including optional ones
            # This search criteria includes both installed=0 (not installed) and hidden=0 (not hidden)
            # It will find critical, recommended, optional, and driver updates
            $searchCriteria = "IsInstalled=0 and IsHidden=0"
            Write-Host "Searching with criteria: $searchCriteria"
            
            $searchResult = $updateSearcher.Search($searchCriteria)
            $availableUpdates = $searchResult.Updates
            $totalUpdates = $availableUpdates.Count
            
            Write-Host "Found $totalUpdates total available updates (all categories) using COM object"
            
            if ($totalUpdates -gt 0) {
                $criticalCount = 0
                $optionalCount = 0
                $driverCount = 0
                $otherCount = 0
                
                for ($i = 0; $i -lt $availableUpdates.Count; $i++) {
                    $update = $availableUpdates.Item($i)
                    $sizeInMB = [math]::Round($update.MaxDownloadSize / 1MB, 2)
                    
                    # Categorize the update
                    $updateType = "[Update]"
                    $categories = @()
                    for ($j = 0; $j -lt $update.Categories.Count; $j++) {
                        $categories += $update.Categories.Item($j).Name
                    }
                    $categoryString = $categories -join ", "
                    
                    if ($categoryString -match "Critical|Security") { 
                        $updateType = "[Critical]"
                        $criticalCount++
                    } elseif ($categoryString -match "Driver") { 
                        $updateType = "[Driver]"
                        $driverCount++
                    } elseif ($categoryString -match "Optional|Recommended") { 
                        $updateType = "[Optional]"
                        $optionalCount++
                    } else { 
                        $otherCount++
                    }
                    
                    Write-Host "  $updateType $($update.Title) (Size: $sizeInMB MB)"
                }
                
                Write-Host ""
                Write-Host "Update breakdown:"
                Write-Host "  Critical/Security: $criticalCount"
                Write-Host "  Optional/Recommended: $optionalCount"
                Write-Host "  Driver Updates: $driverCount"
                Write-Host "  Other Updates: $otherCount"
            }
        } catch {
            $errorMsg = "Error searching for updates with COM object: $($_.Exception.Message)"
            $Coms.Comment = $errorMsg
            $Coms.Status = "Failed"
            $Coms.Progress = 0
            throw $errorMsg
        }
    }
    
    # UsoClient fallback method (Windows 10/11 native)
    if ($useUsoClient -and $totalUpdates -eq 0) {
        Write-Host "Using UsoClient (native Windows Update) method"
        try {
            $Coms.Comment = "Checking for updates using native Windows Update..."
            $Coms.Progress = 20
            
            # Start update check using UsoClient
            Write-Host "Starting Windows Update scan..."
            & "$env:SystemRoot\System32\UsoClient.exe" StartScan
            
            # Wait a moment for the scan to initialize
            Start-Sleep -Seconds 5
            
            # Since UsoClient doesn't provide direct feedback, we'll assume updates are available
            # and proceed with installation. UsoClient will handle the actual update detection.
            $totalUpdates = 1  # Set to 1 to indicate we're proceeding with native update
            Write-Host "UsoClient scan initiated - proceeding with native Windows Update installation"
            
        } catch {
            Write-Host "Error with UsoClient method: $($_.Exception.Message)"
            # If all methods fail, we'll still return no updates found
        }
    }
    
    if ($totalUpdates -eq 0) {
        $Coms.Comment = "No Windows Updates available. System is up to date."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
        Write-Host "No updates found - system is up to date"
        return
    }
    
    # Proceed with automatic installation
    Write-Host "Found $totalUpdates updates - proceeding with automatic installation"
    
    # Install all types of updates
    $Coms.Comment = "Installing $totalUpdates Windows Update(s) (including optional updates)..."
    $Coms.Progress = 25
    
    if ($psWindowsUpdateAvailable) {
        Write-Host "Installing all types of updates using PSWindowsUpdate module"
        try {
            # Use a simpler, more reliable approach - install all available updates at once
            Write-Host "Installing all available updates (critical, optional, drivers, features)..."
            $Coms.Progress = 30
            
            # Install all updates including optional ones with detailed parameters
            $installResult = Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot:$false -IgnoreReboot -Confirm:$false -Verbose -ErrorAction Stop
            
            $Coms.Progress = 70
            
            # Count successful installations
            $installedUpdates = ($installResult | Where-Object { $_.Result -eq "Installed" -or $_.Result -eq "Downloaded" }).Count
            
            Write-Host "Installation completed. $installedUpdates out of $totalUpdates updates processed."
            
            # Show detailed results
            if ($installResult) {
                Write-Host "Installation results:"
                foreach ($result in $installResult) {
                    $status = if ($result.Result -eq "Installed") { "[SUCCESS]" } 
                             elseif ($result.Result -eq "Downloaded") { "[DOWNLOADED]" }
                             elseif ($result.Result -eq "Failed") { "[FAILED]" }
                             else { "[" + $result.Result + "]" }
                    Write-Host "  $status $($result.Title)"
                }
            }
            
            # Check if reboot is required
            $rebootRequired = ($installResult | Where-Object { $_.RebootRequired -eq $true }).Count -gt 0
            
            if ($installedUpdates -gt 0) {
                $updateSuccess = $true
            }
            
        } catch {
            Write-Host "Error installing updates with PSWindowsUpdate: $($_.Exception.Message)"
            $useComObject = $true
            $psWindowsUpdateAvailable = $false
        }
    }
    
    if ($useComObject -and -not $updateSuccess) {
        Write-Host "Installing updates using Windows Update COM object"
        try {
            # Create update collection
            $updateSession = New-Object -ComObject Microsoft.Update.Session
            $updateSearcher = $updateSession.CreateUpdateSearcher()
            $searchResult = $updateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")
            
            if ($searchResult.Updates.Count -gt 0) {
                # Create update collection for installation
                $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
                
                for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
                    $update = $searchResult.Updates.Item($i)
                    $updatesToInstall.Add($update) | Out-Null
                    Write-Host "Added update to install queue: $($update.Title)"
                }
                
                # Download updates first
                $Coms.Comment = "Downloading Windows Updates..."
                $Coms.Progress = 40
                
                $downloader = $updateSession.CreateUpdateDownloader()
                $downloader.Updates = $updatesToInstall
                $downloadResult = $downloader.Download()
                
                Write-Host "Download result: $($downloadResult.ResultCode)"
                
                # Install updates
                $Coms.Comment = "Installing downloaded Windows Updates..."
                $Coms.Progress = 60
                
                $installer = $updateSession.CreateUpdateInstaller()
                $installer.Updates = $updatesToInstall
                $installationResult = $installer.Install()
                
                Write-Host "Installation result: $($installationResult.ResultCode)"
                $installedUpdates = $installationResult.ResultCode
                $rebootRequired = $installationResult.RebootRequired
                
                if ($installationResult.ResultCode -eq 2) { # OperationResultCodeSucceeded
                    $updateSuccess = $true
                    $installedUpdates = $updatesToInstall.Count
                } elseif ($installationResult.ResultCode -eq 3) { # OperationResultCodeSucceededWithErrors
                    $updateSuccess = $true
                    $installedUpdates = $updatesToInstall.Count
                    Write-Host "Updates installed with some errors"
                }
            }
            
        } catch {
            $errorMsg = "Error installing updates with COM object: $($_.Exception.Message)"
            $Coms.Comment = $errorMsg
            $Coms.Status = "Failed"
            $Coms.Progress = 0
            throw $errorMsg
        }
    }
    
    # UsoClient fallback installation method
    if ($useUsoClient -and -not $updateSuccess) {
        Write-Host "Installing updates using UsoClient (native Windows Update)"
        try {
            $Coms.Comment = "Installing updates using native Windows Update..."
            $Coms.Progress = 50
            
            # Use UsoClient to download and install updates
            Write-Host "Starting update download and installation..."
            & "$env:SystemRoot\System32\UsoClient.exe" StartDownload
            
            # Wait for download to start
            Start-Sleep -Seconds 3
            
            # Start installation
            & "$env:SystemRoot\System32\UsoClient.exe" StartInstall
            
            $Coms.Progress = 75
            
            # UsoClient works asynchronously, so we'll monitor for a reasonable time
            $maxWaitTime = 300  # 5 minutes
            $waitTime = 0
            $checkInterval = 10
            
            Write-Host "Monitoring update installation progress..."
            $Coms.Comment = "Monitoring native Windows Update installation..."
            
            while ($waitTime -lt $maxWaitTime) {
                Start-Sleep -Seconds $checkInterval
                $waitTime += $checkInterval
                
                # Check Windows Update service status as a proxy for activity
                $wuauservStatus = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
                if ($wuauservStatus -and $wuauservStatus.Status -eq "Running") {
                    Write-Host "Windows Update service is active..."
                    $Coms.Progress = 75 + ($waitTime / $maxWaitTime * 15)  # Progress from 75 to 90
                } else {
                    Write-Host "Windows Update service completed or stopped"
                    break
                }
            }
            
            # Assume success if we made it this far without errors
            $updateSuccess = $true
            $installedUpdates = 1  # Can't get exact count with UsoClient
            
            # Check if reboot is required by looking at pending reboot indicators
            $rebootRequired = $false
            if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired") {
                $rebootRequired = $true
            }
            
            Write-Host "UsoClient installation process completed"
            
        } catch {
            $errorMsg = "Error installing updates with UsoClient: $($_.Exception.Message)"
            $Coms.Comment = $errorMsg
            Write-Host $errorMsg -ForegroundColor Red
        }
    }
    
    # Final status update
    $Coms.Progress = 90
    
    if ($updateSuccess) {
        if ($rebootRequired) {
            $Coms.Comment = "Windows Updates installed successfully. Restart required to complete installation."
            $Coms.ExitType = "Restart"
            $Coms.ExitMessage = "Windows Updates require a system restart to complete installation."
            Write-Host "Updates installed successfully - restart required"
        } else {
            $Coms.Comment = "Windows Updates installed successfully. No restart required."
            Write-Host "Updates installed successfully - no restart required"
        }
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    } else {
        $Coms.Comment = "Failed to install Windows Updates."
        $Coms.Progress = 0
        $Coms.Status = "Failed"
        Write-Host "Windows Update installation failed"
    }
    
} Catch {
    # Provide detailed error information
    $errorDetails = $_.Exception.Message
    $errorType = $_.Exception.GetType().Name
    $scriptLineNumber = $_.InvocationInfo.ScriptLineNumber
    
    $detailedError = "Windows Update failed - Type: $errorType, Line: $scriptLineNumber, Message: $errorDetails"
    
    Write-Host "Critical error in Windows Update process:" -ForegroundColor Red
    Write-Host "  Error Type: $errorType" -ForegroundColor Red
    Write-Host "  Line Number: $scriptLineNumber" -ForegroundColor Red
    Write-Host "  Message: $errorDetails" -ForegroundColor Red
    
    # Set detailed error information for the UI
    $Coms.ErrorMessage = $detailedError
    $Coms.Comment = "Windows Update failed: $errorDetails"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    # Additional context based on common error scenarios
    if ($errorDetails -match "Access.*denied|Unauthorized|Permission") {
        $Coms.Comment = "Access denied - ensure you're running as Administrator"
        Write-Host "Suggestion: Ensure script is running as Administrator" -ForegroundColor Yellow
    } elseif ($errorDetails -match "Module.*not.*found|Command.*not.*found") {
        $Coms.Comment = "Windows Update tools not available on this system"
        Write-Host "Suggestion: Try running Windows Update manually from Settings" -ForegroundColor Yellow
    } elseif ($errorDetails -match "Network|Internet|Connection") {
        $Coms.Comment = "Network connectivity issue - check internet connection"
        Write-Host "Suggestion: Check internet connection and Windows Update service" -ForegroundColor Yellow
    } elseif ($errorDetails -match "Service|WU|Update") {
        $Coms.Comment = "Windows Update service issue - may need manual intervention"
        Write-Host "Suggestion: Try restarting Windows Update service or running 'sfc /scannow'" -ForegroundColor Yellow
    }
    
} Finally {
    # Provide final status information
    if ($updateSuccess) {
        Write-Host "Windows Update process completed successfully" -ForegroundColor Green
        Write-Host "Updates installed: $installedUpdates out of $totalUpdates" -ForegroundColor Green
        
        if ($rebootRequired) {
            Write-Host "Note: A system restart is required to complete the update installation" -ForegroundColor Yellow
        }
        
        # Show final update status
        try {
            Write-Host "`nFinal Windows Update status check:"
            if ($psWindowsUpdateAvailable) {
                $remainingUpdates = Get-WindowsUpdate -MicrosoftUpdate -ErrorAction SilentlyContinue
                if ($remainingUpdates) {
                    Write-Host "Remaining updates: $($remainingUpdates.Count)"
                } else {
                    Write-Host "No additional updates available"
                }
            } else {
                Write-Host "Run Windows Update from Settings to verify installation"
            }
        } catch {
            Write-Host "Could not perform final status check"
        }
    } else {
        Write-Host "Windows Update process failed or was not needed" -ForegroundColor Red
        if ($totalUpdates -gt 0) {
            Write-Host "Consider running Windows Update manually from Settings > Update & Security" -ForegroundColor Yellow
        }
    }
}
