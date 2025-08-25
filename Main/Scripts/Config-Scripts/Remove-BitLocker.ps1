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
        throw "This script must be run as Administrator to manage BitLocker encryption."
    }
    
    Write-Host "Running as Administrator - proceeding with BitLocker check"
    
    # Check if BitLocker feature is available on this system
    $Coms.Comment = "Checking if BitLocker feature is available"
    $Coms.Progress = 15
    
    try {
        $bitLockerFeature = Get-WindowsOptionalFeature -Online -FeatureName "BitLocker" -ErrorAction SilentlyContinue
        if (-not $bitLockerFeature) {
            $Coms.Comment = "BitLocker feature not found on this system. No action needed."
            $Coms.Progress = 100
            $Coms.Status = "Completed"
            return
        }
        
        Write-Host "BitLocker feature status: $($bitLockerFeature.State)"
        if ($bitLockerFeature.State -eq "Disabled") {
            $Coms.Comment = "BitLocker feature is already disabled. No action needed."
            $Coms.Progress = 100
            $Coms.Status = "Completed"
            return
        }
    } catch {
        Write-Host "Unable to check BitLocker feature status, proceeding with drive checks"
    }
    
    # Get all BitLocker volumes
    $Coms.Comment = "Scanning for BitLocker encrypted volumes"
    $Coms.Progress = 20
    
    try {
        $bitLockerVolumes = Get-BitLockerVolume -ErrorAction SilentlyContinue
        if (-not $bitLockerVolumes) {
            Write-Host "No BitLocker volumes found using Get-BitLockerVolume"
            # Try alternative method using manage-bde
            $manageBdeOutput = & manage-bde.exe -status 2>$null
            if ($manageBdeOutput -and ($manageBdeOutput -join " ") -match "Protection On|Encryption in Progress") {
                Write-Host "BitLocker detected via manage-bde command"
                $bitLockerFound = $true
            }
        } else {
            Write-Host "Found $($bitLockerVolumes.Count) BitLocker volume(s)"
            $bitLockerFound = $true
        }
    } catch {
        Write-Host "Error checking BitLocker volumes: $($_.Exception.Message)"
        # Try command line method as fallback
        try {
            $manageBdeOutput = & manage-bde.exe -status 2>$null
            if ($manageBdeOutput -and ($manageBdeOutput -join " ") -match "Protection On|Encryption in Progress") {
                Write-Host "BitLocker detected via manage-bde fallback"
                $bitLockerFound = $true
            }
        } catch {
            Write-Host "Unable to check BitLocker status via command line either"
        }
    }
    
    if (-not $bitLockerFound) {
        $Coms.Comment = "No BitLocker encrypted volumes found. No action needed."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
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
                    Write-Host "Error disabling BitLocker on drive $driveLetter`: $($_.Exception.Message)"
                    
                    # Try command-line method as fallback
                    try {
                        Write-Host "Trying command-line method for drive $driveLetter"
                        $result = & manage-bde.exe -off $driveLetter 2>&1
                        Write-Host "Command-line result: $result"
                        if ($LASTEXITCODE -eq 0) {
                            $disableSuccess = $true
                            $requiresRestart = $true
                        } else {
                            Write-Host "Command-line method failed with exit code: $LASTEXITCODE"
                        }
                    } catch {
                        Write-Host "Command-line fallback also failed: $($_.Exception.Message)"
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
    } else {
        $Coms.Comment = "Failed to disable BitLocker. Manual intervention may be required."
        $Coms.Progress = 0
        $Coms.Status = "Failed"
    }
    
} Catch {
    $Coms.ErrorMessage = "An error occurred: $_"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    Write-Host "Critical error in BitLocker removal: $($_.Exception.Message)" -ForegroundColor Red
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