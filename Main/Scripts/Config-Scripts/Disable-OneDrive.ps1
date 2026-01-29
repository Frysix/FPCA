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

$Coms.Status = "Running"
$Coms.Comment = "Disabling OneDrive sync"
$Coms.Progress = 20

Try {
    # Stop OneDrive process
    $Coms.Comment = "Stopping OneDrive process"
    $Coms.Progress = 40
    
    Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
    # Disable OneDrive sync via registry
    $Coms.Comment = "Disabling OneDrive synchronization"
    $Coms.Progress = 60
    
    # Create policy registry path if it doesn't exist
    $policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
    if (!(Test-Path $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
    }

    # Remove existing OneDrive account bindings so no user stays signed in
    $Coms.Comment = "Removing OneDrive account associations"
    $Coms.Progress = 70
    $accountRoot = "HKCU:\Software\Microsoft\OneDrive"
    $accountPath = Join-Path $accountRoot "Accounts"
    if (Test-Path $accountPath) {
        Remove-Item -Path $accountPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path $accountRoot) {
        Remove-ItemProperty -Path $accountRoot -Name "UserFolder" -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $accountRoot -Name "MountPoint" -ErrorAction SilentlyContinue
    }

    # Remove OneDrive from startup entries (Task Manager Startup tab)
    $Coms.Comment = "Removing OneDrive from startup"
    $Coms.Progress = 80
    $runKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    )
    foreach ($runKey in $runKeys) {
        if (Test-Path $runKey) {
            Remove-ItemProperty -Path $runKey -Name "OneDrive" -ErrorAction SilentlyContinue
        }
    }

    $startupApprovedKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
    )
    foreach ($startupKey in $startupApprovedKeys) {
        if (Test-Path $startupKey) {
            Remove-ItemProperty -Path $startupKey -Name "OneDrive" -ErrorAction SilentlyContinue
        }
    }
    
    # Remove OneDrive from File Explorer sidebar
    $namespacePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    if (Test-Path $namespacePath) {
        Remove-Item -Path $namespacePath -Force -ErrorAction SilentlyContinue
    }
    
    $Coms.Comment = "OneDrive sync disabled successfully"
    $Coms.Progress = 100
    $Coms.Status = "Completed"
    
    Write-Host "OneDrive synchronization has been disabled" -ForegroundColor Green
    
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Comment = "Failed to disable OneDrive sync"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
