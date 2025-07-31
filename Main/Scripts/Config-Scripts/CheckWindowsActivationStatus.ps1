# Config Script for FPCA that checks Windows activation status
# Standard Parameters structure for config scripts
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
$Coms.Comment = "Checking Windows activation status..."

try {
    Write-Host "Starting Windows activation status check..."
    
    # Initialize variables
    $activationStatus = $null
    $productKey = $null
    $productName = $null
    $detectionMethod = ""
    
    $Coms.Progress = 25
    $Coms.Comment = "Querying Windows licensing information..."
    
    # Method 1: Try using SoftwareLicensingProduct WMI class (Primary method)
    try {
        Write-Host "Attempting WMI SoftwareLicensingProduct query..."
        
        # Get Windows license information
        $licenseInfo = Get-WmiObject -Query "SELECT * FROM SoftwareLicensingProduct WHERE ApplicationId='55c92734-d682-4d71-983e-d6ec3f16059f' AND PartialProductKey IS NOT NULL" -ErrorAction Stop
        
        if ($licenseInfo) {
            $activationStatus = $licenseInfo.LicenseStatus
            $productKey = $licenseInfo.PartialProductKey
            $productName = $licenseInfo.Name
            $detectionMethod = "WMI SoftwareLicensingProduct"
            Write-Host "License information retrieved via WMI"
        }
        
    } catch {
        Write-Host "WMI method failed: $($_.Exception.Message)"
    }
    
    $Coms.Progress = 50
    
    # Method 2: Try using slmgr.vbs command if WMI failed
    if (-not $activationStatus -and $detectionMethod -eq "") {
        try {
            Write-Host "Attempting slmgr.vbs query..."
            $Coms.Comment = "Checking activation via slmgr..."
            
            # Run slmgr /xpr to get activation status
            $processInfo = New-Object System.Diagnostics.ProcessStartInfo
            $processInfo.FileName = "cscript"
            $processInfo.Arguments = "//nologo $env:WINDIR\System32\slmgr.vbs /xpr"
            $processInfo.RedirectStandardOutput = $true
            $processInfo.RedirectStandardError = $true
            $processInfo.UseShellExecute = $false
            $processInfo.CreateNoWindow = $true
            
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $processInfo
            $process.Start() | Out-Null
            $slmgrOutput = $process.StandardOutput.ReadToEnd()
            $slmgrError = $process.StandardError.ReadToEnd()
            $process.WaitForExit()
            
            if ($process.ExitCode -eq 0 -and $slmgrOutput) {
                if ($slmgrOutput -match "permanently activated" -or $slmgrOutput -match "will never expire") {
                    $activationStatus = 1  # Licensed/Activated
                } elseif ($slmgrOutput -match "expires|trial|grace") {
                    $activationStatus = 5  # Notification/Grace period
                } else {
                    $activationStatus = 0  # Unlicensed
                }
                $detectionMethod = "slmgr.vbs"
                Write-Host "Activation status retrieved via slmgr"
            } else {
                Write-Host "slmgr failed with exit code $($process.ExitCode): $slmgrError"
            }
            
        } catch {
            Write-Host "slmgr method failed: $($_.Exception.Message)"
        }
    }
    
    $Coms.Progress = 75
    
    # Method 3: Try using licensingdiag.exe as fallback
    if (-not $activationStatus -and $detectionMethod -eq "") {
        try {
            Write-Host "Attempting licensingdiag.exe query..."
            $Coms.Comment = "Checking activation via licensing diagnostics..."
            
            $licensingDiagPath = "$env:WINDIR\System32\licensingdiag.exe"
            if (Test-Path $licensingDiagPath) {
                $processInfo = New-Object System.Diagnostics.ProcessStartInfo
                $processInfo.FileName = $licensingDiagPath
                $processInfo.Arguments = "-report $env:TEMP\LicenseReport.txt"
                $processInfo.RedirectStandardOutput = $true
                $processInfo.RedirectStandardError = $true
                $processInfo.UseShellExecute = $false
                $processInfo.CreateNoWindow = $true
                
                $process = New-Object System.Diagnostics.Process
                $process.StartInfo = $processInfo
                $process.Start() | Out-Null
                $process.WaitForExit()
                
                if ($process.ExitCode -eq 0 -and (Test-Path "$env:TEMP\LicenseReport.txt")) {
                    $reportContent = Get-Content "$env:TEMP\LicenseReport.txt" -Raw
                    if ($reportContent -match "License Status.*Licensed") {
                        $activationStatus = 1
                    } else {
                        $activationStatus = 0
                    }
                    $detectionMethod = "licensingdiag.exe"
                    Remove-Item "$env:TEMP\LicenseReport.txt" -Force -ErrorAction SilentlyContinue
                    Write-Host "Activation status retrieved via licensingdiag"
                }
            }
            
        } catch {
            Write-Host "licensingdiag method failed: $($_.Exception.Message)"
        }
    }
    
    $Coms.Progress = 90
    $Coms.Comment = "Analyzing activation results..."
    
    # Evaluate results
    if ($detectionMethod -ne "") {
        # Interpret activation status codes
        $statusMessage = switch ($activationStatus) {
            0 { "Unlicensed" }
            1 { "Licensed" }
            2 { "Out-of-Box Grace Period" }
            3 { "Out-of-Tolerance Grace Period" }
            4 { "Non-Genuine Grace Period" }
            5 { "Notification" }
            6 { "Extended Grace" }
            default { "Unknown Status ($activationStatus)" }
        }
        
        Write-Host "Windows Activation Status: $statusMessage (Code: $activationStatus)"
        if ($productName) { Write-Host "Product: $productName" }
        if ($productKey) { Write-Host "Partial Product Key: *****-$productKey" }
        Write-Host "Detection Method: $detectionMethod"
        
        # Set completion status based on activation
        if ($activationStatus -eq 1) {
            $Coms.Comment = "Windows is activated and licensed. Product: $($productName -replace '^Microsoft Windows ', '')"
            $Coms.Status = "Completed"
            $Coms.Progress = 100
        } elseif ($activationStatus -in @(2, 3, 5, 6)) {
            $Coms.Comment = "Windows activation status: $statusMessage - May require attention"
            $Coms.Status = "Warning"
            $Coms.Progress = 100
        } else {
            $Coms.Comment = "Windows is not activated: $statusMessage"
            $Coms.Status = "Warning"
            $Coms.Progress = 100
        }
        
    } else {
        # Could not determine activation status
        Write-Host "Could not determine Windows activation status"
        $Coms.Comment = "Could not determine Windows activation status. Manual verification may be required."
        $Coms.Status = "Warning"
        $Coms.Progress = 100
    }
    
} catch {
    Write-Host "Error checking Windows activation: $($_.Exception.Message)" -ForegroundColor Red
    $Coms.Status = "Failed"
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Progress = 0
    $Coms.Comment = "Error checking Windows activation: $($_.Exception.Message)"
}

Write-Host "CheckWindowsActivationStatus script completed with status: $($Coms.Status)"