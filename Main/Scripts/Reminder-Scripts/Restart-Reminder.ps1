# Reminder script to restart the computer
# Uses PowerHelper module and FormHelper to perform restart and create scheduled tasks for reminders

# Start by checking required files integrity
$RequiredFiles = @(
    "PowerHelper.psm1",
    "FormHelper.psm1",
    "Restart-Reminder.ps1",
    "RestartOptions-Ui.ps1",
    "RemindLater-Ui.ps1"
)

# Check if all required files exist
foreach ($file in $RequiredFiles) {
    $filePath = Join-Path -Path $PSScriptRoot -ChildPath $file
    if (-not (Test-Path -Path $filePath)) {
        Throw "Required file not found: $filePath"
    }
}
# Import necessary Assemblies
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
# Import necessary modules
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath "PowerHelper.psm1") -Force
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath "FormHelper.psm1") -Force

# Initialize variables
$Global:UiHash = [hashtable]::Synchronized(@{})
$Global:UiHash.ChosenOption = "NoRestart"

# Dot source the UI
. (Join-Path -Path $PSScriptRoot -ChildPath "RestartOptions-Ui.ps1")

# Add event handlers for buttons
$RESTARTOPTIONS_RESTARTPC_BUTTON.Add_Click({
    $Global:UiHash.ChosenOption = "RestartPC"
    $RESTARTOPTIONS_FORM.Close()
})
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.Add_Click({
    $Global:UiHash.ChosenOption = "RestartBIOS"
    $RESTARTOPTIONS_FORM.Close()
})
$RESTARTOPTIONS_RESTARTRE_BUTTON.Add_Click({
    $Global:UiHash.ChosenOption = "RestartRE"
    $RESTARTOPTIONS_FORM.Close()
})
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.Add_Click({
    $Global:UiHash.ChosenOption = "RestartFPCA"
    $RESTARTOPTIONS_FORM.Close()
})
$RESTARTOPTIONS_REMINDLATER_BUTTON.Add_Click({
    $Global:UiHash.ChosenOption = "RemindLater"
    $RESTARTOPTIONS_FORM.Close()
})
$RESTARTOPTIONS_NORESTART_BUTTON.Add_Click({
    $Global:UiHash.ChosenOption = "NoRestart"
    $RESTARTOPTIONS_FORM.Close()
})

# Show the form
$RESTARTOPTIONS_FORM.ShowDialog()

# Before entering switch if the option is not "RemindLater", ensure any existing reminder tasks are removed and ensure to create a self-deletion task for this script
if ($Global:UiHash.ChosenOption -ne "RemindLater" -and $Global:UiHash.ChosenOption -ne "NoRestart" -and $Global:UiHash.ChosenOption -ne "RestartFPCA") {
    New-ScheduledSelfDelete -OnRestart -ScriptPath $PSScriptRoot
}

# Handle the chosen option
Switch ($Global:UiHash.ChosenOption) {
    "RestartPC" {
        $Result = Restart-ComputerCustom -Normal -DelaySecs 10 -MaxRestartAttempts 5
        if ($Result.Result) {
            Write-Host "System restart initiated successfully."
        } else {
            Show-TopMostMessageBox -Message "Failed to restart the computer. Please restart manually." -Title "FPCA - Restart Failed" -Icon "Error"
        }
    }
    "RestartBIOS" {
        $Result = Restart-ComputerCustom -BIOS -DelaySecs 10 -MaxRestartAttempts 5
        if ($Result.Result) {
            Write-Host "System restart into BIOS initiated successfully."
        } else {
            Show-TopMostMessageBox -Message "Failed to restart the computer into BIOS. Please restart manually." -Title "FPCA - Restart Failed" -Icon "Error"
        }
    }
    "RestartRE" {
        $Result = Restart-ComputerCustom -WinRE -DelaySecs 10 -MaxRestartAttempts 5
        if ($Result.Result) {
            Write-Host "System restart into Recovery Environment initiated successfully."
        } else {
            Show-TopMostMessageBox -Message "Failed to restart the computer into Recovery Environment. Please restart manually." -Title "FPCA - Restart Failed" -Icon "Error"
        }
    }
    "RestartFPCA" {
        if (Test-Path -Path "$PSScriptRoot\FPCA_Path.txt") {
            $FPCAPath = Get-Content -Path "$PSScriptRoot\FPCA_Path.txt"
            $FPCAPath.Trim()
            if (Test-Path -Path $FPCAPath) {
                Start-Process -FilePath "$FPCAPath\Start.bat" -WindowStyle Hidden -Verb RunAs
            } else {
                Show-TopMostMessageBox -Message "FPCA installation path not found. Cannot restart into FPCA." -Title "FPCA - Restart Failed" -Icon "Error"
            }
        } else {
            Show-TopMostMessageBox -Message "FPCA installation path not found. Cannot restart into FPCA." -Title "FPCA - Restart Failed" -Icon "Error"
        }
        New-ScheduledSelfDelete -OnTime -DelaySecs 10 -ScriptPath $PSScriptRoot
    }
    "NoRestart" {
        New-ScheduledSelfDelete -OnTime -DelaySecs 10 -ScriptPath $PSScriptRoot
    }
    "RemindLater" {
        $Global:UiHash.DefaultMins = "15"
        $Global:UiHash.ButtonResult = $false
        # Dot source the RemindLater UI
        . (Join-Path -Path $PSScriptRoot -ChildPath "RemindLater-Ui.ps1")
        # Add event handlers for buttons
        $REMINDER_CONFIRM_BUTTON.Add_Click({
            $Global:UiHash.ButtonResult = $true
            $Global:UiHash.SelectedMins = $REMINDER_MINS_INPUT_TEXTBOX.Text
            $RESTARTREMINDER_FORM.Close()
        })
        $REMINDER_CANCEL_BUTTON.Add_Click({
            $Global:UiHash.ButtonResult = $false
            $RESTARTREMINDER_FORM.Close()
        })
        # Force Textbox to only accept numbers.
        $REMINDER_MINS_INPUT_TEXTBOX.Add_KeyPress({
            if (-not ([char]::IsControl($_.KeyChar) -or [char]::IsDigit($_.KeyChar))) {
                $_.Handled = $true
            }
        })
        # Estimated time at which the restart will occur.
        $CurrentTime = Get-Date
        $DefaultMinsParsed = 0
        if (-not [int]::TryParse([string]$Global:UiHash.DefaultMins, [ref]$DefaultMinsParsed)) {
            $DefaultMinsParsed = 15   # fallback default
            $Global:UiHash.DefaultMins = $DefaultMinsParsed
        }
        $EstimatedTime = $CurrentTime.AddMinutes($DefaultMinsParsed)
        $REMINDER_ESTIMATEDTIME_LABEL.Text = "Reminder scheduled for: $($EstimatedTime.ToString('HH:mm'))"

        # Live update when user changes minutes
        $REMINDER_MINS_INPUT_TEXTBOX.Add_TextChanged({
            param($sender,$e)
            $val = $sender.Text.Trim()
            $n = 0
            if ([int]::TryParse($val, [ref]$n)) {
                if ($n -lt 0) { $n = 0 }
                if ($n -gt 1440) { $n = 1440 }
                $Global:UiHash.DefaultMins = $n
                $now = Get-Date
                $REMINDER_ESTIMATEDTIME_LABEL.Text = "Reminder scheduled for: $($now.AddMinutes($n).ToString('HH:mm'))"
            }
        })
        $REMINDER_MINS_INPUT_TEXTBOX.Text = $Global:UiHash.DefaultMins

        # Show the form
        $RESTARTREMINDER_FORM.ShowDialog()

        # After form is closed, check if confirmed or canceled
        if ($Global:UiHash.ButtonResult) {
            $Result = New-ScheduledRestartReminder -DelayMins $Global:UiHash.SelectedMins -SkipCopy
            if ($Result.Result -eq $false) {
                Show-TopMostMessageBox -Message "Failed to schedule a reminder. Please try again." -Title "FPCA - Reminder Failed" -Icon "Error"
            }
        } else {
            # User canceled. Relaunch Restart-Reminder script.
            . "$PSScriptRoot\Restart-Reminder.ps1"
        }
    }
}

# Script end