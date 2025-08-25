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

$disableSuccess = $false
$changesApplied = 0
$Coms.Status = "Running"
$Coms.Comment = "Starting Fast Startup disable process"
$Coms.Progress = 1

Try {
    $Coms.Comment = "Checking Fast Startup status and system requirements"
    $Coms.Progress = 10
    
    # Check if running as administrator (required for power management changes)
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        $errorMsg = "This script must be run as Administrator to modify power management settings."
        $Coms.ErrorMessage = $errorMsg
        $Coms.Status = "Failed"
        $Coms.Progress = 0
        throw $errorMsg
    }
    
    Write-Host "Running as Administrator - proceeding with Fast Startup configuration"
    
    # Check current Fast Startup status
    $Coms.Comment = "Checking current Fast Startup configuration"
    $Coms.Progress = 15
    
    $fastStartupCurrentlyEnabled = $false
    $hibernationEnabled = $false
    
    # Check hibernation status (Fast Startup requires hibernation to be enabled)
    try {
        $hibernationInfo = powercfg /query SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE 2>$null
        if ($hibernationInfo -and ($hibernationInfo -join " ") -notmatch "does not exist|not found") {
            Write-Host "Hibernation is available on this system"
            $hibernationEnabled = $true
        } else {
            Write-Host "Hibernation may not be available on this system"
        }
    } catch {
        Write-Host "Could not determine hibernation status: $($_.Exception.Message)"
    }
    
    # Check Fast Startup registry setting
    $fastStartupRegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
    $fastStartupValueName = "HiberbootEnabled"
    
    try {
        if (Test-Path $fastStartupRegPath) {
            $currentValue = Get-ItemProperty -Path $fastStartupRegPath -Name $fastStartupValueName -ErrorAction SilentlyContinue
            if ($currentValue -and $currentValue.$fastStartupValueName -eq 1) {
                $fastStartupCurrentlyEnabled = $true
                Write-Host "Fast Startup is currently ENABLED"
            } else {
                Write-Host "Fast Startup is currently DISABLED"
            }
        } else {
            Write-Host "Fast Startup registry path not found - may not be supported on this system"
        }
    } catch {
        Write-Host "Could not check Fast Startup registry status: $($_.Exception.Message)"
    }
    
    # Check via powercfg command as additional verification
    try {
        $powercfgOutput = powercfg /a 2>$null
        if ($powercfgOutput -and ($powercfgOutput -join " ") -match "fast startup|hybrid sleep") {
            Write-Host "Fast Startup features detected via powercfg"
        }
    } catch {
        Write-Host "Could not check power configuration via powercfg"
    }
    
    Write-Host "Current status - Fast Startup: $fastStartupCurrentlyEnabled, Hibernation: $hibernationEnabled"
    
    if (-not $fastStartupCurrentlyEnabled) {
        $Coms.Comment = "Fast Startup is already disabled. No changes needed."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
        Write-Host "Fast Startup is already disabled - task completed"
        return
    }
    
    # Disable Fast Startup using registry method
    $Coms.Comment = "Disabling Fast Startup via registry modification"
    $Coms.Progress = 30
    
    try {
        Write-Host "Disabling Fast Startup via registry..."
        
        # Ensure the registry path exists
        if (-not (Test-Path $fastStartupRegPath)) {
            New-Item -Path $fastStartupRegPath -Force | Out-Null
            Write-Host "Created registry path: $fastStartupRegPath"
        }
        
        # Set HiberbootEnabled to 0 (disabled)
        Set-ItemProperty -Path $fastStartupRegPath -Name $fastStartupValueName -Value 0 -Type DWord -Force
        Write-Host "✓ Set HiberbootEnabled registry value to 0"
        $changesApplied++
        
        # Verify the change
        $verifyValue = Get-ItemProperty -Path $fastStartupRegPath -Name $fastStartupValueName -ErrorAction SilentlyContinue
        if ($verifyValue -and $verifyValue.$fastStartupValueName -eq 0) {
            Write-Host "✓ Registry change verified successfully"
        } else {
            Write-Host "⚠ Could not verify registry change" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "Error modifying registry: $($_.Exception.Message)" -ForegroundColor Red
        # Continue with other methods
    }
    
    # Disable Fast Startup using powercfg command
    $Coms.Comment = "Disabling Fast Startup via powercfg command"
    $Coms.Progress = 50
    
    try {
        Write-Host "Disabling Fast Startup via powercfg command..."
        
        # Use powercfg to disable hibernation temporarily and re-enable it without Fast Startup
        $result = powercfg /hibernate off 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Hibernation disabled via powercfg"
            Start-Sleep -Seconds 2
            
            # Re-enable hibernation (this should not re-enable Fast Startup due to registry setting)
            $result2 = powercfg /hibernate on 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Hibernation re-enabled without Fast Startup"
                $changesApplied++
            } else {
                Write-Host "⚠ Could not re-enable hibernation: $result2" -ForegroundColor Yellow
            }
        } else {
            Write-Host "⚠ Could not disable hibernation: $result" -ForegroundColor Yellow
        }
        
    } catch {
        Write-Host "Error using powercfg command: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Additional power management optimizations
    $Coms.Comment = "Applying additional power management optimizations"
    $Coms.Progress = 70
    
    try {
        # Disable hybrid sleep (related to Fast Startup)
        Write-Host "Disabling hybrid sleep..."
        $hybridSleepResult = powercfg /change standby-timeout-ac 0 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Hybrid sleep configuration updated"
            $changesApplied++
        } else {
            Write-Host "⚠ Could not modify hybrid sleep: $hybridSleepResult" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Could not modify hybrid sleep settings: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    try {
        # Set power button action to shutdown (not sleep/hibernate)
        Write-Host "Configuring power button to perform shutdown..."
        $powerButtonResult = powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3 2>&1
        if ($LASTEXITCODE -eq 0) {
            $powerButtonResult2 = powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS PBUTTONACTION 3 2>&1
            if ($LASTEXITCODE -eq 0) {
                # Apply the changes
                powercfg /setactive SCHEME_CURRENT 2>&1 | Out-Null
                Write-Host "✓ Power button configured for clean shutdown"
                $changesApplied++
            } else {
                Write-Host "⚠ Could not set DC power button action: $powerButtonResult2" -ForegroundColor Yellow
            }
        } else {
            Write-Host "⚠ Could not set AC power button action: $powerButtonResult" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Could not configure power button action: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Final verification
    $Coms.Comment = "Verifying Fast Startup has been disabled"
    $Coms.Progress = 85
    
    try {
        Write-Host "Performing final verification..."
        Start-Sleep -Seconds 2
        
        # Check registry value again
        $finalCheck = Get-ItemProperty -Path $fastStartupRegPath -Name $fastStartupValueName -ErrorAction SilentlyContinue
        if ($finalCheck -and $finalCheck.$fastStartupValueName -eq 0) {
            Write-Host "✓ Final verification: Fast Startup is disabled in registry"
            $disableSuccess = $true
        } else {
            Write-Host "⚠ Final verification: Registry value may not be set correctly" -ForegroundColor Yellow
        }
        
        # Check powercfg output
        $finalPowercfgCheck = powercfg /a 2>$null
        if ($finalPowercfgCheck) {
            Write-Host "Current power states available:"
            $finalPowercfgCheck | ForEach-Object { Write-Host "  $($_)" }
        }
        
    } catch {
        Write-Host "Could not perform final verification: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Final status
    $Coms.Progress = 90
    
    if ($changesApplied -gt 0) {
        $disableSuccess = $true
        $Coms.Comment = "Fast Startup disabled successfully. Applied $changesApplied configuration(s)."
        $Coms.Progress = 100
        $Coms.Status = "Completed"
        
        # Recommend restart for full effect
        $Coms.ExitType = "Restart"
        $Coms.ExitMessage = "System restart recommended to ensure Fast Startup is fully disabled."
        
        Write-Host "Fast Startup has been disabled successfully!" -ForegroundColor Green
        Write-Host "Applied $changesApplied configuration changes" -ForegroundColor Green
    } else {
        $Coms.Comment = "Could not disable Fast Startup - no changes were applied."
        $Coms.Progress = 0
        $Coms.Status = "Failed"
        Write-Host "No changes were successfully applied to disable Fast Startup" -ForegroundColor Red
    }
    
} Catch {
    # Provide detailed error information
    $errorDetails = $_.Exception.Message
    $errorType = $_.Exception.GetType().Name
    $scriptLineNumber = $_.InvocationInfo.ScriptLineNumber
    
    $detailedError = "Fast Startup disable failed - Type: $errorType, Line: $scriptLineNumber, Message: $errorDetails"
    
    Write-Host "Critical error in Fast Startup disable process:" -ForegroundColor Red
    Write-Host "  Error Type: $errorType" -ForegroundColor Red
    Write-Host "  Line Number: $scriptLineNumber" -ForegroundColor Red
    Write-Host "  Message: $errorDetails" -ForegroundColor Red
    
    # Set detailed error information for the UI
    $Coms.ErrorMessage = $detailedError
    $Coms.Comment = "Fast Startup disable failed: $errorDetails"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    # Additional context based on common error scenarios
    if ($errorDetails -match "Access.*denied|Unauthorized|Permission") {
        $Coms.Comment = "Access denied - ensure you're running as Administrator"
        Write-Host "Suggestion: Ensure script is running as Administrator" -ForegroundColor Yellow
    } elseif ($errorDetails -match "Registry|Key.*not.*found") {
        $Coms.Comment = "Registry access issue - Windows version may not support Fast Startup"
        Write-Host "Suggestion: Fast Startup may not be available on this Windows version" -ForegroundColor Yellow
    } elseif ($errorDetails -match "powercfg|Power") {
        $Coms.Comment = "Power management tools not available or accessible"
        Write-Host "Suggestion: Try running 'sfc /scannow' to repair system files" -ForegroundColor Yellow
    }
    
}
