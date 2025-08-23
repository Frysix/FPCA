# Helper module for managing locks in the FPCA Updater
# This module provides functions to handle file locks and ensure that the app can run safely.

function New-LockFile {
	param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )
    # Create the lock file path
    $LockFilePath = Join-Path -Path $RootPath -ChildPath "Assets\locks\$Name.lock"
    # Ensure the directory exists
    $LockDir = Split-Path -Path $LockFilePath -Parent
    if (-not (Test-Path -Path $LockDir)) {
        New-Item -ItemType Directory -Path $LockDir -Force | Out-Null
    }
    # Create the lock file
    if (-not (Test-Path -Path $LockFilePath)) {
        New-Item -ItemType File -Path $LockFilePath -Force | Out-Null
        Write-Host "Lock file created: $LockFilePath"
    } else {
        Write-Host "Lock file already exists: $LockFilePath"
    }
    return $LockFilePath
}

function Write-LockFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$RootPath,
        [string]$Content
    )
    $LockFilePath = Join-Path -Path $RootPath -ChildPath "Assets\locks\$Name.lock"
    if (Test-Path -Path $LockFilePath) {
        Set-Content -Path $LockFilePath -Value $Content -Force
        Write-Host "Lock file updated: $LockFilePath"
    } else {
        Write-Host "Lock file does not exist: $LockFilePath"
    }
}

function Remove-LockFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )
    $LockFilePath = Join-Path -Path $RootPath -ChildPath "Assets\locks\$Name.lock"
    if (Test-Path -Path $LockFilePath) {
        Remove-Item -Path $LockFilePath -Force
        Write-Host "Lock file removed: $LockFilePath"
    } else {
        Write-Host "Lock file does not exist: $LockFilePath"
    }
}

function Test-ProcessFromLockFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$RootPath
    )
    $LockFilePath = Join-Path -Path $RootPath -ChildPath "Assets\locks\$Name.lock"
    if (Test-Path -Path $LockFilePath) {
        $Content = Get-Content -Path $LockFilePath -ErrorAction SilentlyContinue
        if ($Content) {
            $ProcessId = [int]$Content
            if (Get-Process -Id $ProcessId -ErrorAction SilentlyContinue) {
                Write-Host "Process with ID $ProcessId is running."
                return $true
            } else {
                Write-Host "No process found with ID $ProcessId."
                return $false
            }
        } else {
            Write-Host "Lock file is empty."
            return $false
        }
    } else {
        Write-Host "Lock file does not exist: $LockFilePath"
        return $false
    }
}