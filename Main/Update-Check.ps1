# Preparation Script for the update process
# It verifies information relevant to the update process like settings and internet connectivity.

# Check for internet helper module to facilitate internet check if not present, fallback to basic checks
$DownloadSites = @{
    "FrysixFTPStatus" = $false
    "GitHubStatus" = $false
}
$ModuleStatus = $false
$WasDownloaded = $false

Try {
    if (Test-Path -Path "$PSScriptRoot\Helper\InternetHelper.psm1") {
        Import-Module "$PSScriptRoot\Helper\InternetHelper.psm1" -Force
        $ModuleStatus = $true
    } else {
        $ModuleStatus = $false
    }
    if (-not (Test-Connection 8.8.8.8 -Count 1 -Quiet)) {
        Throw "No Internet Connection / Unstable Connection."
    }
    Try {
        if (-not (Test-Path -path "$env:TEMP\FPCA_Temp")) {
            New-Item -Path "$env:TEMP\FPCA_Temp" -ItemType Directory -Force | Out-Null
        }
        If ($ModuleStatus) {
            $DownloadSites.FrysixFTPStatus = Get-HttpWebSiteStatus -Url "https://ftp.frysix.com"
            if ($DownloadSites.FrysixFTPStatus) {
                if (Test-Path -Path "$PSScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1") {
                    $Coms = [hashtable]::Synchronized(@{})
                    ."$PSScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1" -Coms $Coms -Url "https://fpca-updater.frysix.com" -OutputFile "$env:TEMP\FPCA_Temp\UpdaterPackage.zip" -ChunkNumber 1
                    if ($Coms.Status -eq "Failed") {
                        Throw "Download failed"
                    }
                    if (Test-Path -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip") {
                        Expand-Archive -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip" -DestinationPath "$env:TEMP\FPCA_Temp" -Force
                        if (Test-Path -Path "$env:TEMP\FPCA_Temp\Updater\Start-Updater.bat") {
                            $WasDownloaded = $true
                        }
                    } else {
                        Throw "Downloaded file not found"
                    }
                } else {
                    Throw "Threaded-InstallerV2.ps1 not found"
                }
            } else {
                Throw "FTP Server is not reachable"
            }
        } else {
            Throw "Module Not Found"
        }
    } Catch {
        $DownloadSites.GitHubStatus = Test-Connection github.com -Count 1 -Quiet
        if (-not $DownloadSites.GitHubStatus) {
            Throw "GitHub is not reachable"
        }
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/main/UpdaterPackage.zip" -OutFile "$env:TEMP\FPCA_Temp\UpdaterPackager.zip"
        if (Test-Path -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip") {
            Expand-Archive -Path "$env:TEMP\FPCA_Temp\UpdaterPackage.zip" -DestinationPath "$env:TEMP\FPCA_Temp" -Force
            if (Test-Path -Path "$env:TEMP\FPCA_Temp\Updater\Start-Updater.bat") {
                $WasDownloaded = $true
            }
        } else {
            Throw "Downloaded file not found"
        }
    } Finally {
        if ($WasDownloaded) {
            Start-Process -FilePath "$env:TEMP\FPCA_Temp\Updater\Start-Updater.bat" -WindowStyle Hidden -Verb RunAs
            $DownloadResult = "Success"
        } else {
            $DownloadResult = "Failed"
            Throw "The updater could not be downloaded."
        }
    }
} Catch {
    $DownloadResult = "Failed"
    Write-Host "Error during update check: $($_.Exception.Message)"
}

Return $DownloadResult