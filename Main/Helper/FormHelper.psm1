# Module for handling form-related operations in PowerShell
# Importing necessary assemblies for Windows Forms functionality.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
[System.Windows.Forms.Application]::EnableVisualStyles()

# This module provides functions to create and manage forms, including showing message boxes.
# Enhanced Show-TopMostMessageBox function for FormHelper.psm1
function Show-TopMostMessageBox {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Information', 'Warning', 'Error', 'Question')][string]$Icon = 'Information',
        [Parameter(Mandatory=$false)]
        [System.Windows.Forms.IWin32Window]$Owner = $null,
        [Parameter(Mandatory=$false)]
        $Buttons,
        [Parameter(Mandatory=$false)]
        [switch]$ForceTopMost
    )
    
    if (-not $Buttons) {
        $Buttons = [System.Windows.Forms.MessageBoxButtons]::OK
    } elseif ($Buttons -is [string]) {
        $Buttons = [System.Windows.Forms.MessageBoxButtons]::Parse([System.Windows.Forms.MessageBoxButtons], $Buttons)
    }
    
    # Convert Icon string to enum
    $IconEnum = [System.Windows.Forms.MessageBoxIcon]::Parse([System.Windows.Forms.MessageBoxIcon], $Icon)
    
    try {
        # Check for the presence of an Owner window for the message box.
        if ($Owner -ne $null -and -not $ForceTopMost) {
            # If an owner is provided, show the message box with the owner window.
            $Owner.TopMost = $true
            $Owner.Activate()
            $Owner.Focus()
            return [System.Windows.Forms.MessageBox]::Show($Owner, $Message, $Title, $Buttons, $IconEnum)
        } else {
            # Create a more robust topmost form for app closing scenarios
            $TopFormTemp = New-Object System.Windows.Forms.Form
            
            # Enhanced properties for better topmost behavior during app shutdown
            $TopFormTemp.TopMost = $true
            $TopFormTemp.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual
            $TopFormTemp.Location = New-Object System.Drawing.Point(-32000, -32000)  # Move far offscreen
            $TopFormTemp.Size = New-Object System.Drawing.Size(1, 1)
            $TopFormTemp.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
            $TopFormTemp.ShowInTaskbar = $false
            $TopFormTemp.WindowState = [System.Windows.Forms.FormWindowState]::Normal  # Don't minimize
            $TopFormTemp.Opacity = 0.01  # Nearly invisible but not completely transparent
            
            # These properties help maintain topmost during shutdown
            $TopFormTemp.ControlBox = $false
            $TopFormTemp.MaximizeBox = $false
            $TopFormTemp.MinimizeBox = $false
            $TopFormTemp.AllowTransparency = $true
            
            try {
                # Show the form and ensure it's established in the window hierarchy
                $TopFormTemp.Show()
                
                # Force the form to be topmost and active
                $TopFormTemp.TopMost = $true
                $TopFormTemp.BringToFront()
                $TopFormTemp.Activate()
                
                # Small delay to ensure form is fully established
                Start-Sleep -Milliseconds 50
                
                # Show the MessageBox with enhanced topmost handling
                $Result = [System.Windows.Forms.MessageBox]::Show($TopFormTemp, $Message, $Title, $Buttons, $IconEnum)
                
                return $Result
                
            } finally {
                # Clean up the temporary form
                try {
                    if ($TopFormTemp -and -not $TopFormTemp.IsDisposed) {
                        $TopFormTemp.Close()
                        $TopFormTemp.Dispose()
                    }
                } catch {
                    # Ignore disposal errors during shutdown
                }
            }
        }
        
    } catch {
        Write-Host "Error in Show-TopMostMessageBox: $($_.Exception.Message)" -ForegroundColor Yellow
        
        # Ultimate fallback - use Windows API to force topmost
        try {
            # Load user32.dll for SetWindowPos API
            Add-Type -TypeDefinition @"
                using System;
                using System.Runtime.InteropServices;
                public class Win32 {
                    [DllImport("user32.dll", SetLastError = true)]
                    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
                    [DllImport("user32.dll")]
                    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
                    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
                    public const uint SWP_NOMOVE = 0x0002;
                    public const uint SWP_NOSIZE = 0x0001;
                    public const uint SWP_SHOWWINDOW = 0x0040;
                }
"@ -ErrorAction SilentlyContinue
            
            # Show basic MessageBox
            $Result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $IconEnum)
            
            # Try to make the MessageBox topmost using Windows API
            $MessageBoxHandle = [Win32]::FindWindow("#32770", $Title)
            if ($MessageBoxHandle -ne [IntPtr]::Zero) {
                [Win32]::SetWindowPos($MessageBoxHandle, [Win32]::HWND_TOPMOST, 0, 0, 0, 0, [Win32]::SWP_NOMOVE -bor [Win32]::SWP_NOSIZE -bor [Win32]::SWP_SHOWWINDOW)
            }
            
            return $Result
            
        } catch {
            # Final fallback - basic MessageBox
            return [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $IconEnum)
        }
    }
}

# Function to create a credentials prompt form
Function Show-CredentialsPrompt {
    Param(
        [Parameter(Mandatory=$false)]
        [string]$Message = "Please enter the required connection information below:",
        [Parameter(Mandatory=$false)]
        [switch]$UseEmail = $false,
        [Parameter(Mandatory=$false)]
        [switch]$TopMost = $false
    )
    # Enter try block to catch any errors during form creation or display
    Try {
        # Get parent folder of the current script
        $ParentFolder = Split-Path -Parent $PSScriptRoot
        # Test for the existence of CredentialsPrompt-Ui.ps1 script
        if (-not (Test-Path -Path "$ParentFolder\Scripts\Ui-Scripts\CredentialsPrompt-Ui.ps1")) {
            Throw "CredentialsPrompt-Ui.ps1 not found in $ParentFolder\Scripts\Ui-Scripts"
        }
        # Create result hashtable as a synchronized hashtable
        $Result = [hashtable]::Synchronized(@{
            Status = "Cancelled"
            ErrorMessage = "User cancelled the operation."
        })
        # Import the CredentialsPrompt-Ui.ps1 script
        . "$ParentFolder\Scripts\Ui-Scripts\CredentialsPrompt-Ui.ps1"
        # Add actions to the buttons
        $CREDSPROMPT_CONFIRM_BUTTON.Add_Click({
            $CONFIRM = $true
            if ($UseEmail) {
                if ([string]::IsNullOrWhiteSpace($CREDSPROMPT_USERNAME_TEXTBOX.Text)) {
                    Show-TopMostMessageBox -Message "Email adress cannot be empty." -Title "Invalid Email" -Icon "Error" -Buttons "OK" -Owner $CREDSPROMPT_FORM -ForceTopMost:$TopMost
                    $CONFIRM = $false
                } else {
                    if ($CREDSPROMPT_USERNAME_TEXTBOX.Text -notmatch '^[^@\s]+@[^@\s]+\.[^@\s]+$') {
                        Show-TopMostMessageBox -Message "Please enter a valid email address." -Title "Invalid Email" -Icon "Error" -Buttons "OK" -Owner $CREDSPROMPT_FORM -ForceTopMost:$TopMost
                        $CONFIRM = $false
                    }
                }
            } else {
                if ([string]::IsNullOrWhiteSpace($CREDSPROMPT_USERNAME_TEXTBOX.Text)) {
                    Show-TopMostMessageBox -Message "Username cannot be empty." -Title "Invalid Username" -Icon "Error" -Buttons "OK" -Owner $CREDSPROMPT_FORM -ForceTopMost:$TopMost
                    $CONFIRM = $false
                }
            }
            if ([string]::IsNullOrWhiteSpace($CREDSPROMPT_PASSWORD_TEXTBOX.Text)) {
                Show-TopMostMessageBox -Message "Password cannot be empty." -Title "Invalid Password" -Icon "Error" -Buttons "OK" -Owner $CREDSPROMPT_FORM -ForceTopMost:$TopMost
                $CONFIRM = $false
            }
            if ($CONFIRM) {
                $Result.Status = "Success"
                $Result.Username = $CREDSPROMPT_USERNAME_TEXTBOX.Text
                $Result.Password = $CREDSPROMPT_PASSWORD_TEXTBOX.Text
                $Result.ErrorMessage = $null
                $CREDSPROMPT_FORM.Close()
            }
        })
        $CREDSPROMPT_CANCEL_BUTTON.Add_Click({
            $CREDSPROMPT_FORM.Close()
        })
        # Set custom message label
        $CREDSPROMPT_CUSTOMTEXT_LABEL.Text = $Message
        # Adjust username label if using email
        if ($UseEmail) {
            $CREDSPROMPT_USERNAME_LABEL.Text = "Email Address:"
        } else {
            $CREDSPROMPT_USERNAME_LABEL.Text = "Username:"
        }
        # Set form to be topmost if specified
        if ($TopMost) {
            $CREDSPROMPT_FORM.TopMost = $true
        } else {
            $CREDSPROMPT_FORM.TopMost = $false
        }
        # Show the form as a dialog
        $CREDSPROMPT_FORM.ShowDialog()
        # Return the result hashtable
        Return $Result
    } Catch {
        Return $Result = @{
            Status = "Failed"
            ErrorMessage = "Error: $($_.Exception.Message)"
        }
    }
}