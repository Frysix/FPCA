# File-Installer.ps1
# Description: Installs files based on references defined in a JSON file.
# This script can be used both from a command line and as part of a larger script.
# It is designed to be modular, reusable, and in or out of a Runspace environment.
Param (
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot,
    [Parameter(Mandatory=$false)]
    [string]$RefFilePath = "",
    [Parameter(Mandatory=$false)]
    [string]$RefName = "",
    [Parameter(Mandatory=$false)]
    [string]$CustomURL = "",
    [Parameter(Mandatory=$false)]
    [string]$CustomFileType = "",
    [Parameter(Mandatory=$false)]
    [string]$CustomSubFolder = "",
    [Parameter(Mandatory=$false)]
    [string]$RefVersion = "Default",
    [Parameter(Mandatory=$false)]
    [int]$PreferredURL = 0,
    [Parameter(Mandatory=$false)]
    [int]$MaxAttempts = 3,
    [Parameter(Mandatory=$false)]
    [int]$TimeoutSeconds = 120,
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "",
    [Parameter(Mandatory=$false)]
    [switch]$DoNotExtract = $false,
    [Parameter(Mandatory=$false)]
    [hashtable]$ComsChannel = [hashtable]::Synchronized(@{})
)
# Try Catch block to handle errors
Try {
    $ComsChannel.Status = "Initializing"
    $ComsChannel.Comment = "Prepping for download..."
    $ComsChannel.Progress = 0
    # Validate ScriptRoot path
    if (-not (Test-Path -Path $ScriptRoot)) {
        Throw "ScriptRoot path '$ScriptRoot' does not exist or is not accessible."
    }
    Write-Host "ScriptRoot: $ScriptRoot"
    # Determine the reference file path
    if ($RefFilePath -eq "") {
        # Use default ref file if none is specified
        $RefFilePath = Join-Path -Path $ScriptRoot -ChildPath "Assets\refs\DefaultDownloadsRefs.json"
    } else {
        # Validate if the provided ref file is a json file and if the path exists
        if ([System.IO.Path]::GetExtension($RefFilePath) -ne ".json") {
            Throw "RefFilePath '$RefFilePath' is not a valid JSON file."
        }
    }
    if (-not (Test-Path -Path $RefFilePath)) {
        Throw "RefFilePath '$RefFilePath' does not exist or is not accessible."
    }
    Write-Host "RefFilePath: $RefFilePath"
    # Determine the output path
    if ($OutputPath -eq "") {
        $OutputPath = Join-Path -Path $env:USERPROFILE -ChildPath "Downloads"
    }
    if (-not (Test-Path -Path $OutputPath)) {
        Throw "OutputPath '$OutputPath' does not exist or is not accessible."
    }
    Write-Host "OutputPath: $OutputPath"
    # Find and import parsing module
    $ParsingHelperPath = Join-Path -Path $ScriptRoot -ChildPath "Helper\ParsingHelper.psm1"
    if (-not (Test-Path -Path $ParsingHelperPath)) {
        Throw "ParsingHelper module not found at '$ParsingHelperPath'."
    }
    Write-Host "ParsingHelperPath: $ParsingHelperPath"
    Import-Module -Name $ParsingHelperPath -Force
    Write-Host "ParsingHelper module imported."
    # Initialize refs hashtable
    if ($CustomURL -ne "") {
        Write-Host "Custom URL provided. Overriding reference URL."
        # Create a custom refs hashtable
        if ($RefName -eq "") {
            $RefName = "CustomRef"
        }
        if ($RefVersion -eq "") {
            $RefVersion = "Default"
        }
        if ($CustomFileType -eq "") {
            $CustomFileType = "exe"
        }
        if ($CustomSubFolder -eq "") {
            $Refs = @{
                "References" = @{
                    $RefName = @{
                        "DefaultVersion" = $RefVersion
                        "Versions" = @{
                            $RefVersion = @{
                                "DL_1" = @{
                                    "Url" = $CustomURL
                                    "FileType" = $CustomFileType
                                }
                            }
                        }
                    }
                }
            }
        } elseif ($CustomSubFolder -ne "" -and $CustomFileType -eq "zip") {
            $Refs = @{
                "References" = @{
                    $RefName = @{
                        "DefaultVersion" = $RefVersion
                        "Versions" = @{
                            $RefVersion = @{
                                "DL_1" = @{
                                    "Url" = $CustomURL
                                    "FileType" = $CustomFileType
                                    "SubFolder" = $CustomSubFolder
                                }
                            }
                        }
                    }
                }
            }
        } else {
            Throw "CustomSubFolder can only be specified for zip file types."
        }
    } elseif ($CustomURL -eq "" -and $RefName -ne "") {
        # Use function from ParsingHelper to get the refs as a hashtable
        $Refs = Convert-JsonToHashtable -FilePath $RefFilePath
        Write-Host "Reference file parsed."
    } else {
        Throw "Either RefName or CustomURL must be provided, but not both or neither."
    }
    # Validate the structure of the refs hashtable
    if (-not ($Refs.ContainsKey("References"))) {
        Throw "Invalid reference file format. 'References' key not found."
    }
    # Validate the specified reference name
    if (-not ($Refs.References.ContainsKey($RefName))) {
        Throw "Reference name '$RefName' not found in the reference file."
    }
    Write-Host "Reference '$RefName' found."
    # Get the specific reference entry
    $RefEntry = $Refs.References[$RefName]
    # Ref version handling
    if ($RefVersion -eq "Default" -or $RefVersion -eq "") {
        if ($RefEntry.ContainsKey("DefaultVersion") -and $RefEntry.DefaultVersion -ne "") {
            $RefVersion = $RefEntry.DefaultVersion
            Write-Host "Using default version '$RefVersion' for reference '$RefName'."
        } else {
            Throw "No DefaultVersion specified for reference '$RefName'. Please provide a version."
        }
    }
    # Validate the specified reference version
    Foreach ($version in $RefEntry.Versions.Keys) {
        if ($RefVersion -match $version) {
            $RefVersionExists = $true
            $SelectedVersion = $version
            Break
        }
    }
    Write-Host "Selected Version: $SelectedVersion"
    # If the requested version is not found, throw an error
    if ($RefVersionExists -eq $false) {
        Throw "Reference version '$RefVersion' not found for reference '$RefName'."
    }
    # Find and import InternetHelper module
    $InternetHelperPath = Join-Path -Path $ScriptRoot -ChildPath "Helper\InternetHelper.psm1"
    Write-Host "InternetHelperPath: $InternetHelperPath"
    if (-not (Test-Path -Path $InternetHelperPath)) {
        Throw "InternetHelper module not found at '$InternetHelperPath'."
    }
    Import-Module -Name $InternetHelperPath -Force
    Write-Host "InternetHelper module imported."
    # Test internet connectivity
    $TimeoutCounter = 0
    Write-Host "Checking internet connectivity..."
    While (-not (Get-InternetStatus)) {
        if ($TimeoutCounter -ge 7) {
            Throw "No internet connectivity detected after multiple attempts."
        }
        Start-Sleep -Seconds 1
        $TimeoutCounter++
    }
    Write-Host "Internet connectivity confirmed."
    # Import required Assemblies for web requests
    Add-Type -AssemblyName System.Net.Http, System.IO, System.Threading, System.Collections
    Write-Host "Required assemblies loaded."
    # Initialize download variables
    $TriedDLs = 0
    $SyncHash = [hashtable]::Synchronized(@{})
    # Start the download process
    Write-Host "Starting download process..."
    While ($true) {
        # Open Try block for download attempts
        Try {
            # Figure out if its the first iteration of the loop
            $ComsChannel.Comment = "Trying to download: '$RefName' Version: '$SelectedVersion' Attempt: $($TriedDLs + 1)/$MaxAttempts"
            if ($TriedDLs -le 0) {
                # Use preferred URL if specified
                $DLToTry = $PreferredURL
                if ($DLToTry -le 0) {
                    $DLToTry = 1
                }
            } else {
                # Use the next URL in the list
                $DLToTry = $TriedDLs + 1
            }
            Write-Host "Attempting download using URL index: $DLToTry"
            # Increment the tried downloads counter
            $TriedDLs++
            # Check if the download URL exists
            Foreach ($url in $RefEntry.Versions[$SelectedVersion].Keys) {
                if ($url -match '^DL_(\d+)$') {
                    $urlIndex = [int]$Matches[1]
                    if ($urlIndex -eq $DLToTry) {
                        $DownloadURLRef = $RefEntry.Versions[$SelectedVersion][$url]
                        Break
                    }
                }
            }
            # If no URL is found, throw an error
            if (-not $DownloadURLRef) {
                Throw "No download URL found for '$RefName' version '$SelectedVersion' at index '$DLToTry'."
            }
            Write-Host "Using download URL: $($DownloadURLRef.Url)"
            # Resolve any URL redirections and check reachability
            $FinalUrl = Resolve-RedirectUrl -Url $DownloadURLRef.Url
            # Determine if the URL is reachable
            $UrlStatus = Get-HttpWebSiteStatus -Url $FinalUrl -ReturnDetails
            # If reachable, proceed with the download
            if ($UrlStatus.IsReachable) {
                Write-Host "Final URL after redirection: $FinalUrl"
                Write-Host "URL is reachable. Status Code: $($UrlStatus.StatusCode)"
                # Ensure file length is greater than zero
                $DownloadFileLength = Get-HttpFileLength -Url $FinalUrl
                Write-Host "File length to download: $DownloadFileLength bytes"
                if ($DownloadFileLength -gt 0) {
                    Write-Host "File length is valid. Proceeding with download."
                    # Populate the synchronized hashtable with initial values
                    $SyncHash.FileName = "$($RefName)_$($SelectedVersion).$($DownloadURLRef.FileType)"
                    $SyncHash.DestinationPath = Join-Path -Path $OutputPath -ChildPath $SyncHash.FileName
                    $SyncHash.Url = $FinalUrl
                    if ($DownloadURLRef.FileType -eq "zip" -and $DoNotExtract -eq $false) {
                        Write-Host "File type is zip. Will extract after download."
                        $SyncHash.IsZip = $true
                        $ComsChannel.DownloadIsZip = $true
                        if ($DownloadURLRef.ContainsKey("SubFolder")) {
                            Write-Host "SubFolder specified for extraction: $($DownloadURLRef.SubFolder)"
                            $SyncHash.SubFolder = $DownloadURLRef.SubFolder
                        } else {
                            Write-Host "No SubFolder specified for extraction."
                            $SyncHash.SubFolder = $false
                        }
                    } else {
                        Write-Host "File type is not zip."
                        $SyncHash.IsZip = $false
                        $ComsChannel.DownloadIsZip = $false
                    }
                    $SyncHash.FileType = $DownloadURLRef.FileType
                    $SyncHash.FileLength = $DownloadFileLength
                    $SyncHash.TimeoutSeconds = $TimeoutSeconds
                    $SyncHash.DLProgress = @{
                        Status = "Initializing"
                        BytesReceived = 0L
                        ProgressPercent = 0
                        ErrorMessage = ""
                    }
                    $SyncHash.CaughtVerify = $false
                    $ComsChannel.Progress = 0
                    $ComsChannel.Status = "Initializing"
                    Write-Host "Download parameters set. Preparing to download '$($SyncHash.FileName)' to '$($SyncHash.DestinationPath)'."
                    # Create the runspace
                    Write-Host "Creating runspace for download..."
                    $DLRunspace = [runspacefactory]::CreateRunspace()
                    $DLRunspace.ApartmentState = "MTA"
                    $DLRunspace.ThreadOptions = "ReuseThread"
                    $DLRunspace.Open()
                    $DLRunspace.SessionStateProxy.SetVariable("SyncHash", $SyncHash)
                    $DLPowerShell = [powershell]::Create()
                    $DLPowerShell.Runspace = $DLRunspace
                    # Add the download script to the runspace
                    $Null = $DLPowerShell.AddScript({
                        # Define function to report progress
                        Function Update-DownloadProgress {
                            Param (
                                [hashtable]$SyncHash,
                                [int64]$BytesReceived,
                                [int]$ProgressPercent,
                                [string]$Status,
                                [string]$ErrorMessage = ""
                            )
                            $SyncHash.DLProgress.BytesReceived = $BytesReceived
                            $SyncHash.DLProgress.ProgressPercent = $ProgressPercent
                            $SyncHash.DLProgress.Status = $Status
                            if ($ErrorMessage -ne "" -and $SyncHash.DLProgress.Status -eq "Failed") {
                                $SyncHash.DLProgress.ErrorMessage = $ErrorMessage
                            }
                        }
                        # Open Try block for download process
                        Try {
                            # Import required assemblies
                            Add-Type -AssemblyName System.Net.Http, System.IO, System.Threading, System.Collections
                            # Start the download with progress tracking
                            $Client = New-Object System.Net.Http.HttpClient
                            $CancellationToken = New-Object System.Threading.CancellationTokenSource
                            $CancellationToken.CancelAfter([TimeSpan]::FromSeconds($SyncHash.TimeoutSeconds))
                            $Client.DefaultRequestHeaders.UserAgent.ParseAdd('FPCA_File-Installer/1.0')
                            $Response = $Client.GetAsync($SyncHash.Url, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead, $CancellationToken.Token).GetAwaiter().GetResult()
                            $Response.EnsureSuccessStatusCode()

                            Update-DownloadProgress -SyncHash $SyncHash -BytesReceived 0L -ProgressPercent 0 -Status "Downloading"

                            $ResponseStream = $Response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
                            $FileStream = [System.IO.File]::Open($SyncHash.DestinationPath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)

                            Try {
                                # Define buffer and variables for progress tracking
                                $Buffer = New-Object byte[] 81920
                                $BytesReceived = 0L
                                $SinceLastUpdate = 0L
                                [int64]$UpdateIntervalBytes = 32768 # Update every 32KB
                                # While loop to read from the response stream and write to the file stream
                                While ($true) {
                                    $Read = $ResponseStream.ReadAsync($Buffer, 0, $Buffer.Length, $CancellationToken.Token).GetAwaiter().GetResult()
                                    if ($Read -le 0) { 
                                        break 
                                    }
                                    $FileStream.Write($Buffer, 0, $Read)
                                    $BytesReceived += $Read
                                    $SinceLastUpdate += $Read
                                    if ($SinceLastUpdate -ge $UpdateIntervalBytes) {
                                        Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent ([math]::Round(($BytesReceived / $SyncHash.FileLength) * 100)) -Status "Downloading"
                                        $SinceLastUpdate = 0L
                                    }
                                }
                                # Final update to ensure 100% is reported
                                Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent 100 -Status "Verifying"
                            } Finally {
                                # Clean up streams
                                $FileStream.Close()
                                $ResponseStream.Close()
                            }
                            $Client.Dispose()
                            $CancellationToken.Dispose()
                            # Verify download file itegrity
                            if (-not (Test-Path -Path $SyncHash.DestinationPath)) {
                                Update-DownloadProgress -SyncHash $SyncHash -BytesReceived 0L -ProgressPercent 0 -Status "Failed"
                                Throw "Downloaded file not found at '$($SyncHash.DestinationPath)'."
                            }
                            if ((Get-Item -Path $SyncHash.DestinationPath).Length -ne $SyncHash.FileLength) {
                                Update-DownloadProgress -SyncHash $SyncHash -BytesReceived 0L -ProgressPercent 0 -Status "Failed"
                                Throw "Downloaded file size mismatch. Expected: $($SyncHash.FileLength), Actual: $((Get-Item -Path $SyncHash.DestinationPath).Length)."
                            }
                            # Wait for the main loop to pick up the Verifying status
                            While (-not $SyncHash.CaughtVerify) {
                                Start-Sleep -Milliseconds 500
                                Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent 100 -Status "Verified"
                            }
                            # If the file is a zip, extract it
                            if ($SyncHash.IsZip) {
                                Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent 0 -Status "Extracting"
                                if ($SyncHash.ContainsKey("SubFolder") -and $SyncHash.SubFolder -ne $false) {
                                    $SyncHash.ExtractPath = Split-Path -Path $SyncHash.DestinationPath -Parent
                                } else {
                                    $SyncHash.ExtractPath = [System.IO.Path]::Combine(
                                        [System.IO.Path]::GetDirectoryName($SyncHash.DestinationPath),
                                        [System.IO.Path]::GetFileNameWithoutExtension($SyncHash.DestinationPath)
                                    )
                                }

                                [void][System.IO.Directory]::CreateDirectory($SyncHash.ExtractPath)

                                Add-Type -AssemblyName System.IO.Compression.FileSystem

                                # Pre-scan totals
                                [int64]$TotalUncompressedSize = 0
                                [int]$TotalFiles = 0
                                $ZipFile = [System.IO.Compression.ZipFile]::OpenRead($SyncHash.DestinationPath)
                                foreach ($Entry in $ZipFile.Entries) {
                                    if (-not [string]::IsNullOrEmpty($Entry.Name)) {
                                        $TotalUncompressedSize += [int64]$Entry.Length
                                        $TotalFiles++
                                    }
                                }
                                $ZipFile.Dispose()

                                Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent 5 -Status "Extracting"

                                # Extract with throttled progress + zip-slip guard
                                [int64]$ExtractedBytes = 0
                                [int]$FilesProcessed = 0
                                [int64]$UpdateIntervalBytes = 256KB
                                [int]$UpdateIntervalMs = 200
                                [int64]$SinceLastUpdateBytes = 0
                                $sw = [System.Diagnostics.Stopwatch]::StartNew()

                                $ZipFile = [System.IO.Compression.ZipFile]::OpenRead($SyncHash.DestinationPath)
                                Try {
                                    $ExtractRootFull = [System.IO.Path]::GetFullPath($SyncHash.ExtractPath + [System.IO.Path]::DirectorySeparatorChar)

                                    foreach ($Entry in $ZipFile.Entries) {
                                        $DestinationPath = [System.IO.Path]::Combine($SyncHash.ExtractPath, $Entry.FullName)
                                        $FullDest = [System.IO.Path]::GetFullPath($DestinationPath)

                                        # Guard against path traversal
                                        if (-not $FullDest.StartsWith($ExtractRootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
                                            continue
                                        }

                                        # Directory entries
                                        if ([string]::IsNullOrEmpty($Entry.Name)) {
                                            [void][System.IO.Directory]::CreateDirectory($FullDest)
                                            continue
                                        }

                                        # Ensure parent directory exists
                                        $EntryDir = [System.IO.Path]::GetDirectoryName($FullDest)
                                        if ($EntryDir) { [void][System.IO.Directory]::CreateDirectory($EntryDir) }

                                        # Extract file with buffered copy
                                        $EntryStream = $Entry.Open()
                                        $FileStream = [System.IO.File]::Open($FullDest, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
                                        Try {
                                            $Buffer = New-Object byte[] 1048576  # 1MB buffer for large files
                                            while ($true) {
                                                $Read = $EntryStream.Read($Buffer, 0, $Buffer.Length)
                                                if ($Read -le 0) { break }
                                                $FileStream.Write($Buffer, 0, $Read)

                                                $ExtractedBytes += [int64]$Read
                                                $SinceLastUpdateBytes += [int64]$Read

                                                $shouldUpdate = ($SinceLastUpdateBytes -ge $UpdateIntervalBytes) -or ($sw.ElapsedMilliseconds -ge $UpdateIntervalMs)
                                                if ($shouldUpdate) {
                                                    if ($TotalUncompressedSize -gt 0) {
                                                        $ExtractProgress = [math]::Min(100, [math]::Round(($ExtractedBytes / $TotalUncompressedSize) * 100))
                                                    } elseif ($TotalFiles -gt 0) {
                                                        $ExtractProgress = [math]::Min(100, [math]::Round((($FilesProcessed) / $TotalFiles) * 100))
                                                    } else {
                                                        $ExtractProgress = 100
                                                    }
                                                    Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent $ExtractProgress -Status "Extracting"
                                                    $SinceLastUpdateBytes = 0
                                                    $sw.Restart()
                                                }
                                            }
                                        } Finally {
                                            $EntryStream.Close()
                                            $FileStream.Close()
                                        }

                                        $FilesProcessed++
                                        # Per-file update to keep UI moving even if totals are unknown
                                        if ($TotalUncompressedSize -eq 0 -and $TotalFiles -gt 0) {
                                            $ExtractProgress = [math]::Min(100, [math]::Round((($FilesProcessed) / $TotalFiles) * 100))
                                            Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent $ExtractProgress -Status "Extracting"
                                        }
                                    }
                                } Finally {
                                    $ZipFile.Dispose()
                                }

                                # Remove the archive
                                Remove-Item -Path $SyncHash.DestinationPath -Force -ErrorAction SilentlyContinue

                                if (-not (Test-Path -Path $SyncHash.ExtractPath)) {
                                    Throw "Extraction failed. Extracted path '$($SyncHash.ExtractPath)' not found."
                                }

                                Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent 100 -Status "Extracting"
                            }
                            # Final update to mark completion
                            Update-DownloadProgress -SyncHash $SyncHash -BytesReceived $BytesReceived -ProgressPercent 100 -Status "Completed"
                        } Catch [System.OperationCanceledException] {
                            Update-DownloadProgress -SyncHash $SyncHash -BytesReceived 0L -ProgressPercent 0 -Status "Failed" -ErrorMessage "Download timed out after $($SyncHash.TimeoutSeconds) seconds."
                            if (Test-Path -Path $SyncHash.DestinationPath) {
                                Remove-Item -Path $SyncHash.DestinationPath -Force
                            }
                        } Catch {
                            Update-DownloadProgress -SyncHash $SyncHash -BytesReceived 0L -ProgressPercent 0 -Status "Failed" -ErrorMessage $_.Exception.Message
                            if (Test-Path -Path $SyncHash.DestinationPath) {
                                Remove-Item -Path $SyncHash.DestinationPath -Force
                            }
                        } Finally {
                            # Clean up resources
                            if ($ResponseStream) {
                                $ResponseStream.Close()
                            }
                            if ($Response) {
                                $Response.Dispose()
                            }
                            if ($Client) {
                                $Client.Dispose()
                            }
                            if ($CancellationToken) {
                                $CancellationToken.Dispose()
                            }
                            if ($FileStream) {
                                $FileStream.Close()
                            }
                        }
                    })
                    # Register the event to monitor Runspace state and self dispose
                    $Null = Register-ObjectEvent -InputObject $DlPowerShell -EventName InvocationStateChanged -Action {
                        $State = $EventArgs.InvocationStateInfo.state
                        if ($State -in 'Completed', 'Failed') {
                            $DLPowerShell.EndInvoke($DLHandle)
                            $DLPowerShell.Runspace.Dispose()
                        }
                    }
                    # Start the download asynchronously
                    $DLHandle = $DLPowerShell.BeginInvoke()
                    Write-Host "Download started in runspace."
                    # Enter a loop to monitor the download
                    $RunFirstLoop = $true
                    Write-Host "Status: $($SyncHash.DLProgress.Status), Operation Progress: $($SyncHash.DLProgress.ProgressPercent)%, Total Progress: $($ComsChannel.Progress)%"
                    While ($RunFirstLoop) {
                        # Sleep for a short duration to avoid busy waiting
                        Start-Sleep -Milliseconds 250
                        # Check for Download Status
                        Switch ($SyncHash.DLProgress.Status) {
                            "Initializing" {
                                $ComsChannel.Status = "Initializing"
                            }
                            "Downloading" {
                                $ComsChannel.Status = "Downloading"
                                $ComsChannel.DownloadProgress = $SyncHash.DLProgress.ProgressPercent
                                if ($SyncHash.IsZip) {
                                    $ComsChannel.Progress = [math]::Round($SyncHash.DLProgress.ProgressPercent * 0.75)
                                } else {
                                    $ComsChannel.Progress = $SyncHash.DLProgress.ProgressPercent
                                }
                                Write-Host "Status: $($SyncHash.DLProgress.Status), Operation Progress: $($SyncHash.DLProgress.ProgressPercent)%, Total Progress: $($ComsChannel.Progress)%"
                            }
                            "Verifying" {
                                # File was Verified
                                $ComsChannel.Status = "Verifying"
                                $SyncHash.CaughtVerify = $true
                                Write-Host "Status: $($SyncHash.DLProgress.Status), Operation Progress: $($SyncHash.DLProgress.ProgressPercent)%, Total Progress: $($ComsChannel.Progress)%"
                                $RunFirstLoop = $false
                            }
                            "Failed" {
                                Throw "Download failed: $($SyncHash.DLProgress.ErrorMessage)"
                            }
                        }
                    }
                    # If the file was verified, check if it was a zip and handle extraction
                    Write-Host "Status: $($SyncHash.DLProgress.Status), Operation Progress: $($SyncHash.DLProgress.ProgressPercent)%, Total Progress: $($ComsChannel.Progress)%"
                    $SyncHash.DLProgress.ProgressPercent = 0
                    $RunSecondLoop = $true
                    While ($RunSecondLoop) {
                        # Sleep for a short duration to avoid busy waiting
                        Start-Sleep -Milliseconds 250
                        # Check for Extraction or Completion Status
                        Switch ($SyncHash.DLProgress.Status) {
                            "Extracting" {
                                $ComsChannel.Status = "Extracting"
                                $ComsChannel.DownloadProgress = 100
                                $ComsChannel.ExtractProgress = $SyncHash.DLProgress.ProgressPercent
                                $ComsChannel.Progress = 75 + [math]::Round($SyncHash.DLProgress.ProgressPercent * 0.25)
                                Write-Host "Status: $($SyncHash.DLProgress.Status), Operation Progress: $($SyncHash.DLProgress.ProgressPercent)%, Progress: $($ComsChannel.Progress)%"
                            }
                            "Completed" {
                                $ComsChannel.Status = "Download Completed"
                                $ComsChannel.ConfigReturn = "Completed"
                                if ($SyncHash.IsZip) {
                                    $ComsChannel.EndFilePath = "$($SyncHash.ExtractPath)\$($SyncHash.SubFolder)"
                                    $ComsChannel.ExtractProgress = 100
                                } else {
                                    $ComsChannel.EndFilePath = $SyncHash.DestinationPath
                                }
                                $ComsChannel.Progress = 100
                                $ComsChannel.DownloadProgress = 100
                                $ComsChannel.EndMessage = "File '$($SyncHash.FileName)' version '$SelectedVersion' installed successfully to '$OutputPath'."
                                Write-Host "Status: $($SyncHash.DLProgress.Status), Operation Progress: $($SyncHash.DLProgress.ProgressPercent)%, Total Progress: $($ComsChannel.Progress)%"
                                $RunSecondLoop = $false
                            }
                            "Failed" {
                                Throw "Download failed: $($SyncHash.DLProgress.ErrorMessage)"
                            }
                        }
                    }
                } else {
                    Write-Host "File length is zero or invalid."
                    Throw "File length for URL '$FinalUrl' is zero or invalid."
                }
            } else {
                Write-Host "URL is not reachable. Status Code: $($UrlStatus.StatusCode)"
                Throw "URL '$FinalUrl' is not reachable. Status Code: $($UrlStatus.StatusCode)"
            }
            # Exit the main download loop
            Break
        } Catch { 
            # If an error occurs, check if we have remaining attempts
            Write-Host "Error during: '$($ComsChannel.Status)' process. Download attempt: ${TriedDLs}. Error Message: $($_.Exception.Message). Error Occured at line: "
            if ($TriedDLs -ge $MaxAttempts) {
                Throw "All download attempts failed for '$RefName' version '$SelectedVersion'. Last error: $($_.Exception.Message)"
            } else {
                # Log the error and continue to the next attempt
                $ComsChannel.Status = "Retrying"
            }
        } Finally {
            # Clean up the runspace and PowerShell instance if they exist
            if ($DLPowerShell) {
                if ($DLHandle) {
                    $DLPowerShell.EndInvoke($DLHandle)
                }
                $DLPowerShell.Runspace.Dispose()
                $DLPowerShell.Dispose()
            }
            if ($DLRunspace) {
                $DLRunspace.Close()
                $DLRunspace.Dispose()
            }
        }
    }
} Catch {
    $ComsChannel.Status = "Error"
    $ComsChannel.ConfigReturn = "Failed"
    $ComsChannel.EndMessage = "Error: $($_.Exception.Message)"
}
# Return ComsChannel hashtable
Return $ComsChannel