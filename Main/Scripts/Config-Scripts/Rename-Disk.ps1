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

$renameSuccess = $false
$Coms.Status = "Running"
$Coms.Comment = "Starting Volume Label Rename Script"
$Coms.Progress = 1

Try {
    $Coms.Comment = "Validating volume label rename parameters"
    $Coms.Progress = 10
    
    # Get the new volume label from TaskSettings
    $newDiskName = $null
    if ($TaskSettings -and $TaskSettings.ContainsKey('InputText')) {
        $newDiskName = $TaskSettings.InputText
    }
    
    # Validate the new disk name
    if ([string]::IsNullOrWhiteSpace($newDiskName)) {
        throw "No disk name provided. Please specify a new volume label for the partition."
    }
    
    # Clean up the disk name (remove invalid characters for volume labels)
    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    # Also add characters that are specifically invalid for volume labels
    $additionalInvalidChars = @('/', ':', '*', '?', '"', '<', '>', '|', '\')
    
    foreach ($char in $invalidChars) {
        $newDiskName = $newDiskName.Replace($char.ToString(), '')
    }
    foreach ($char in $additionalInvalidChars) {
        $newDiskName = $newDiskName.Replace($char, '')
    }
    
    # Trim whitespace and limit length (Windows volume labels can be up to 32 characters)
    $newDiskName = $newDiskName.Trim()
    if ($newDiskName.Length -gt 32) {
        $newDiskName = $newDiskName.Substring(0, 32).Trim()
        Write-Host "Volume label truncated to 32 characters: '$newDiskName'"
    }
    
    if ([string]::IsNullOrWhiteSpace($newDiskName)) {
        throw "Volume label is empty or contains only invalid characters."
    }
    
    Write-Host "Target volume label (partition name): '$newDiskName'"
    
    # Determine which drive to rename (this is the drive letter, but we're changing the volume label/partition name)
    $targetDrive = $null
    $targetDriveLetter = $null
    
    if ($TaskSettings -and $TaskSettings.ContainsKey('DriveLetter')) {
        $targetDriveLetter = $TaskSettings.DriveLetter
        Write-Host "Target drive specified: $targetDriveLetter"
    } else {
        # Default to C: drive (system drive)
        $targetDriveLetter = "C:"
        Write-Host "No drive specified, defaulting to C: drive"
    }
    
    $Coms.Comment = "Locating target drive $targetDriveLetter to rename its volume label"
    $Coms.Progress = 20
    
    # Get the target drive information
    try {
        $targetDrive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $targetDriveLetter }
        if (-not $targetDrive) {
            throw "Drive $targetDriveLetter not found on this system."
        }
        
        Write-Host "Found target drive: $($targetDrive.DeviceID)"
        Write-Host "Current volume label: '$($targetDrive.VolumeName)'"
        Write-Host "Drive type: $($targetDrive.DriveType) (3=Fixed Disk, 2=Removable, 5=CD-ROM)"
        Write-Host "File system: $($targetDrive.FileSystem)"
        Write-Host "Total size: $([math]::Round($targetDrive.Size / 1GB, 2)) GB"
        
    } catch {
        throw "Error accessing drive $targetDriveLetter`: $($_.Exception.Message)"
    }
    
    # Check if the drive is writable (not CD-ROM, etc.)
    if ($targetDrive.DriveType -eq 5) {
        throw "Cannot rename CD-ROM/DVD drives (Drive $targetDriveLetter is read-only)."
    }
    
    # Check current name
    $currentName = $targetDrive.VolumeName
    if ($currentName -eq $newDiskName) {
        $Coms.Comment = "Drive $targetDriveLetter already has the name '$newDiskName'. No change needed."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
        $renameSuccess = $true
        return
    }
    
    $Coms.Comment = "Renaming drive $targetDriveLetter from '$currentName' to '$newDiskName'"
    $Coms.Progress = 40
    
    # Method 1: Try using WMI SetVolumeLabel
    try {
        Write-Host "Attempting to rename drive using WMI method..."
        $result = $targetDrive.Put()
        $targetDrive.VolumeName = $newDiskName
        $result = $targetDrive.Put()
        
        # Verify the change worked
        Start-Sleep -Seconds 2
        $updatedDrive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $targetDriveLetter }
        if ($updatedDrive.VolumeName -eq $newDiskName) {
            Write-Host "Successfully renamed drive using WMI method"
            $renameSuccess = $true
        } else {
            Write-Host "WMI method did not work, trying alternative method..."
        }
    } catch {
        Write-Host "WMI method failed: $($_.Exception.Message)"
    }
    
    # Method 2: Try using label command if WMI failed
    if (-not $renameSuccess) {
        $Coms.Comment = "Trying alternative rename method for drive $targetDriveLetter"
        $Coms.Progress = 60
        
        try {
            Write-Host "Attempting to rename drive using label command..."
            $labelCommand = "label $($targetDriveLetter.TrimEnd(':')) `"$newDiskName`""
            Write-Host "Executing: $labelCommand"
            
            # Use cmd to execute the label command
            $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c", $labelCommand -Wait -PassThru -NoNewWindow
            
            if ($process.ExitCode -eq 0) {
                # Verify the change worked
                Start-Sleep -Seconds 2
                $updatedDrive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $targetDriveLetter }
                if ($updatedDrive.VolumeName -eq $newDiskName) {
                    Write-Host "Successfully renamed drive using label command"
                    $renameSuccess = $true
                } else {
                    Write-Host "Label command executed but name not updated"
                }
            } else {
                Write-Host "Label command failed with exit code: $($process.ExitCode)"
            }
        } catch {
            Write-Host "Label command method failed: $($_.Exception.Message)"
        }
    }
    
    # Method 3: Try using PowerShell Set-Volume if available (Windows 8+)
    if (-not $renameSuccess) {
        $Coms.Comment = "Trying PowerShell Set-Volume method for drive $targetDriveLetter"
        $Coms.Progress = 80
        
        try {
            Write-Host "Attempting to rename drive using Set-Volume cmdlet..."
            
            # Get the volume by drive letter
            $volume = Get-Volume -DriveLetter $targetDriveLetter.TrimEnd(':') -ErrorAction Stop
            Set-Volume -DriveLetter $targetDriveLetter.TrimEnd(':') -NewFileSystemLabel $newDiskName -ErrorAction Stop
            
            # Verify the change worked
            Start-Sleep -Seconds 2
            $updatedVolume = Get-Volume -DriveLetter $targetDriveLetter.TrimEnd(':') -ErrorAction SilentlyContinue
            if ($updatedVolume -and $updatedVolume.FileSystemLabel -eq $newDiskName) {
                Write-Host "Successfully renamed drive using Set-Volume cmdlet"
                $renameSuccess = $true
            } else {
                Write-Host "Set-Volume executed but name not updated"
            }
        } catch {
            Write-Host "Set-Volume method failed: $($_.Exception.Message)"
        }
    }
    
    # Final verification and status
    $Coms.Progress = 90
    
    if ($renameSuccess) {
        # Final verification
        Start-Sleep -Seconds 3
        $finalDrive = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DeviceID -eq $targetDriveLetter }
        $finalName = $finalDrive.VolumeName
        
        if ($finalName -eq $newDiskName) {
            $Coms.Comment = "Drive $targetDriveLetter successfully renamed to '$newDiskName'"
            $Coms.Progress = 100
            $Coms.Status = "Completed"
            Write-Host "Disk rename operation completed successfully" -ForegroundColor Green
            Write-Host "Drive $targetDriveLetter is now named: '$finalName'"
        } else {
            $Coms.Comment = "Drive rename may have failed - final name is '$finalName' instead of '$newDiskName'"
            $Coms.Progress = 95
            $Coms.Status = "Warning"
            Write-Host "Warning: Final verification shows unexpected name" -ForegroundColor Yellow
        }
    } else {
        $Coms.Comment = "Failed to rename drive $targetDriveLetter to '$newDiskName'"
        $Coms.Progress = 0
        $Coms.Status = "Failed"
        Write-Host "All rename methods failed" -ForegroundColor Red
    }
    
} Catch {
    $Coms.ErrorMessage = "An error occurred: $_"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    Write-Host "Critical error in disk rename: $($_.Exception.Message)" -ForegroundColor Red
} Finally {
    # Provide final status information
    if ($renameSuccess) {
        Write-Host "Disk rename process completed successfully" -ForegroundColor Green
        
        # Show final status of all drives for reference
        try {
            Write-Host "`nCurrent drive labels:"
            $allDrives = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
            foreach ($drive in $allDrives) {
                $label = if ($drive.VolumeName) { $drive.VolumeName } else { "(No Label)" }
                Write-Host "  $($drive.DeviceID) - $label"
            }
        } catch {
            Write-Host "Could not display final drive status"
        }
    } else {
        Write-Host "Disk rename failed" -ForegroundColor Red
        Write-Host "You may need to rename the drive manually using Disk Management" -ForegroundColor Yellow
    }
}