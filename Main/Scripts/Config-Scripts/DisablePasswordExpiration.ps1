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

Try {
    # Step 1: Check current password policy
    $Coms.Progress = 10
    $Coms.Comment = "Checking current password policy..."
    
    # Get current max password age setting
    $currentPolicy = net accounts | Select-String "Maximum password age"
    if ($currentPolicy) {
        $Coms.Comment = "Current policy: $($currentPolicy.ToString().Trim())"
        Start-Sleep -Seconds 1
    }
    
    # Step 2: Create backup of current settings (optional)
    $Coms.Progress = 25
    $Coms.Comment = "Creating backup of current policy..."
    
    $backupPath = "$env:TEMP\PasswordPolicy_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    try {
        net accounts | Out-File -FilePath $backupPath -Encoding UTF8
        $Coms.Comment = "Backup created: $backupPath"
    } catch {
        $Coms.Comment = "Warning: Could not create backup - $($_.Exception.Message)"
    }
    Start-Sleep -Seconds 1
    
    # Step 3: Execute the password expiration disable command
    $Coms.Progress = 50
    $Coms.Comment = "Executing: net accounts /maxpwage:unlimited"
    
    # Run the net accounts command
    $result = Start-Process -FilePath "net" -ArgumentList "accounts", "/maxpwage:unlimited" -Wait -PassThru -NoNewWindow
    
    if ($result.ExitCode -eq 0) {
        $Coms.Progress = 75
        $Coms.Comment = "Password expiration disabled successfully"
        $Coms.Status = "Success"
    } else {
        throw "net accounts command failed with exit code: $($result.ExitCode)"
    }
    
    # Step 4: Verify the change
    $Coms.Progress = 90
    $Coms.Comment = "Verifying policy change..."
    Start-Sleep -Seconds 1
    
    $verifyPolicy = net accounts | Select-String "Maximum password age"
    if ($verifyPolicy -and $verifyPolicy.ToString() -match "Never") {
        $Coms.Progress = 100
        $Coms.Comment = "Verification successful: Password expiration is now disabled"
        $Coms.Status = "Completed"
    } else {
        $Coms.Progress = 100
        $Coms.Comment = "Could not verify policy change"
        $Coms.Status = "Warning"
    }
} Catch {
    $Coms.Status = "Failed"
    $Coms.ErrorMessage = $($_.Exception.Message)
    $Coms.Progress = 0
    
    # Log the error details
    Write-Error "Failed to disable password expiration: $($_.Exception.Message)"
    
    # If backup exists, mention it in the error
    if (Test-Path $backupPath -ErrorAction SilentlyContinue) {
        $Coms.Comment += " | Backup available at: $backupPath"
    }
}