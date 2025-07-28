# Checks for the presence of TPM and its configuration status.
Param(
    [Parameter(Mandatory=$true)]
    [Hashtable]$Coms,
    [Parameter(Mandatory=$true)]
    [string]$TaskName,
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot
)

$Coms.Status = "Running"
$Coms.Progress = 10

try {
    Write-Host "Checking for TPM presence and configuration..."
    $Coms.Comment = "Checking for TPM presence..."
    
    # Method 1: Try Get-Tpm (PowerShell 5.1+ / Windows 10+)
    $tpmStatus = $null
    $tpmPresent = $false
    $tpmEnabled = $false
    $tpmActivated = $false
    
    try {
        $tpmStatus = Get-Tpm -ErrorAction Stop
        $tpmPresent = $tpmStatus.TpmPresent
        $tpmEnabled = $tpmStatus.TpmEnabled
        $tpmActivated = $tpmStatus.TpmActivated
        Write-Host "TPM Status retrieved using Get-Tpm cmdlet"
    } catch {
        Write-Host "Get-Tpm cmdlet not available, trying WMI method..."
        
        # Method 2: Try WMI approach
        try {
            $tpm = Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm -ErrorAction Stop
            if ($tpm) {
                $tpmPresent = $tpm.IsPresent_InitialValue
                $tpmEnabled = $tpm.IsEnabled_InitialValue
                $tpmActivated = $tpm.IsActivated_InitialValue
                Write-Host "TPM Status retrieved using WMI"
            }
        } catch {
            Write-Host "WMI method failed, trying alternative approach..."
            
            # Method 3: Try alternative WMI namespace
            try {
                $tpm = Get-CimInstance -Namespace "Root\CIMv2\Security\MicrosoftTpm" -ClassName Win32_Tpm -ErrorAction Stop
                if ($tpm) {
                    $tpmPresent = $tpm.IsPresent_InitialValue
                    $tpmEnabled = $tpm.IsEnabled_InitialValue
                    $tpmActivated = $tpm.IsActivated_InitialValue
                    Write-Host "TPM Status retrieved using CIM"
                }
            } catch {
                Write-Host "All TPM detection methods failed. TPM may not be present or accessible."
                $Coms.Progress = 100
                $Coms.Status = "Warning"
                $Coms.Comment = "TPM status could not be determined."
                return
            }
        }
    }
    
    $Coms.Progress = 50
    
    if ($tpmPresent) {
        Write-Host "TPM is present."
        $Coms.Comment = "TPM is present."
        
        # Check if TPM is enabled and activated
        if ($tpmEnabled -and $tpmActivated) {
            Write-Host "TPM is enabled and activated."
            $Coms.Progress = 100
            $Coms.Comment = "TPM is enabled and activated."
            $Coms.Status = "Completed"
        } else {
            $Coms.Progress = 100
            $Coms.Comment = "TPM needs to be enabled in BIOS."
            $Coms.Status = "Warning"
            $Coms.CustomExit = @{
                Type = "BIOS"
                Message = "TPM is present but not enabled or activated."
            }
        }
    } else {
        Write-Host "TPM is not present on this system."
        $Coms.Progress = 100
        $Coms.Comment = "TPM is not present on this system."
        $Coms.Status = "Warning"
    }
    
} catch {
    Write-Host "Error checking TPM: $($_.Exception.Message)" -ForegroundColor Red
    $Coms.Status = "Failed"
    $Coms.Progress = 0
    $Coms.Comment = "Error checking TPM: $($_.Exception.Message)"
}