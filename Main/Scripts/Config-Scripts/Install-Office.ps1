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
$Coms.Progress = 1
$Coms.Comment = "Starting Office installation..."

Try {
    # Validate input
    if (-not ($TaskSettings.ContainsKey('InputCombo') -and $TaskSettings.InputCombo -ne $null)) {
        Throw "No Office version selected."
    }

    # Determine installation steps based on selected Office version
    Switch ($TaskSettings.InputCombo) {
        "Office 365 Pro" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/t3x2vzchnuooa62z-hbgtw/FRCA_OfficeSetup_O365BusinessRetail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365BusinessRetail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 365 Home" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/lohscihhskmquitggss2vw/FRCA_OfficeSetup_O365HomePremRetail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365HomePremRetail&platform=x64&language=fr-ca&version=O16GA"
            }
        }
        "Office 2024 Pro" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/l8uefewgukqrkxa0a9sx_w/FRCA_OfficeSetup_HomeBusiness2024Retail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeBusiness2024Retail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2024 Home" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/v53mywop30mmfmjji6rpca/FRCA_OfficeSetup_Home2024Retail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Home2024Retail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2021 Pro" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/zdsawofbjucz6rsqvzn29a/FRCA_OfficeSetup_HomeBusiness2021Retail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeBusiness2021Retail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2021 Home" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/oartdhoavkmdnsrafb-g4q/FRCA_OfficeSetup_HomeStudent2021Retail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeStudent2021Retail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2019 Pro" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/sr3iamnhi0e8bucjejruma/FRCA_OfficeSetup_HomeBusiness2019Retail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeBusiness2019Retail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2019 Home" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/vegh8jo8cuknejqq3ogkdw/FRCA_OfficeSetup_HomeStudent2019Retail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeStudent2019Retail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2016 Pro" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/rxiy5ku7yus2uw4vbqtjyg/FRCA_OfficeSetup_HomeBusinessRetail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeBusinessRetail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2016 Home" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/6wfzbzcc-0cshbvnudlhca/FRCA_OfficeSetup_HomeStudentRetail.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeStudentRetail&platform=x64&language=fr-ca&version=O16GA"
            }
        } 
        "Office 2013 Pro" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/md75w9qbx0oexiyik4popq/setuphomebusinessretail.x64.fr-fr_.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeBusinessRetail&platform=x64&language=fr-fr&version=O15GA"
            }
        } 
        "Office 2013 Home" {
            $DownloadUrls = @{
                "WebInstaller_1" = "https://ftp.frysix.com/public/file/zm1wdaiiz0waqalbfgpe9w/setuphomestudentretail.x64.fr-fr_.exe"
                "WebInstaller_2" = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=HomeStudentRetail&platform=x64&language=fr-fr&version=O15GA"
            }
        } 
        Default {
            Throw "Selected Office version is not supported."
        }
    }

    # Test internet connectivity and server availability
    $Coms.Comment = "Importing required helper modules..."
    $Coms.Progress = 3
    if (-not (Test-Path -Path "$ScriptRoot\Helper\InternetHelper.psm1")) {
        Throw "Required helper module 'InternetHelper.psm1' not found."
    }
    Import-Module -Name "$ScriptRoot\Helper\InternetHelper.psm1" -Force -ErrorAction Stop
    $Coms.Comment = "Testing internet connectivity..."
    $Coms.Progress = 5
    $LoopCount = 0
    While (-not (Get-InternetStatus)) {
        Start-Sleep -Seconds 5
        $LoopCount++
        if ($LoopCount -ge 10) {
            Throw "No internet connectivity. Please check your network settings."
        }
    }
    $Coms.Comment = "Internet connectivity confirmed. Testing download server availability..."
    $Coms.Progress = 7
    $FinalUrls = @{}
    Foreach ($Url in $DownloadUrls.Keys) {
        $Result = Get-HttpWebSiteStatus -Url $DownloadUrls[$Url]
        if ($Result) {
            $FinalUrls[$Url] = $DownloadUrls[$Url]
        }
    }
    if ($FinalUrls.Count -le 0) {
        Throw "No available download servers. Please try again later."
    }
    $Coms.Comment = "Download servers are reachable. Starting Office installation..."
    $Coms.Progress = 10
    $InstallDir = "$env:USERPROFILE\Downloads\OfficeSetup.exe"
    if (Test-Path -Path $InstallDir) {
        Remove-Item -Path $InstallDir -Force -ErrorAction SilentlyContinue
    }
    $DownloadSuccess = $false
    $TriedUrls = @()
    While (-not $DownloadSuccess) {
        # Sort URLs by priority: _1 first, then _2, then _3, etc.
        $SortedUrls = $FinalUrls.Keys | Sort-Object {
            if ($_ -match '_(\d+)$') {
                [int]$matches[1]  # Extract the number after underscore for sorting
            } else {
                999  # Put items without number pattern at the end
            }
        }
        
        $UrlFound = $false
        Foreach ($UrlKey in $SortedUrls) {
            $CurrentUrl = $FinalUrls[$UrlKey]
            if ($TriedUrls -contains $CurrentUrl) {
                Continue
            }
            
            $Coms.Comment = "Attempting download from: $UrlKey"
            $Coms.Progress = 15
            
            Try {
                # Add the URL to tried list before attempting
                $TriedUrls += $CurrentUrl
                
                # Attempt to download the file using modern HttpClient method
                $DownloadResult = Start-DownloadFileWithHttpClient -Url $CurrentUrl -OutputPath $InstallDir
                
                # Verify the download was successful
                if ($DownloadResult -and (Test-Path -Path $InstallDir) -and (Get-Item -Path $InstallDir).Length -gt 0) {
                    $Coms.Comment = "Download successful from: $UrlKey"
                    $DownloadSuccess = $true
                    $UrlFound = $true
                    break
                } else {
                    $Coms.Comment = "Download failed from: $UrlKey (file empty or not found)"
                    if (Test-Path -Path $InstallDir) {
                        Remove-Item -Path $InstallDir -Force -ErrorAction SilentlyContinue
                    }
                }
            } Catch {
                $Coms.Comment = "Download failed from: $UrlKey - Error: $($_.Exception.Message)"
                if (Test-Path -Path $InstallDir) {
                    Remove-Item -Path $InstallDir -Force -ErrorAction SilentlyContinue
                }
            }
        }
        
        # If we've tried all URLs and none worked, exit the loop
        if (-not $UrlFound -or $TriedUrls.Count -ge $FinalUrls.Count) {
            if (-not $DownloadSuccess) {
                Throw "Failed to download Office installer from all available sources."
            }
            break
        }
    }
    
    # If download was successful, proceed with installation
    if ($DownloadSuccess -and (Test-Path -Path $InstallDir)) {
        $Coms.Comment = "Starting Office installation..."
        $Coms.Progress = 50
        
        Try {
            # Run the Office installer
            $Coms.Comment = "Installing Office..."
            $Coms.Progress = 70
            $InstallProcess = Start-Process -FilePath $InstallDir -ArgumentList "/silent" -Wait -PassThru -ErrorAction Stop
            
            if ($InstallProcess.ExitCode -eq 0) {
                $Coms.Comment = "Office installation completed successfully."
                $Coms.Progress = 90
            } else {
                Throw "Office installation failed with exit code: $($InstallProcess.ExitCode)"
            }
        } Catch {
            Throw "Failed to start Office installation: $($_.Exception.Message)"
        } Finally {
            # Clean up the downloaded installer
            if (Test-Path -Path $InstallDir) {
                Remove-Item -Path $InstallDir -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    $Coms.Comment = "Office installation task completed successfully."
    $Coms.Progress = 100
    $Coms.Status = "Completed"
} Catch {
    $Coms.Progress = 0
    $Coms.ErrorMessage = "Error: $_"
    $Coms.Status = "Failed"
    Exit 1
}