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
$Coms.Comment = "Configuring desktop icons"
$Coms.Progress = 20

Try {
    # Registry path for desktop icons
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    
    $Coms.Comment = "Setting desktop icon visibility"
    $Coms.Progress = 50
    
    # Create registry path if it doesn't exist
    if (!(Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    
    # Show only the requested icons (set to 0 = visible)
    Set-ItemProperty -Path $regPath -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Type DWord  # This PC
    Set-ItemProperty -Path $regPath -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Value 0 -Type DWord  # Control Panel
    Set-ItemProperty -Path $regPath -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 0 -Type DWord  # User Folder
    
    # Refresh the desktop
    $Coms.Comment = "Refreshing desktop"
    $Coms.Progress = 80
    
    # Force Windows to refresh the desktop icons
    $signature = @'
[DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = true)]
public static extern void SHChangeNotify(uint wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);
'@
    $type = Add-Type -MemberDefinition $signature -Name Win32Utils -Namespace SHChangeNotify -PassThru
    $type::SHChangeNotify(0x8000000, 0x1000, [IntPtr]::Zero, [IntPtr]::Zero)
    
    $Coms.Comment = "Desktop icons configured successfully"
    $Coms.Progress = 100
    $Coms.Status = "Completed"
    
    Write-Host "Desktop icons configured: This PC, Control Panel, and User Folder are now visible" -ForegroundColor Green
    
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Comment = "Failed to configure desktop icons"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}