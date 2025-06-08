using System;
using System.Diagnostics;
using System.IO;

class Program
{
    static void Main()
    {
        string batPath = Path.Combine(Path.GetTempPath(), "prep_script.bat");

        // Write the corrected batch content
        string batchContent = @"@echo on
            powershell -NoExit -ExecutionPolicy Bypass -NoProfile -Command ""$scriptPath = Join-Path $env:TEMP 'Installer.ps1'; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Frysix/FPCA/main/Installer/Installer.ps1' -OutFile $scriptPath; & $scriptPath"" ^ ";

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