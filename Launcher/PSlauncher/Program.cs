using System;
using System.Diagnostics;
using System.IO;

class Program
{
    static void Main()
    {
        string batPath = Path.Combine(Path.GetTempPath(), "prep_script.bat");

        // Write batch content (you can expand this)
        File.WriteAllText(batPath, @"@echo off
        powershell -ExecutionPolicy Bypass -Command ^
        ""$scriptPath = Join-Path $env:TEMP 'setup.ps1'; ^
        Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/setup.ps1' -OutFile $scriptPath; ^
        powershell -ExecutionPolicy Bypass -File $scriptPath""
        ");

        // Run the .bat with elevated permissions
        ProcessStartInfo psi = new ProcessStartInfo("cmd.exe", "/c \"" + batPath + "\"");
        psi.Verb = "runas"; // â† Triggers UAC prompt for admin
        psi.UseShellExecute = true;

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