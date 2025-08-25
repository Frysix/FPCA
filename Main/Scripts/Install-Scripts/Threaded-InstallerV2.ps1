# Multi-threaded file downloader with progress tracking and redirect support
# Downloads a file in chunks using parallel runspaces
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$Coms,
    [Parameter(Mandatory=$false)]
    [string]$TaskName,
    [Parameter(Mandatory=$true)]
    [string]$Url,
    [Parameter(Mandatory=$true)]
    [string]$OutputFile,
    [Parameter(Mandatory=$false)]
    [int]$ChunkNumber = 4,
    [Parameter(Mandatory=$false)]
    [int]$ConnectionLimit = 10
)

$Coms.Status = "Running"
$Coms.Progress = 0

try {
    Write-Host "Starting multi-threaded download for: $Url"
    $Coms.Comment = "Initializing download..."
    
    # Check if we're already running in a runspace pool (nested scenario)
    $IsInRunspacePool = $false
    try {
        $CurrentRunspace = [System.Management.Automation.Runspaces.Runspace]::DefaultRunspace
        if ($CurrentRunspace -and $CurrentRunspace.GetType().Name -eq "RemoteRunspace") {
            $IsInRunspacePool = $true
            Write-Host "Detected we're running inside a runspace pool - using simple download method"
        }
    } catch {
        # Ignore errors in runspace detection
    }
    
    # If we're in a runspace pool, use simple download to avoid nested runspace issues
    if ($IsInRunspacePool) {
        Write-Host "Using simple download method to avoid runspace nesting issues"
        $Coms.Comment = "Downloading file (simple method)..."
        
        # Simple WebClient download
        $WebClient = New-Object System.Net.WebClient
        $WebClient.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
        
        # Get file size first
        try {
            $Coms.Progress = 10
            $Request = [System.Net.WebRequest]::Create($Url)
            $Request.Method = "HEAD"
            $Response = $Request.GetResponse()
            $FileLength = $Response.ContentLength
            $Response.Close()
            Write-Host "File size: $([math]::Round($FileLength/1MB, 2)) MB"
        } catch {
            Write-Host "Could not determine file size, proceeding with download"
            $FileLength = 0
        }
        
        # Download with progress tracking
        $Coms.Progress = 20
        $Coms.Comment = "Downloading file..."
        
        # Use DownloadFileAsync for better progress tracking
        $DownloadComplete = $false
        $WebClient.add_DownloadProgressChanged({
            param($sender, $e)
            if ($FileLength -gt 0) {
                $Coms.Progress = [math]::Min(90, 20 + ($e.ProgressPercentage * 0.7))
                $Coms.Comment = "Downloading... $($e.ProgressPercentage)%"
            }
        })
        
        $WebClient.add_DownloadFileCompleted({
            param($sender, $e)
            $DownloadComplete = $true
            if ($e.Error) {
                throw $e.Error
            }
        })
        
        # Ensure output directory exists
        $OutputDir = Split-Path $OutputFile -Parent
        if (-not (Test-Path $OutputDir)) {
            New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
        }
        
        # Start async download
        $WebClient.DownloadFileAsync($Url, $OutputFile)
        
        # Wait for completion with timeout
        $Timeout = 300 # 5 minutes
        $Elapsed = 0
        while (-not $DownloadComplete -and $Elapsed -lt $Timeout) {
            Start-Sleep -Milliseconds 500
            $Elapsed += 0.5
        }
        
        $WebClient.Dispose()
        
        if (-not $DownloadComplete) {
            throw "Download timed out after $Timeout seconds"
        }
        
        # Verify file was created
        if (Test-Path $OutputFile) {
            $FinalSize = (Get-Item $OutputFile).Length
            Write-Host "Download completed. File size: $([math]::Round($FinalSize/1MB, 2)) MB"
            $Coms.Status = "Completed"
            $Coms.Progress = 100
            $Coms.Comment = "Download completed successfully (simple method)"
        } else {
            throw "Downloaded file not found at: $OutputFile"
        }
        
        return # Exit early, skip the threaded download
    }
    
    # Import required assemblies
    Add-Type -AssemblyName System.Net.Http, System.IO, System.Threading, System.Collections
    
    # Increase connection limit
    [System.Net.ServicePointManager]::DefaultConnectionLimit = $ConnectionLimit
    
    # Validate parameters
    if (-not $Url -or $Url -notmatch '^(http|https)://') {
        throw "Invalid URL format: $Url"
    }
    if ($ChunkNumber -le 0) {
        throw "Invalid chunk number: $ChunkNumber. Must be positive."
    }
    if (-not $OutputFile) {
        throw "Output file path is required"
    }
    
    $Coms.Progress = 5
    $Coms.Comment = "Resolving redirects and checking file size..."
    
    # Function to resolve redirects and get final URL
    function Resolve-RedirectUrl {
        param([string]$Url, [int]$MaxRedirects = 10)
        
        $currentUrl = $Url
        $redirectCount = 0
        
        while ($redirectCount -lt $MaxRedirects) {
            try {
                # Create HttpClient with redirect handling disabled
                $handler = New-Object System.Net.Http.HttpClientHandler
                $handler.AllowAutoRedirect = $false
                $client = New-Object System.Net.Http.HttpClient($handler)
                
                # Send HEAD request to check for redirects
                $response = $client.SendAsync((New-Object System.Net.Http.HttpRequestMessage([System.Net.Http.HttpMethod]::Head, $currentUrl))).Result
                
                if ($response.StatusCode -in @([System.Net.HttpStatusCode]::MovedPermanently, [System.Net.HttpStatusCode]::Found, [System.Net.HttpStatusCode]::SeeOther, [System.Net.HttpStatusCode]::TemporaryRedirect, [System.Net.HttpStatusCode]::PermanentRedirect, 308)) {
                    $location = $response.Headers.Location
                    if ($location) {
                        if ($location.IsAbsoluteUri) {
                            $currentUrl = $location.ToString()
                        } else {
                            # Handle relative redirects
                            $baseUri = New-Object System.Uri($currentUrl)
                            $currentUrl = (New-Object System.Uri($baseUri, $location)).ToString()
                        }
                        Write-Host "Redirect $($redirectCount + 1): $currentUrl"
                        $redirectCount++
                    } else {
                        break
                    }
                } else {
                    # No more redirects
                    break
                }
                
                $client.Dispose()
                
            } catch {
                Write-Host "Error resolving redirect: $($_.Exception.Message)"
                break
            }
        }
        
        if ($redirectCount -ge $MaxRedirects) {
            throw "Too many redirects (>$MaxRedirects)"
        }
        
        return $currentUrl
    }
    
    # Resolve the final URL after all redirects
    $FinalUrl = Resolve-RedirectUrl -Url $Url
    Write-Host "Final URL after redirects: $FinalUrl"
    
    # Import InternetHelper module
    $InternetHelperPaths = @(
        "$PSScriptRoot\InternetHelper.psm1",
        "$PSScriptRoot\Helper\InternetHelper.psm1",
        "$env:TEMP\InternetHelper.psm1"
    )
    
    $ModuleFound = $false
    foreach ($Path in $InternetHelperPaths) {
        if (Test-Path $Path) {
            Import-Module $Path -Force
            $ModuleFound = $true
            break
        }
    }
    
    if (-not $ModuleFound) {
        Write-Host "InternetHelper module not found. Downloading..."
        $ModuleUrl = "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/Helper/InternetHelper.psm1"
        Invoke-WebRequest -Uri $ModuleUrl -OutFile "$env:TEMP\InternetHelper.psm1"
        Start-Sleep -Milliseconds 250
        Import-Module "$env:TEMP\InternetHelper.psm1" -Force
    }
    
    # Get file length using the final URL
    $FileLength = Get-HttpFileLength -Url $FinalUrl
    if (-not $FileLength -or $FileLength -le 0) {
        throw "Could not determine file size or file is empty"
    }
    
    Write-Host "File size: $FileLength bytes"
    $Coms.Progress = 10
    $Coms.Comment = "Setting up download chunks..."
    
    # Determine file extension from URL or use provided extension
    $FileExtension = ""
    if ($OutputFile.Contains('.')) {
        # Extract extension from output file
        $FileExtension = $OutputFile.Substring($OutputFile.LastIndexOf('.'))
        $OutputFileBase = $OutputFile.Substring(0, $OutputFile.LastIndexOf('.'))
    } else {
        # Try to determine extension from final URL
        $UrlPath = [System.Uri]::new($FinalUrl).LocalPath
        if ($UrlPath.Contains('.')) {
            $FileExtension = $UrlPath.Substring($UrlPath.LastIndexOf('.'))
        } else {
            # Default to .tmp if no extension can be determined
            $FileExtension = ".tmp"
        }
        $OutputFileBase = $OutputFile
    }
    
    Write-Host "Using file extension: $FileExtension"
    
    # Calculate chunk size and create registry
    $ChunkSize = [math]::Ceiling($FileLength / $ChunkNumber)
    $ChunkRegistry = @{}
    $Start = 0
    $End = $ChunkSize - 1
    
    # Create chunk registry
    for ($Chunk = 1; $Chunk -le $ChunkNumber; $Chunk++) {
        $ChunkRegistry["Start$Chunk"] = $Start
        $ChunkRegistry["End$Chunk"] = $End
        $Start = $End + 1
        $End = $Start + $ChunkSize - 1
    }
    
    # Adjust last chunk to match file length
    $ChunkRegistry["End$ChunkNumber"] = $FileLength - 1
    
    $Coms.Progress = 15
    $Coms.Comment = "Starting parallel download..."
    
    # Initialize progress tracking
    $ProgressTable = [hashtable]::Synchronized(@{
        FinishedCount = 0
        TotalDownloaded = 0
    })
    
    # Create runspace pool
    $RunspacePool = [runspacefactory]::CreateRunspacePool(1, $ChunkNumber)
    $RunspacePool.Open()
    $Jobs = @()
    $StartTime = Get-Date
    
    # Start downloading chunks in parallel
    for ($Chunk = 1; $Chunk -le $ChunkNumber; $Chunk++) {
        $PowerShell = [powershell]::Create()
        $PowerShell.RunspacePool = $RunspacePool
        $PowerShell.AddScript({
            Param(
                [string]$Url,
                [string]$OutputFileBase,
                [string]$FileExtension,
                [int]$Chunk,
                $ChunkRegistry,
                $ProgressTable
            )
            
            try {
                # Create part file with proper extension
                $OutputPartFile = "${OutputFileBase}${Chunk}.part"
                $Start = $ChunkRegistry["Start$Chunk"]
                $End = $ChunkRegistry["End$Chunk"]
                $totalBytes = $End - $Start + 1
                
                Add-Type -AssemblyName System.Net.Http
                
                # Create HttpClient with redirect handling enabled
                $handler = New-Object System.Net.Http.HttpClientHandler
                $handler.AllowAutoRedirect = $true
                $client = New-Object System.Net.Http.HttpClient($handler)
                
                # Set timeout to 30 minutes for large chunks
                $client.Timeout = [TimeSpan]::FromMinutes(30)
                
                $request = New-Object System.Net.Http.HttpRequestMessage
                $request.Method = [System.Net.Http.HttpMethod]::Get
                $request.RequestUri = [Uri]$Url
                $request.Headers.Range = New-Object System.Net.Http.Headers.RangeHeaderValue($Start, $End)
                
                $response = $client.SendAsync($request, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
                
                # Check if the response is successful
                if (-not $response.IsSuccessStatusCode) {
                    throw "HTTP error: $($response.StatusCode) - $($response.ReasonPhrase)"
                }
                
                $Stream = $response.Content.ReadAsStreamAsync().Result
                
                $BufferSize = 1048576 # 1MB
                $buffer = New-Object byte[] $BufferSize
                $fileStream = [System.IO.File]::OpenWrite($OutputPartFile)
                $bytesReadTotal = 0
                
                while (($read = $stream.Read($buffer, 0, $bufferSize)) -gt 0) {
                    $fileStream.Write($buffer, 0, $read)
                    $bytesReadTotal += $read
                    $ProgressTable["ReadTotal$Chunk"] = $bytesReadTotal
                    $ProgressTable["Progress$Chunk"] = [math]::Round(($bytesReadTotal / $totalBytes) * 100, 1)
                }
                
                $fileStream.Close()
                $stream.Close()
                $response.Dispose()
                $client.Dispose()
                $ProgressTable.FinishedCount++
                
            } catch {
                Write-Host "Error in chunk $Chunk`: $($_.Exception.Message)"
                $ProgressTable["Error$Chunk"] = $_.Exception.Message
            }
        }).AddArgument($FinalUrl).AddArgument($OutputFileBase).AddArgument($FileExtension).AddArgument($Chunk).AddArgument($ChunkRegistry).AddArgument($ProgressTable)
        
        $Jobs += $PowerShell.BeginInvoke()
    }
    
    # Monitor progress
    while ($ProgressTable.FinishedCount -lt $ChunkNumber) {
        Start-Sleep -Milliseconds 500
        
        # Calculate total progress
        $totalDownloaded = 0
        for ($Chunk = 1; $Chunk -le $ChunkNumber; $Chunk++) {
            if ($ProgressTable.ContainsKey("ReadTotal$Chunk")) {
                $totalDownloaded += $ProgressTable["ReadTotal$Chunk"]
            }
        }
        
        # Convert to percentage (0-100)
        $progressPercentage = if ($FileLength -gt 0) {
            [math]::Round(($totalDownloaded / $FileLength) * 100, 1)
        } else { 0 }
        
        # Update progress (15% base + 75% for download progress)
        $Coms.Progress = [math]::Min(15 + ($progressPercentage * 0.75), 90)
        
        # Calculate download speed
        $elapsed = (Get-Date) - $StartTime
        if ($elapsed.TotalSeconds -gt 0) {
            $speed = [math]::Round($totalDownloaded / $elapsed.TotalSeconds / 1024, 2) # KB/s
            $Coms.Comment = "Downloading... $progressPercentage% ($speed KB/s)"
        } else {
            $Coms.Comment = "Downloading... $progressPercentage%"
        }
        
        Write-Host "Download progress: $progressPercentage% ($totalDownloaded / $FileLength bytes)"
    }
    
    # Close runspace pool
    $RunspacePool.Close()
    $RunspacePool.Dispose()
    
    $Coms.Progress = 90
    $Coms.Comment = "Combining downloaded chunks..."
    
    # Combine chunks into final file with proper extension
    $FinalFile = "${OutputFileBase}${FileExtension}"
    $OutputStream = [System.IO.File]::Create($FinalFile)
    
    for ($Chunk = 1; $Chunk -le $ChunkNumber; $Chunk++) {
        $PartFile = "${OutputFileBase}${Chunk}.part"
        if (Test-Path $PartFile) {
            $bytes = [System.IO.File]::ReadAllBytes($PartFile)
            $OutputStream.Write($bytes, 0, $bytes.Length)
            Remove-Item $PartFile -Force
        } else {
            Write-Host "Warning: $PartFile not found."
        }
    }
    
    $OutputStream.Close()
    
    # Verify final file
    if (Test-Path $FinalFile) {
        $FinalSize = (Get-Item $FinalFile).Length
        if ($FinalSize -eq $FileLength) {
            Write-Host "Download completed successfully: $FinalFile"
            $Coms.Status = "Completed"
            $Coms.Progress = 100
            $Coms.Comment = "Download completed successfully"
        } else {
            throw "File size mismatch. Expected: $FileLength, Got: $FinalSize"
        }
    } else {
        throw "Final file was not created"
    }
    
} catch {
    Write-Host "Download failed: $($_.Exception.Message)" -ForegroundColor Red
    $Coms.Status = "Failed"
    $Coms.Progress = 0
    $Coms.Comment = "Download failed: $($_.Exception.Message)"
}