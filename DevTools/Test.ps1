Write-Host $PSScriptRoot

# If the UI is minimized, wait until it is restored to continue processing.
    While ($Global:UiHash.MainForm.WindowState -eq [System.Windows.Forms.FormWindowState]::Minimized) {
        $MinimizedTickCounter++
        Write-Host "UI is minimized! Minimized Tick Count: $MinimizedTickCounter" -ForegroundColor Yellow
        # Sleep for a short duration to prevent high CPU usage while waiting for the UI to be restored.
        Start-Sleep -Milliseconds 500
    }








[]
Link1=
ZipName=
Folder=
Executable=
Type=
Category=