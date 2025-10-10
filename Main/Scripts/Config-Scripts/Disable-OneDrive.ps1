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
    
    # Disable file sync
    Set-ItemProperty -Path $policyPath -Name "DisableFileSyncNGSC" -Value 0 -Type DWord
    Set-ItemProperty -Path $policyPath -Name "DisableFileSync" -Value 1 -Type DWord
    
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
