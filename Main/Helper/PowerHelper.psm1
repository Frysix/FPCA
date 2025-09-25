# Module to help with power-related tasks
# Helps with app self deletion and system shutdown/restart

function New-ScheduledSelfDelete {
    Param (
        [Parameter(Mandatory=$true,ParameterSetName="OnRestart")]
        [switch]$OnRestart,
        [Parameter(Mandatory=$true,ParameterSetName="OnTime")]
        [switch]$OnTime,
        [Parameter(Mandatory=$false)]
        [int]$DelaySecs = 5, 
        [Parameter(Mandatory=$true)]
        [string]$ScriptPath,
        [Parameter(Mandatory=$false)]
        [string]$TaskName = "DeleteFPCA_$(Get-Random)"
    )
    Try {
        if (-not (Test-Path -Path $ScriptPath)) {
            Throw "Script path '$ScriptPath' does not exist."
        }
        if ($OnRestart) {
            # Create a scheduled task to delete the script after a restart
            $trigger = New-ScheduledTaskTrigger -AtLogOn
        } elseif ($OnTime) {
            # Create a scheduled task to delete the script after a specified time delay
            $triggerTime = (Get-Date).AddSeconds($DelaySecs)
            $trigger = New-ScheduledTaskTrigger -Once -At $triggerTime
        } else {
            Throw "Either -OnRestart or -OnTime must be specified."
        }

        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"Write-Host 'Task Started'; Start-Sleep -Seconds 2; Write-Host 'Deleting main app folder'; if (Test-Path -Path '$ScriptRoot') {Remove-Item -Path '$ScriptRoot' -Recurse -Force; Write-Host 'Successfully Deleted: ${ScriptRoot}' -ForegroundColor Green} else {Write-Host 'Unable to find folder for deletion skipping...' -ForegroundColor Red}; Write-Host 'Deleting installer file'; if (Test-Path -Path '${env:USERPROFILE}\Downloads\FPCA Installer.exe') {Remove-Item -Path '${env:USERPROFILE}\Downloads\FPCA Installer.exe' -Recurse -Force; Write-Host 'Successfully Deleted: ${env:USERPROFILE}\Downloads\FPCA Installer.exe' -ForegroundColor Green} else {Write-Host 'No installer found, skipping deletion...' -ForegroundColor Yellow}; Unregister-ScheduledTask -TaskName '$TaskName' -Confirm:`$false; Write-Host 'Task Unregistered' -ForegroundColor Green; Start-Sleep -Seconds 2; Write-Host 'Exiting PowerShell'`""

        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable:$false -WakeToRun:$false -Compatibility Win8
        $settings.ExecutionTimeLimit = "PT10M"  # 10 minute timeout
        $settings.Priority = 4  # Higher priority
        $settings.MultipleInstances = "IgnoreNew"  # Prevent multiple instances

        # Register the scheduled task
        $task = Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest

        $createdTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
        if ($createdTask) {
            Enable-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
            Return $Result = @{
                Result = $true
                TaskName = $TaskName
            }
        } else {
            Throw "Failed to create scheduled task."
        }

    } Catch {
        Return $Result = @{
            Error = $_.Exception.Message
            Result = $false
        }
    }
}

# Function to restart the computer
function Restart-ComputerCustom {
    Param (
        [Parameter(Mandatory=$true,ParameterSetName="BIOS")]
        [switch]$BIOS,
        [Parameter(Mandatory=$true,ParameterSetName="Normal")]
        [switch]$Normal,
        [Parameter(Mandatory=$true,ParameterSetName="WinRE")]
        [switch]$WinRE,
        [Parameter(Mandatory=$true,ParameterSetName="Shutdown")]
        [switch]$Shutdown,
        [Parameter(Mandatory=$false)]
        [int]$DelaySecs = 5,
        [Parameter(Mandatory=$false)]
        [int]$MaxRestartAttempts = 3
    )
    Try {
        $ExitCode = 6942069 # Arbitrary non-zero to enter the loop
        $Attempt = 0
        While ($ExitCode -ne 0 -and $Attempt -le $MaxRestartAttempts) {
            $Attempt++
            if ($BIOS) {
                # Restart to BIOS/UEFI settings
                Write-Host "Restarting to BIOS/UEFI settings in $DelaySecs seconds..." -ForegroundColor Yellow
                shutdown.exe /r /fw /t $DelaySecs /f 2>&1
            } elseif ($WinRE) {
                # Restart to Windows Recovery Environment (WinRE)
                Write-Host "Restarting to Windows Recovery Environment in $DelaySecs seconds..." -ForegroundColor Yellow
                shutdown.exe /r /o /t $DelaySecs /f 2>&1
            } elseif ($Normal) {
                # Normal restart
                Write-Host "Restarting computer in $DelaySecs seconds..." -ForegroundColor Yellow
                shutdown.exe /r /t $DelaySecs /f 2>&1
            } elseif ($Shutdown) {
                # Shutdown the computer
                Write-Host "Shutting down computer in $DelaySecs seconds..." -ForegroundColor Yellow
                shutdown.exe /s /t $DelaySecs /f 2>&1
            } else {
                Throw "One of -BIOS, -Normal, -Shutdown, or -WinRE must be specified."
            }
            $ExitCode = $LASTEXITCODE
        }
        if ($ExitCode -eq 0) {
            Return $Result = @{
                Result = $true
                Message = "Restart command issued successfully."
            }
        } else {
            Throw "Failed to initiate restart after $MaxRestartAttempts attempts. Last exit code: $ExitCode"
        }
    } Catch {
        Return $Result = @{
            Message = $_.Exception.Message
            Result = $false
        }
    }
}