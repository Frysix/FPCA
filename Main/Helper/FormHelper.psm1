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
