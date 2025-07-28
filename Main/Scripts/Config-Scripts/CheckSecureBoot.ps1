# Script to check if Secure Boot is enabled on the system
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$Coms,
    [Parameter(Mandatory=$true)]
    [string]$TaskName,
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot
)

$Coms.Status = "Running"
$Coms.Progress = 10
$Coms.Comment = "Checking Secure Boot status..."

try {
    # Check if running as administrator
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        throw "This script requires Administrator privileges to check Secure Boot status."
    }
    
    $Coms.Progress = 30
    $Coms.Comment = "Checking Secure Boot using multiple methods..."
    
    $secureBootEnabled = $false
    $detectionMethod = ""
    
    # Method 1: Try PowerShell Get-SecureBootUEFI (Windows 8+)
    try {
        $Coms.Comment = "Attempting PowerShell SecureBoot check..."
        $secureBootStatus = Get-SecureBootUEFI -Name SetupMode -ErrorAction SilentlyContinue
        if ($secureBootStatus -ne $null) {
            # SetupMode = 0 means Secure Boot is enabled
            $secureBootEnabled = ($secureBootStatus.Bytes -eq 0)
            $detectionMethod = "PowerShell Get-SecureBootUEFI"
        }
    } catch {
        Write-Host "PowerShell method failed: $($_.Exception.Message)"
    }
    
    # Method 2: Try using full path to bcdedit if PowerShell method failed
    if (-not $secureBootEnabled -and $detectionMethod -eq "") {
        try {
            $Coms.Comment = "Attempting BCDEdit check..."
            $bcdPath = "$env:WINDIR\System32\bcdedit.exe"
            
            if (Test-Path $bcdPath) {
                # Use Start-Process to run bcdedit with full path
                $processInfo = New-Object System.Diagnostics.ProcessStartInfo
                $processInfo.FileName = $bcdPath
                $processInfo.Arguments = "/enum {current}"
                $processInfo.RedirectStandardOutput = $true
                $processInfo.RedirectStandardError = $true
                $processInfo.UseShellExecute = $false
                $processInfo.CreateNoWindow = $true
                
                $process = New-Object System.Diagnostics.Process
                $process.StartInfo = $processInfo
                $process.Start() | Out-Null
                $bcdOutput = $process.StandardOutput.ReadToEnd()
                $bcdError = $process.StandardError.ReadToEnd()
                $process.WaitForExit()
                
                if ($process.ExitCode -eq 0) {
                    if ($bcdOutput -match "SecureBoot State\s+:\s+On") {
                        $secureBootEnabled = $true
                        $detectionMethod = "BCDEdit"
                    } elseif ($bcdOutput -match "SecureBoot State\s+:\s+Off") {
                        $secureBootEnabled = $false
                        $detectionMethod = "BCDEdit"
                    }
                } else {
                    Write-Host "BCDEdit failed with exit code $($process.ExitCode): $bcdError"
                }
            }
        } catch {
            Write-Host "BCDEdit method failed: $($_.Exception.Message)"
        }
    }
    
    # Method 3: Try WMI/CIM as fallback
    if ($detectionMethod -eq "") {
        try {
            $Coms.Comment = "Attempting WMI/Registry check..."
            
            # Check registry for Secure Boot
            $secureBootKey = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State"
            if (Test-Path $secureBootKey) {
                $secureBootValue = Get-ItemProperty -Path $secureBootKey -Name "UEFISecureBootEnabled" -ErrorAction SilentlyContinue
                if ($secureBootValue -and $secureBootValue.UEFISecureBootEnabled -eq 1) {
                    $secureBootEnabled = $true
                    $detectionMethod = "Registry"
                } else {
                    $secureBootEnabled = $false
                    $detectionMethod = "Registry"
                }
            }
        } catch {
            Write-Host "Registry method failed: $($_.Exception.Message)"
        }
    }
    
    $Coms.Progress = 80
    
    # Evaluate results
    if ($detectionMethod -ne "") {
        if ($secureBootEnabled) {
            $Coms.Comment = "Secure Boot is enabled. (Detected via: $detectionMethod)"
            $Coms.Status = "Completed"
            $Coms.Progress = 100
        } else {
            $Coms.Comment = "Secure Boot is disabled. (Detected via: $detectionMethod)"
            $Coms.Status = "Warning"
            $Coms.Progress = 100
            $Coms.CustomExit = @{
                Type = "BIOS"
                Message = "Secure Boot is disabled."
            }
        }
    } else {
        # Could not determine Secure Boot status
        $Coms.Comment = "Could not determine Secure Boot status. System may not support UEFI Secure Boot."
        $Coms.Status = "Warning"
        $Coms.Progress = 100
    }
    
} catch {
    $Coms.Status = "Failed"
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Progress = 0
    $Coms.Comment = "Error checking Secure Boot: $($_.Exception.Message)"
}

# Script ends naturally here - no Exit statements needed
Write-Host "CheckSecureBoot script completed with status: $($Coms.Status)"