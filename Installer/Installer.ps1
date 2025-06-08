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

# Display the found drives
Write-Host "Drives found:" -ForegroundColor Cyan
$DriveLetters | ForEach-Object { Write-Host $_ }

# Checks if there is an existing installation on any of the drives
# If an installation is found, it reads the fpca.info file and displays the version and start file.
foreach ($Letter in $DriveLetters) {
    if (test-path -path "$Letter\FPCA\fpca.info") {
        $info = @{}
        $section = ""
        # Parse the fpca.info content
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
        # Check the online version and ask for update if the online version is newer
        $OnlineRawInfo = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/fpca.info" -UseBasicParsing
        $lines = $OnlineRawInfo.Content -split "`n"
        $OnlineInfo = @{}
        $section = ""
        # Parse the online fpca.info online content
        foreach ($line in $lines) {
            $line = $line.Trim()
            if ($line -match "^\s*#|^\s*;|^\s*$") {
                continue
            }
            if ($line -match "^\[(.+)\]$") {
                $section = $matches[1]
                $OnlineInfo[$section] = @{}
            } elseif ($line -match "^(.*?)=(.*)$") {
                $key = $matches[1].Trim()
                $value = $matches[2].Trim()
                if ($section -ne "") {
                    $OnlineInfo[$section][$key] = $value
                }
            }
        }
        # Compare the online version with the local version and launch the installed script if the versions match
        if ($OnlineInfo['General']['Version'] -eq $info['General']['Version']) {
            if (test-path -path "$Letter\FPCA\$($info['Files']['start'])") {
                Write-Host "Start file found: $($info['Files']['start'])" -ForegroundColor Yellow
                Start-Process -FilePath "$Letter\FPCA\$($info['Files']['start'])" -WorkingDirectory "$Letter\FPCA" -Verb Runas
                Exit
            }
        }
    }
}



#END REMOVE BEFORE PUBLICATION
Pause