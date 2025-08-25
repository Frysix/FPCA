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

$bitLockerFound = $false
$disableSuccess = $false
$requiresRestart = $false
$Coms.Status = "Running"
$Coms.Comment = "Starting BitLocker Removal Script"
$Coms.Progress = 1

Try {
    $Coms.Comment = "Checking BitLocker status on system drives"
    $Coms.Progress = 10
    
    # Check if running as administrator (required for BitLocker operations)
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        $errorMsg = "This script must be run as Administrator to manage BitLocker encryption."
        $Coms.Comment = $errorMsg
        $Coms.Status = "Failed"
        $Coms.Progress = 0
        throw $errorMsg
    }
    
    Write-Host "Running as Administrator - proceeding with BitLocker check"
    
    # Check if BitLocker PowerShell module is available
    $Coms.Comment = "Checking BitLocker PowerShell module availability"
    $Coms.Progress = 12
    
    $bitLockerModuleAvailable = $false
    try {
        Import-Module BitLocker -ErrorAction Stop
        $bitLockerModuleAvailable = $true
        Write-Host "BitLocker PowerShell module loaded successfully"
    } catch {
        Write-Host "BitLocker PowerShell module not available: $($_.Exception.Message)"
        Write-Host "Will use command-line tools instead"
    }
    
    # Check if BitLocker feature is available on this system
    $Coms.Comment = "Checking if BitLocker feature is available"
    $Coms.Progress = 15
    
    $bitLockerFeatureAvailable = $false
    try {
        $bitLockerFeature = Get-WindowsOptionalFeature -Online -FeatureName "BitLocker" -ErrorAction SilentlyContinue
        if ($bitLockerFeature) {
            $bitLockerFeatureAvailable = $true
            Write-Host "BitLocker feature status: $($bitLockerFeature.State)"
            if ($bitLockerFeature.State -eq "Disabled") {
                $Coms.Comment = "BitLocker feature is already disabled. Checking for encrypted volumes anyway."
                Write-Host "BitLocker feature disabled, but checking for encrypted volumes"
            }
        } else {
            Write-Host "BitLocker feature not found via Get-WindowsOptionalFeature"
        }
    } catch {
        Write-Host "Unable to check BitLocker feature status: $($_.Exception.Message)"
    }
    
    # Additional check using manage-bde to verify BitLocker is available
    $manageBdeAvailable = $false
    try {
        $testResult = & manage-bde.exe 2>$null
        if ($LASTEXITCODE -eq 0 -or $testResult) {
            $manageBdeAvailable = $true
            Write-Host "manage-bde.exe is available"
        } else {
            Write-Host "manage-bde.exe not available or failed"
        }
    } catch {
        Write-Host "Error testing manage-bde.exe: $($_.Exception.Message)"
    }
    
    # If neither method is available, we can't proceed
    if (-not $bitLockerModuleAvailable -and -not $manageBdeAvailable) {
        $errorMsg = "BitLocker tools are not available on this system. Cannot check or disable BitLocker."
        $Coms.Comment = $errorMsg
        $Coms.Status = "Failed"
        $Coms.Progress = 0
        Write-Host $errorMsg -ForegroundColor Red
        return
    }
    
    # Get all BitLocker volumes
    $Coms.Comment = "Scanning for BitLocker encrypted volumes"
    $Coms.Progress = 20
    
    $bitLockerVolumes = $null
    $detectionMethod = "none"
    
    # Try PowerShell method first if module is available
    if ($bitLockerModuleAvailable) {
        try {
            Write-Host "Trying PowerShell Get-BitLockerVolume method"
            $bitLockerVolumes = Get-BitLockerVolume -ErrorAction Stop
            if ($bitLockerVolumes) {
                $detectionMethod = "powershell"
                Write-Host "Found $($bitLockerVolumes.Count) volume(s) using PowerShell method"
                foreach ($vol in $bitLockerVolumes) {
                    Write-Host "  Volume $($vol.MountPoint): Protection=$($vol.ProtectionStatus), Encryption=$($vol.EncryptionPercentage)%"
                    if ($vol.ProtectionStatus -eq "On" -or $vol.EncryptionPercentage -gt 0) {
                        $bitLockerFound = $true
                    }
                }
            } else {
                Write-Host "No BitLocker volumes found using PowerShell method"
            }
        } catch {
            Write-Host "PowerShell method failed: $($_.Exception.Message)"
            $bitLockerVolumes = $null
        }
    }
    
    # Try command-line method if PowerShell failed or no volumes found
    if (-not $bitLockerFound -and $manageBdeAvailable) {
        try {
            Write-Host "Trying manage-bde command-line method"
            $manageBdeOutput = & manage-bde.exe -status 2>&1
            $manageBdeExitCode = $LASTEXITCODE
            
            Write-Host "manage-bde exit code: $manageBdeExitCode"
            
            if ($manageBdeOutput) {
                $outputString = $manageBdeOutput -join "`n"
                Write-Host "manage-bde output:"
                Write-Host $outputString
                
                # Look for signs of BitLocker encryption
                if ($outputString -match "Protection On|Encryption in Progress|Fully Encrypted|Used Space Only Encrypted") {
                    Write-Host "BitLocker encryption detected via manage-bde"
                    $bitLockerFound = $true
                    $detectionMethod = "command-line"
                } elseif ($outputString -match "Protection Off.*Fully Decrypted") {
                    Write-Host "BitLocker is present but fully decrypted and protection is off"
                } elseif ($outputString -match "BitLocker Drive Encryption is not enabled") {
                    Write-Host "BitLocker is not enabled on any drives"
                } else {
                    Write-Host "Unable to determine BitLocker status from output"
                }
            } else {
                Write-Host "No output from manage-bde command"
            }
        } catch {
            Write-Host "Command-line method failed: $($_.Exception.Message)"
        }
    }
    
    Write-Host "Detection summary: BitLocker found = $bitLockerFound, Method = $detectionMethod"
    
    if (-not $bitLockerFound) {
        $Coms.Comment = "No BitLocker encrypted volumes found. No action needed."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
        Write-Host "No BitLocker encryption detected - task completed"
        return
    }
    
    # Process each BitLocker volume found
    $Coms.Comment = "Processing BitLocker encrypted volumes"
    $Coms.Progress = 30
    
    $volumesProcessed = 0
    $totalOperations = 0
    
    # Count total operations needed
    if ($bitLockerVolumes) {
        foreach ($volume in $bitLockerVolumes) {
            if ($volume.ProtectionStatus -eq "On" -or $volume.EncryptionPercentage -gt 0) {
                $totalOperations++
            }
        }
    } else {
        $totalOperations = 1 # For command-line method
    }
    
    Write-Host "Total BitLocker operations needed: $totalOperations"
    
    if ($bitLockerVolumes) {
        foreach ($volume in $bitLockerVolumes) {
            $driveLetter = $volume.MountPoint
            $protectionStatus = $volume.ProtectionStatus
            $encryptionPercentage = $volume.EncryptionPercentage
            
            Write-Host "Processing drive $driveLetter - Protection: $protectionStatus, Encryption: $encryptionPercentage%"
            
            if ($protectionStatus -eq "On" -or $encryptionPercentage -gt 0) {
                $volumesProcessed++
                $progressPercent = 30 + (($volumesProcessed / $totalOperations) * 50)
                $Coms.Progress = [math]::Min(80, $progressPercent)
                $Coms.Comment = "Disabling BitLocker on drive $driveLetter ($volumesProcessed/$totalOperations)"
                
                try {
                    # Turn off BitLocker protection first
                    if ($protectionStatus -eq "On") {
                        Write-Host "Turning off BitLocker protection for drive $driveLetter"
                        Disable-BitLocker -MountPoint $driveLetter -ErrorAction Stop
                        Write-Host "BitLocker protection disabled for drive $driveLetter"
                        
                        # Wait a moment for the operation to take effect
                        Start-Sleep -Seconds 2
                    }
                    
                    # If the drive is encrypted, decrypt it
                    if ($encryptionPercentage -gt 0) {
                        Write-Host "Starting decryption for drive $driveLetter (currently $encryptionPercentage% encrypted)"
                        Disable-BitLocker -MountPoint $driveLetter -ErrorAction Stop
                        
                        # Note: Decryption is asynchronous and may take time
                        $requiresRestart = $true
                        Write-Host "Decryption initiated for drive $driveLetter - this will continue in the background"
                    }
                    
                    $disableSuccess = $true
                    
                } catch {
                    $errorMsg = $_.Exception.Message
                    Write-Host "Error disabling BitLocker on drive $driveLetter`: $errorMsg" -ForegroundColor Red
                    
                    # Try command-line method as fallback
                    try {
                        Write-Host "Trying command-line method for drive $driveLetter"
                        
                        # First try to turn off protection
                        $result1 = & manage-bde.exe -protectors -disable $driveLetter 2>&1
                        $exitCode1 = $LASTEXITCODE
                        Write-Host "Protection disable result: $result1 (Exit code: $exitCode1)"
                        
                        # Then try to turn off encryption
                        $result2 = & manage-bde.exe -off $driveLetter 2>&1
                        $exitCode2 = $LASTEXITCODE
                        Write-Host "Encryption disable result: $result2 (Exit code: $exitCode2)"
                        
                        if ($exitCode1 -eq 0 -or $exitCode2 -eq 0) {
                            $disableSuccess = $true
                            $requiresRestart = $true
                            Write-Host "Command-line method succeeded for drive $driveLetter"
                        } else {
                            Write-Host "Command-line method failed for drive $driveLetter - Exit codes: $exitCode1, $exitCode2" -ForegroundColor Red
                            
                            # Store the specific error for this drive
                            if (-not $Coms.ContainsKey('DriveErrors')) {
                                $Coms.DriveErrors = @{}
                            }
                            $Coms.DriveErrors[$driveLetter] = "PowerShell: $errorMsg, Command-line: Exit codes $exitCode1/$exitCode2"
                        }
                    } catch {
                        Write-Host "Command-line fallback also failed for drive $driveLetter`: $($_.Exception.Message)" -ForegroundColor Red
                        
                        # Store the error for this drive
                        if (-not $Coms.ContainsKey('DriveErrors')) {
                            $Coms.DriveErrors = @{}
                        }
                        $Coms.DriveErrors[$driveLetter] = "Both methods failed - PowerShell: $errorMsg, Command-line: $($_.Exception.Message)"
                    }
                }
            } else {
                Write-Host "Drive $driveLetter is not encrypted or protected, skipping"
            }
        }
    } else {
        # Use command-line method for all drives
        $Coms.Comment = "Using command-line method to disable BitLocker"
        $Coms.Progress = 50
        
        try {
            # Get all drives and try to disable BitLocker on each
            $drives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } # Fixed disks only
            
            foreach ($drive in $drives) {
                $driveLetter = $drive.DeviceID
                Write-Host "Checking drive $driveLetter with manage-bde"
                
                try {
                    $result = & manage-bde.exe -off $driveLetter 2>&1
                    Write-Host "manage-bde result for $driveLetter`: $result"
                    if ($LASTEXITCODE -eq 0) {
                        $disableSuccess = $true
                        $requiresRestart = $true
                        Write-Host "BitLocker disable initiated for drive $driveLetter"
                    }
                } catch {
                    Write-Host "Error with manage-bde for drive $driveLetter`: $($_.Exception.Message)"
                }
            }
        } catch {
            Write-Host "Error in command-line method: $($_.Exception.Message)"
        }
    }
    
    # Disable BitLocker feature by default
    $Coms.Comment = "Disabling BitLocker Windows feature"
    $Coms.Progress = 85
    
    try {
        Write-Host "Attempting to disable BitLocker Windows feature"
        $featureResult = Disable-WindowsOptionalFeature -Online -FeatureName "BitLocker" -NoRestart -ErrorAction Stop
        if ($featureResult.RestartNeeded) {
            $requiresRestart = $true
            Write-Host "BitLocker feature disabled - restart required"
        } else {
            Write-Host "BitLocker feature disabled successfully"
        }
        $disableSuccess = $true
    } catch {
        Write-Host "Error disabling BitLocker feature: $($_.Exception.Message)"
        # This is not critical if volume decryption succeeded
    }
    
    # Final status
    $Coms.Progress = 90
    
    if ($disableSuccess) {
        if ($requiresRestart) {
            $Coms.Comment = "BitLocker disable initiated successfully. Restart may be required to complete the process."
            # Set custom exit type to indicate restart recommendation
            $Coms.ExitType = "Restart"
            $Coms.ExitMessage = "BitLocker decryption is in progress and may require a restart to complete."
        } else {
            $Coms.Comment = "BitLocker disabled successfully."
        }
        $Coms.Progress = 100
        $Coms.Status = "Completed"
        
        # Include any drive-specific warnings
        if ($Coms.ContainsKey('DriveErrors') -and $Coms.DriveErrors.Count -gt 0) {
            $errorSummary = "Some drives had issues: "
            foreach ($drive in $Coms.DriveErrors.Keys) {
                $errorSummary += "$drive (see logs), "
            }
            $Coms.Comment += " Warning: $($errorSummary.TrimEnd(', '))"
        }
    } else {
        $failureReason = "Unknown error"
        
        # Provide specific failure reasons
        if ($Coms.ContainsKey('DriveErrors') -and $Coms.DriveErrors.Count -gt 0) {
            $failureReason = "Failed on drives: " + ($Coms.DriveErrors.Keys -join ", ")
        } elseif (-not $bitLockerModuleAvailable -and -not $manageBdeAvailable) {
            $failureReason = "BitLocker tools not available"
        } elseif (-not $isAdmin) {
            $failureReason = "Insufficient privileges"
        }
        
        $Coms.Comment = "Failed to disable BitLocker. $failureReason"
        $Coms.Progress = 0
        $Coms.Status = "Failed"
        
        Write-Host "BitLocker removal failed: $failureReason" -ForegroundColor Red
    }
    
} Catch {
    # Provide detailed error information
    $errorDetails = $_.Exception.Message
    $errorType = $_.Exception.GetType().Name
    $scriptLineNumber = $_.InvocationInfo.ScriptLineNumber
    
    $detailedError = "BitLocker removal failed - Type: $errorType, Line: $scriptLineNumber, Message: $errorDetails"
    
    Write-Host "Critical error in BitLocker removal:" -ForegroundColor Red
    Write-Host "  Error Type: $errorType" -ForegroundColor Red
    Write-Host "  Line Number: $scriptLineNumber" -ForegroundColor Red
    Write-Host "  Message: $errorDetails" -ForegroundColor Red
    
    # Set detailed error information for the UI
    $Coms.ErrorMessage = $detailedError
    $Coms.Comment = "BitLocker removal failed: $errorDetails"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    # Additional context based on common error scenarios
    if ($errorDetails -match "Access.*denied|Unauthorized|Permission") {
        $Coms.Comment = "Access denied - ensure you're running as Administrator"
        Write-Host "Suggestion: Ensure script is running as Administrator" -ForegroundColor Yellow
    } elseif ($errorDetails -match "Module.*not.*found|Command.*not.*found") {
        $Coms.Comment = "BitLocker tools not available on this system"
        Write-Host "Suggestion: BitLocker may not be available on this Windows edition" -ForegroundColor Yellow
    } elseif ($errorDetails -match "WMI|CIM|Management") {
        $Coms.Comment = "System management interface error - try restarting"
        Write-Host "Suggestion: Try restarting the system and running again" -ForegroundColor Yellow
    }
} Finally {
    # Provide final status information
    if ($disableSuccess) {
        Write-Host "BitLocker removal process completed" -ForegroundColor Green
        if ($requiresRestart) {
            Write-Host "Note: A system restart may be required to complete decryption" -ForegroundColor Yellow
        }
        
        # Show current status of all drives
        try {
            Write-Host "`nFinal BitLocker status check:"
            $finalCheck = & manage-bde.exe -status 2>$null
            if ($finalCheck) {
                $finalCheck | ForEach-Object { Write-Host $_ }
            }
        } catch {
            Write-Host "Could not perform final status check"
        }
    } else {
        Write-Host "BitLocker removal failed or was not needed" -ForegroundColor Red
    }
}