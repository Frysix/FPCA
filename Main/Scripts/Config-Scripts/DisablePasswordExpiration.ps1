# Config Script for fpca that disables password expiration for all users
# Standard Parameters strucure for config scripts
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$Coms,
    [Parameter(Mandatory=$true)]
    [string]$TaskName,
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot
)

$Coms.Status = "Running"
$Coms.Progress = 5
$Coms.Comment = "Initializing script..."

# Initialize backup path variable at script scope
$backupPath = $null

Try {
    # Check if running as administrator
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        throw "This script requires Administrator privileges to modify password policies"
    }
    
    # Step 1: Check current password policy
    $Coms.Progress = 10
    $Coms.Comment = "Checking current password policy..."
    
    # Get current max password age setting
    try {
        $currentPolicy = net accounts 2>&1 | Select-String "Maximum password age"
        if ($currentPolicy) {
            $Coms.Comment = "Current policy: $($currentPolicy.ToString().Trim())"
            Start-Sleep -Seconds 1
        }
    } catch {
        $Coms.Comment = "Warning: Could not read current policy - $($_.Exception.Message)"
    }
    
    # Step 2: Create backup of current settings
    $Coms.Progress = 25
    $Coms.Comment = "Creating backup of current policy..."
    
    $backupPath = "$env:TEMP\PasswordPolicy_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    try {
        $policyOutput = net accounts 2>&1
        $policyOutput | Out-File -FilePath $backupPath -Encoding UTF8
        $Coms.Comment = "Backup created: $backupPath"
    } catch {
        $Coms.Comment = "Warning: Could not create backup - $($_.Exception.Message)"
        $backupPath = $null  # Reset if backup failed
    }
    Start-Sleep -Seconds 1
    
    # Step 3: Execute the password expiration disable command
    $Coms.Progress = 50
    $Coms.Comment = "Executing: net accounts /maxpwage:unlimited"
    
    # Run the net accounts command with error capture
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "net"
    $processInfo.Arguments = "accounts /maxpwage:unlimited"
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true
    $processInfo.UseShellExecute = $false
    $processInfo.CreateNoWindow = $true
    
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo
    $process.Start() | Out-Null
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()
    
    $exitCode = $process.ExitCode
    
    Write-Host "Exit Code: $exitCode"
    Write-Host "STDOUT: $stdout"
    Write-Host "STDERR: $stderr"
    
    # Check for success - net accounts usually returns 0 for success
    if ($exitCode -eq 0 -and [string]::IsNullOrEmpty($stderr)) {
        $Coms.Progress = 75
        $Coms.Comment = "Password expiration command executed successfully"
    } else {
        throw "net accounts command failed. Exit code: $exitCode, Error: $stderr, Output: $stdout"
    }
    
    # Step 4: Verify the change
    $Coms.Progress = 90
    $Coms.Comment = "Verifying policy change..."
    Start-Sleep -Seconds 2  # Give system time to apply changes
    
    try {
        $verifyPolicy = net accounts 2>&1 | Select-String "Maximum password age"
        if ($verifyPolicy) {
            $policyText = $verifyPolicy.ToString()
            Write-Host "Verification policy text: $policyText"
            
            # Check for various indicators that password expiration is disabled
            if ($policyText -match "Never|Unlimited|0|FFFFFFFFF" -or $policyText -match "4294967295") {
                $Coms.Progress = 100
                $Coms.Comment = "Verification successful: Password expiration is now disabled"
                $Coms.Status = "Completed"
            } else {
                $Coms.Progress = 100
                $Coms.Comment = "Policy may have changed but verification unclear: $policyText"
                $Coms.Status = "Warning"
            }
        } else {
            $Coms.Progress = 100
            $Coms.Comment = "Could not read policy for verification"
            $Coms.Status = "Warning"
        }
    } catch {
        $Coms.Progress = 100
        $Coms.Comment = "Verification step failed: $($_.Exception.Message)"
        $Coms.Status = "Warning"
    }
    
} Catch {
    $Coms.Status = "Failed"
    $Coms.ErrorMessage = $($_.Exception.Message)
    $Coms.Progress = 0
    
    # Log the error details
    Write-Error "Failed to disable password expiration: $($_.Exception.Message)"
    
    # Check if backup exists and path is not null
    if ($backupPath -and (Test-Path $backupPath -ErrorAction SilentlyContinue)) {
        $Coms.Comment = "Error occurred. Backup available at: $backupPath"
    } else {
        $Coms.Comment = "Error occurred: $($_.Exception.Message)"
    }
}