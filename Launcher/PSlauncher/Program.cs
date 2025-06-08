using System;
using System.Diagnostics;
using System.IO;

class Program
{
    static void Main()
    {
        string batPath = Path.Combine(Path.GetTempPath(), "FPCAinstaller.bat");

        // Write the corrected batch content
        string batchContent = @"@echo off
            powershell -ExecutionPolicy Bypass -NoProfile -Command ""$scriptPath = Join-Path $env:TEMP 'Installer.ps1'; [int]$loops = 0; while (-not (test-connection 8.8.8.8 -count 1 -quiet)) {if ($loops -lt 5) {Add-Type -AssemblyName System.Windows.Forms; $result = [System.Windows.Forms.MessageBox]::Show('Please connect to internet before continuing', 'FPCA Installer', [System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Error); if ($result -eq [System.Windows.Forms.DialogResult]::No) {Exit}; $loops++} else {$result = [System.Windows.Forms.MessageBox]::Show('Max Tries Reached! Closing...', 'FPCA Installer', [System.Windows.Forms.MessageBoxButtons]::Yes,[System.Windows.Forms.MessageBoxIcon]::Error); Exit}}; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Frysix/FPCA/main/Installer/Installer.ps1' -OutFile $scriptPath; & $scriptPath"" ^ ";

        File.WriteAllText(batPath, batchContent);

        ProcessStartInfo psi = new ProcessStartInfo("cmd.exe", "/c \"" + batPath + "\"")
        {
            Verb = "runas", // UAC elevation
            UseShellExecute = true
        };

        try
        {
            Process.Start(psi);
        }
        catch (Exception ex)
        {
            Console.WriteLine("User declined elevation or error occurred: " + ex.Message);
        }
    }
}