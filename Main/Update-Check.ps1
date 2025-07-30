# Preparation Script for the update process
# It verifies information relevant to the update process like settings and internet connectivity.

# Check for internet helper module to facilitate internet check if not present, fallback to basic checks
$DownloadSites = @{
    "FrysixFTPStatus" = $false
    "GitHubStatus" = $false
}
$ModuleStatus = $false
$WasDownloaded = $false
$DownloadSuccess = $false

Try {
    # Check for InternetHelper module
    if (Test-Path -Path "$PSScriptRoot\Helper\InternetHelper.psm1") {
        Import-Module "$PSScriptRoot\Helper\InternetHelper.psm1" -Force
        $ModuleStatus = $true
    } else {
        $ModuleStatus = $false
    }
    
    # Basic internet connectivity check
    if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
        Throw "No Internet Connection / Unstable Connection."
    }
    
    # Create temp directory
    if (-not (Test-Path -path "$env:TEMP\FPCA_Temp")) {
        New-Item -Path "$env:TEMP\FPCA_Temp" -ItemType Directory -Force | Out-Null
    }
    
    # Try Method 1: FTP Server with Threaded Installer (if module is available)
    if ($ModuleStatus) {
        Try {
            $DownloadSites.FrysixFTPStatus = Get-HttpWebSiteStatus -Url "https://ftp.frysix.com"
            if ($DownloadSites.FrysixFTPStatus) {
                if (Test-Path -Path "$PSScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1") {
                    $Coms = [hashtable]::Synchronized(@{})
                    . "$PSScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1" -Coms $Coms -Url "https://fpca-updater.frysix.com" -OutputFile "$env:TEMP\FPCA_Temp\UpdaterPackage" -ChunkNumber 1
                    
                    if ($Coms.Status -eq "Completed") {
                        if (Test-Path -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip") {
                            Expand-Archive -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip" -DestinationPath "$env:TEMP\FPCA_Temp" -Force
                            if (Test-Path -Path "$env:TEMP\FPCA_Temp\Updater\Start-Updater.bat") {
                                $WasDownloaded = $true
                            }
                        } else {
                            Throw "Downloaded file not found"
                        }
                    } else {
                        Throw "FTP Download failed"
                    }
                } else {
                    Throw "Threaded-InstallerV2.ps1 not found"
                }
            } else {
                Throw "FTP Server is not reachable"
            }
        } Catch {
            # FTP method failed, continue to GitHub fallback
            Write-Host "FTP method failed: $($_.Exception.Message)"
        }
    }
    
    # Method 2: GitHub Fallback (if FTP failed or module not available)
    if (-not $WasDownloaded) {
        $DownloadSites.GitHubStatus = Test-Connection github.com -Count 1 -Quiet
        if (-not $DownloadSites.GitHubStatus) {
            Throw "GitHub is not reachable"
        }
        Write-Host "Downloading updater package from GitHub..."
        Invoke-WebRequest -Uri "https://github.com/Frysix/FPCA/raw/refs/heads/main/UpdaterPackage.zip" -OutFile "$env:TEMP\FPCA_Temp\UpdaterPackage.zip"
        if (Test-Path -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip") {
            Expand-Archive -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip" -DestinationPath "$env:TEMP\FPCA_Temp" -Force
            if (Test-Path -Path "$env:TEMP\FPCA_Temp\Updater\Start-Updater.bat") {
                Write-Host "Updater package downloaded and extracted successfully."
                $WasDownloaded = $true
            }
        } else {
            Throw "Downloaded file not found"
        }
    }
    
    # Process results
    if ($WasDownloaded) {
        if (Test-Path -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip") {
            Remove-Item -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip" -Force
        }
        
        # Write to a txt file in the TEMP folder to give relevant information about the active installation and settings.
        $PSScriptRoot | Out-File -FilePath "$env:TEMP\FPCA_Temp\OldInstallPath.txt" -Encoding UTF8 -Force
        
        Start-Process -FilePath "$env:TEMP\FPCA_Temp\Updater\Start-Updater.bat" -WindowStyle Hidden -Verb RunAs
        $DownloadSuccess = $true
    } else {
        $DownloadSuccess = $false
    }
    
} Catch {
    $DownloadSuccess = $false
    Write-Host "Error during update check: $($_.Exception.Message)"
} Finally {
    # This section handles the final steps based on the download success. This handles how the Start.bat file will continue after this script was executed.
    if ($DownloadSuccess) {
        New-Item -Path "$PSScriptRoot\UpdaterInstalled.txt" -ItemType File -Force | Out-Null
    } else {
        Add-Type -AssemblyName System.Windows.Forms
        $result = [System.Windows.Forms.MessageBox]::Show("Update check failed. Could not install updater package. Do you want to start the Application as is?", "FPCA - Error", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Error)
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            New-Item -Path "$PSScriptRoot\UpdateFailedLaunch.txt" -ItemType File -Force | Out-Null
        }
    }
}