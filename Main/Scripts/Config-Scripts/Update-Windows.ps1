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
        Import-Module PSWindowsUpdate -ErrorAction Stop
        $psWindowsUpdateAvailable = $true
        Write-Host "PSWindowsUpdate module is already available"
    } catch {
        Write-Host "PSWindowsUpdate module not found, attempting to install..."
        
        try {
            # Install PSWindowsUpdate module
            $Coms.Comment = "Installing PSWindowsUpdate module..."
            Install-Module -Name PSWindowsUpdate -Force -AllowClobber -SkipPublisherCheck -ErrorAction Stop
            Import-Module PSWindowsUpdate -ErrorAction Stop
            $psWindowsUpdateAvailable = $true
            Write-Host "PSWindowsUpdate module installed and imported successfully"
        } catch {
            Write-Host "Failed to install PSWindowsUpdate module: $($_.Exception.Message)"
        }
    }
    
    # Fallback to Windows Update COM object if PSWindowsUpdate is not available
    $useComObject = $false
    if (-not $psWindowsUpdateAvailable) {
        Write-Host "Attempting to use Windows Update COM object as fallback"
        try {
            $updateSearcher = New-Object -ComObject Microsoft.Update.Searcher
            $useComObject = $true
            Write-Host "Windows Update COM object available"
        } catch {
            $errorMsg = "Neither PSWindowsUpdate module nor Windows Update COM object is available."
            $Coms.Comment = $errorMsg
            $Coms.Status = "Failed"
            $Coms.Progress = 0
            throw $errorMsg
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
            # Search for all available updates including optional ones
            Write-Host "Searching for critical and important updates..."
            $criticalUpdates = Get-WindowsUpdate -MicrosoftUpdate -Category "Critical Updates", "Security Updates", "Update Rollups", "Updates" -ErrorAction Stop
            
            Write-Host "Searching for optional and recommended updates..."
            $optionalUpdates = Get-WindowsUpdate -MicrosoftUpdate -Category "Optional Updates", "Recommended Updates" -ErrorAction SilentlyContinue
            
            Write-Host "Searching for driver updates..."
            $driverUpdates = Get-WindowsUpdate -MicrosoftUpdate -Category "Drivers" -ErrorAction SilentlyContinue
            
            Write-Host "Searching for feature updates..."
            $featureUpdates = Get-WindowsUpdate -MicrosoftUpdate -Category "Feature Packs" -ErrorAction SilentlyContinue
            
            # Combine all update types
            $allUpdates = @()
            if ($criticalUpdates) { $allUpdates += $criticalUpdates }
            if ($optionalUpdates) { $allUpdates += $optionalUpdates }
            if ($driverUpdates) { $allUpdates += $driverUpdates }
            if ($featureUpdates) { $allUpdates += $featureUpdates }
            
            # Remove duplicates based on KB number if any
            $availableUpdates = $allUpdates | Sort-Object Title -Unique
            $totalUpdates = $availableUpdates.Count
            
            Write-Host "Found $totalUpdates total available updates (all categories) using PSWindowsUpdate"
            
            if ($totalUpdates -gt 0) {
                $criticalCount = if ($criticalUpdates) { $criticalUpdates.Count } else { 0 }
                $optionalCount = if ($optionalUpdates) { $optionalUpdates.Count } else { 0 }
                $driverCount = if ($driverUpdates) { $driverUpdates.Count } else { 0 }
                $featureCount = if ($featureUpdates) { $featureUpdates.Count } else { 0 }
                
                Write-Host "Update breakdown:"
                Write-Host "  Critical/Security: $criticalCount"
                Write-Host "  Optional/Recommended: $optionalCount"
                Write-Host "  Driver Updates: $driverCount"
                Write-Host "  Feature Updates: $featureCount"
                Write-Host ""
                
                foreach ($update in $availableUpdates) {
                    $updateType = if ($update.Categories -match "Critical|Security") { "[Critical]" } 
                                  elseif ($update.Categories -match "Driver") { "[Driver]" }
                                  elseif ($update.Categories -match "Optional|Recommended") { "[Optional]" }
                                  elseif ($update.Categories -match "Feature") { "[Feature]" }
                                  else { "[Update]" }
                    Write-Host "  $updateType $($update.Title) (Size: $([math]::Round($update.Size/1MB, 2)) MB)"
                }
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
            # Install all available updates (critical, optional, drivers, etc.)
            Write-Host "Installing critical and security updates..."
            $criticalInstallResult = @()
            if ($criticalUpdates -and $criticalUpdates.Count -gt 0) {
                $criticalInstallResult = Install-WindowsUpdate -KBArticleID ($criticalUpdates | ForEach-Object { $_.KBArticleIDs }) -AcceptAll -AutoReboot:$false -ErrorAction SilentlyContinue
            }
            
            Write-Host "Installing optional and recommended updates..."
            $optionalInstallResult = @()
            if ($optionalUpdates -and $optionalUpdates.Count -gt 0) {
                $optionalInstallResult = Install-WindowsUpdate -KBArticleID ($optionalUpdates | ForEach-Object { $_.KBArticleIDs }) -AcceptAll -AutoReboot:$false -ErrorAction SilentlyContinue
            }
            
            Write-Host "Installing driver updates..."
            $driverInstallResult = @()
            if ($driverUpdates -and $driverUpdates.Count -gt 0) {
                $driverInstallResult = Install-WindowsUpdate -KBArticleID ($driverUpdates | ForEach-Object { $_.KBArticleIDs }) -AcceptAll -AutoReboot:$false -ErrorAction SilentlyContinue
            }
            
            Write-Host "Installing feature updates..."
            $featureInstallResult = @()
            if ($featureUpdates -and $featureUpdates.Count -gt 0) {
                $featureInstallResult = Install-WindowsUpdate -KBArticleID ($featureUpdates | ForEach-Object { $_.KBArticleIDs }) -AcceptAll -AutoReboot:$false -ErrorAction SilentlyContinue
            }
            
            # Combine all installation results
            $installResult = @()
            if ($criticalInstallResult) { $installResult += $criticalInstallResult }
            if ($optionalInstallResult) { $installResult += $optionalInstallResult }
            if ($driverInstallResult) { $installResult += $driverInstallResult }
            if ($featureInstallResult) { $installResult += $featureInstallResult }
            
            # Count successful installations
            $installedUpdates = ($installResult | Where-Object { $_.Result -eq "Installed" -or $_.Result -eq "Downloaded" }).Count
            
            Write-Host "Installation completed. $installedUpdates out of $totalUpdates updates processed."
            
            # Show breakdown of installed updates
            $installedCritical = ($criticalInstallResult | Where-Object { $_.Result -eq "Installed" }).Count
            $installedOptional = ($optionalInstallResult | Where-Object { $_.Result -eq "Installed" }).Count
            $installedDrivers = ($driverInstallResult | Where-Object { $_.Result -eq "Installed" }).Count
            $installedFeatures = ($featureInstallResult | Where-Object { $_.Result -eq "Installed" }).Count
            
            Write-Host "Installation breakdown:"
            Write-Host "  Critical/Security installed: $installedCritical"
            Write-Host "  Optional/Recommended installed: $installedOptional"
            Write-Host "  Driver updates installed: $installedDrivers"
            Write-Host "  Feature updates installed: $installedFeatures"
            
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
