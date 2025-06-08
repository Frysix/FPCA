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

#Checks if there is an existing installation on any of the drives
foreach ($Letter in $DriveLetters) {
    if (test-path -path "$Letter\FPCA\fpca.info") {
        $info = @{}
        $section = ""
        foreach ($line in Get-Content "$Letter\FPCA\fpca.info") {
            $line = $line.Trim()
            if ($line -match "^\s*#|^\s*;|^\s*$") {
                continue
            }
            if ($line -match "^\[(.+)\]$") {
                $section = $matches[1]
                $info[$section] = @{}
            } elseif ($line -match "^(.*?)=(.*)$") {
                $key = $matches[1].Trim()
                $value = $matches[2].Trim()
                if ($section -ne "") {
                    $info[$section][$key] = $value
                }
            }
        }
        Write-Host "Existing installation found on drive $Letter" -ForegroundColor Yellow
        Write-Host "Version: $($info['General']['Version'])" -ForegroundColor Yellow
        
    }
}


#END REMOVE BEFORE PUBLICATION
Pause