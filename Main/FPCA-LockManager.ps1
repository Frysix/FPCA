# App Lock Manager script
# Creates and manages Locker states
Param(
    [Parameter(Mandatory=$true,ParameterSetName="Create")]
    [switch]$Create,
    [Parameter(Mandatory=$true,ParameterSetName="Remove")]
    [switch]$Remove,
    [parameter(Mandatory=$false)]
    [string]$ProcessID,
    [parameter(Mandatory=$true)]
    [string]$ScriptPath,
    [parameter(Mandatory=$true)]
    [string]$LockName
)

# Open try-catch block to handle errors
Try {
    # Define functions for recurrent tasks
    # Function to check if a specific lock exists and if its process is still running
    function Test-ForLock {
        Param(
            [Parameter(Mandatory=$true)]
            [hashtable]$LockInfo
        )
        $Processes = Get-Process
        if ($Processes.Id -contains $LockInfo.ProcessID) {
            $RunningProcess = Get-Process -Id $LockInfo.ProcessID
            if ($RunningProcess.ProcessName -eq "powershell" -or $RunningProcess.ProcessName -eq "pwsh") {
                # A Process is running and is a PowerShell instance
                Return $true
            } else {
                # A Process is running but not a PowerShell instance, remove lock file
                if (Test-Path -Path $LockInfo.LockFilePath) {
                    Remove-Item -Path $LockInfo.LockFilePath -Force -ErrorAction SilentlyContinue
                }
                Return $false
            }
        } else {
            # Process not running, remove lock file
            if (Test-Path -Path $LockInfo.LockFilePath) {
                Remove-Item -Path $LockInfo.LockFilePath -Force -ErrorAction SilentlyContinue
            }
            Return $false
        }
    }
    # Function to get all current locks and parse them in a hashtable
    function Get-CurrentLocks {
        Param(
            [parameter(Mandatory=$true)]
            [string]$LockFilesPath
        )
        $locks = @{}
        if (Test-Path -Path $LockFilesPath) {
            $lockFiles = Get-ChildItem -Path $LockFilesPath -Filter "*.lock" -ErrorAction SilentlyContinue
            foreach ($file in $lockFiles) {
                $Name = $file.BaseName
                $processData = Get-Content -Path $file.FullName | ConvertFrom-StringData
                if ($processData -and $processData.ProcessID) {
                    if (-not $locks.ContainsKey($Name)) {
                        $locks[$Name] = @{}
                    }
                    $locks[$Name].ProcessID = $processData.ProcessID
                    $locks[$Name].LockFilePath = $file.FullName
                    $locks[$Name].LockName = $Name
                }
            }
            if ($locks.Count -gt 0) {
                Return $locks
            } else {
                Return "NoLocks"
            }
        } else {
            Return "NoFolder"
        }
    }

    # Define the path for lock files
    $LocksFolder = Join-Path -Path $ScriptPath -ChildPath "\Assets\locks\"
    # Ensure the lock folder exists
    if (-not (Test-Path -Path $LocksFolder)) {
        New-Item -ItemType Directory -Path $LocksFolder -Force 
    }
    # Retrieve current locks
    Write-Host "Checking existing locks in $LocksFolder"
    $CurrentLocks = Get-CurrentLocks -LockFilesPath $LocksFolder
    # Main logic based on parameters
    if ($Create) {
        if ($ProcessID -eq $null -or $LockName -eq $null) {
            Throw "ProcessID and LockName are required for creating a lock."
        }
        # Create locker logic here
        Write-Host "Checking for existing locks"
        $CreateNewLock = $false
        if ($CurrentLocks -is [string]) {
            if ($CurrentLocks -eq "NoFolder") {
                New-Item -ItemType Directory -Path $LocksFolder -Force 
            }
            # No locks exist, create new lock
            $CreateNewLock = $true
        } elseif ($CurrentLocks -is [hashtable]) {
            $LockFound = $false
            foreach ($lock in $CurrentLocks.Keys) {
                if ($lock -eq $LockName) {
                    $LockFound = $true
                    $LockStatus = Test-ForLock -LockInfo $CurrentLocks[$lock]
                    if ($LockStatus) {
                        # Lock exists and process is running
                        $Result = @{
                            Message = "Lock: ${LockName} Exists and is already running"
                            Status = "Running"
                        }
                        Break
                    } else {
                        # Lock is stale, create new lock
                        $CreateNewLock = $true
                        Break
                    }
                }
            }
            # If no matching lock was found, create a new one
            if (-not $LockFound) {
                $CreateNewLock = $true
            }
        } else {
            Throw "Error retrieving current locks."
        }
        if ($CreateNewLock) {
            Write-Host "Creating locker with name: ${LockName} for Process ID: $ProcessID"
            $LockFilePath = Join-Path -Path $LocksFolder -ChildPath "${LockName}.lock"
            $lockContent = "ProcessID=${ProcessID}"
            $lockContent | Out-File -FilePath $LockFilePath -Encoding UTF8 -Force
            if (Test-Path -Path $LockFilePath) {
                $Result = @{
                    Message = "Lock: ${LockName} Was Created successfully."
                    Status = "Created"
                }
            } else {
                Throw "Failed to create lock file."
            }
        }
    } elseif ($Remove) {
        # Remove locker logic here
        Write-Host "Removing Locker with name: ${LockName} for Process ID: $ProcessID"
        
    } else {
        Throw "Invalid operation. Use -Create or -Remove."
    }
} Catch {
    # Capture and return error message
    $Result = @{
        Message = $_.Exception.Message
        Status = "Error"
    }
}
# Return the result of the operation
Return $Result