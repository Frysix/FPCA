# Standardized Installer Script for Windows

# Starting Message
Write-Host "Starting Installer script..."

# Checks if there is an existing installation

# Ininitializes the $DriveLetters array
$DriveLetters = @()
# Get all logical disks with DriveType 2 (Removable) and 3 (Local Disk)
$Drives = Get-CimInstance Win32_LogicalDisk | Where-Object {
    $_.DriveType -in 2, 3
}
# Collects the DeviceID of each drive into the $DriveLetters array
foreach ($Drive in $Drives) {
    $DriveLetters += $Drive.DeviceID
}

Write-Host "Drives found:" -ForegroundColor Cyan
$DriveLetters | ForEach-Object { Write-Host $_ }



#END REMOVE BEFORE PUBLICATION
Pause