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
$Coms.Comment = "Disabling Fast Startup"
$Coms.Progress = 20

Try {
    # Simple registry modification to disable Fast Startup
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
    
    $Coms.Comment = "Setting Fast Startup registry value"
    $Coms.Progress = 50
    
    # Create registry path if it doesn't exist
    if (!(Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    
    # Set HiberbootEnabled to 0 (disabled)
    Set-ItemProperty -Path $regPath -Name "HiberbootEnabled" -Value 0 -Type DWord
    
    $Coms.Comment = "Fast Startup disabled successfully"
    $Coms.Progress = 100
    $Coms.Status = "Completed"
    
    Write-Host "Fast Startup has been disabled" -ForegroundColor Green
    
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Comment = "Failed to disable Fast Startup"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
