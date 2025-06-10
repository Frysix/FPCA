# WebInstaller.ps1
# This script downloads a file in chunks using PowerShell and .NET HttpClient.
# It creates a specified number of chunks, then it downloads each chunk in parallel,
# and finally it combines the chunks into a single file.
# Define the parameters for the script
# Usage: .\WebInstaller.ps1 -Url "http://example.com/file.zip" -OutputFile "C:\path\to\output\file" -ChunkNumber 4 -ConnectionLimit 10
param(
    $ProgressTable,
    [string]$Url,
    [string]$OutputFile,
    [int]$ChunkNumber,
    [int]$ConnectionLimit
)

# This script downloads a file in chunks using PowerShell and .NET HttpClient.
# It creates a specified number of chunks, then it downloads each chunk in parallel,
# and finally it combines the chunks into a single file.

# Import the required .NET assemblies

Add-Type -AssemblyName System.Net.Http
Add-Type -AssemblyName System.IO
Add-Type -AssemblyName System.Threading
Add-Type -AssemblyName System.Collections


# Increase the default connection limit to allow more concurrent connections
[System.Net.ServicePointManager]::DefaultConnectionLimit = $ConnectionLimit

#Import the required modules
if (test-path -path "$PSScriptroot\InternetHelper.psm1") {
    # Check if the InternetHelper module exists in the script directory
    Write-Host "Importing InternetHelper module from script directory..."
    Import-Module "$PSScriptroot\InternetHelper.psm1" -Force
} elseif (test-path -path "$PSScriptroot\Helper\InternetHelper.psm1") {
    # Check if the Helper folder exists in the script Helper Subdirectory
    Write-Host "Importing InternetHelper module from Helper folder..."
    Import-Module "$PSScriptroot\Helper\InternetHelper.psm1" -Force
} elseif (test-path -path "$env:TEMP\InternetHelper.psm1") {
    # Check if the InternetHelper module exists in the TEMP folder
    Write-Host "Importing InternetHelper module from TEMP folder..."
    Import-Module "$env:TEMP\InternetHelper.psm1" -Force
} else {
    Write-Host "InternetHelper module not found. Downloading to TEMP folder..."
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Frysix/FPCA/refs/heads/main/Main/Helper/InternetHelper.psm1" -OutFile "$env:TEMP\InternetHelper.psm1"
    Start-Sleep -Milliseconds 250
    Import-Module "$env:TEMP\InternetHelper.psm1" -Force
}


# Calculate the file length and chunk size
$FileLength = Get-HttpFileLength -Url $Url
$ChunkSize = [math]::Ceiling($FileLength / $ChunkNumber)
$ChunkRegistry = @{}
$Start = 0
$End = $ChunkSize - 1

# Create the chunk registry
for ($Chunk = 1; $Chunk -le $ChunkNumber; $Chunk++) {
    $ChunkRegistry = $ChunkRegistry + @{
        "Start$Chunk" = $Start
        "End$Chunk" = $End
    }
    $Start = $End + 1
    $End = $Start + $ChunkSize - 1
}

# Adjust the last chunk to match the file length
if ($ChunkRegistry["End$ChunkNumber"] -eq $FileLength) {
    Write-Host "Last chunk is the same as the file length"
} else {
    Write-Host "Last chunk is not the same as the file length. Egalizing the last chunk..."
    $ChunkRegistry["End$ChunkNumber"] = $FileLength - 1
}

#Create RunspacePool and progress table
$ProgressTable.FinishedCount = 0
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
            [string]$OutputFile,
            [int]$Chunk,
            $ChunkRegistry,
            $ProgressTable
        )
        $OutputPartFile = "${OutputFile}${Chunk}.zip"
        $Start = $ChunkRegistry["Start$Chunk"]
        $End = $ChunkRegistry["End$Chunk"]
        $totalBytes = $End - $Start + 1

        Add-Type -AssemblyName System.Net.Http
        $client = [System.Net.Http.HttpClient]::new()
        $request = New-Object System.Net.Http.HttpRequestMessage
        $request.Method = [System.Net.Http.HttpMethod]::Get
        $request.RequestUri = [Uri]$Url
        $request.Headers.Range = New-Object System.Net.Http.Headers.RangeHeaderValue($Start, $End)
        $response = $client.SendAsync($request, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
        $Stream = $response.Content.ReadAsStreamAsync().Result

        $BufferSize = 1048576 # 1MB
        $buffer = New-Object byte[] $BufferSize
        $fileStream = [System.IO.File]::OpenWrite($OutputPartFile)
        $bytesReadTotal = 0

        while (($read = $stream.Read($buffer, 0, $bufferSize)) -gt 0) {
            $fileStream.Write($buffer, 0, $read)
            $bytesReadTotal += $read
            $ProgressTable["ReadTotal$Chunk"] = $bytesReadTotal
            $ProgressTable[$Chunk] = "$bytesReadTotal / $totalBytes"
        }

        $fileStream.Close()
        $stream.Close()
        $client.Dispose()
        $ProgressTable.FinishedCount = $ProgressTable.FinishedCount + 1
    }).AddArgument($Url).AddArgument($OutputFile).AddArgument($Chunk).AddArgument($ChunkRegistry).AddArgument($ProgressTable)
    $Jobs += $PowerShell.BeginInvoke()
}

# Wait for all jobs to complete
While ($ProgressTable.FinishedCount -lt $ChunkNumber) {
    Clear-Host
    $totalDownloaded = 0
    for ($Chunk = 1; $Chunk -le $ChunkNumber; $Chunk++) {
        if ($ProgressTable.ContainsKey($Chunk)) {
            $progress = $ProgressTable.$Chunk
            Write-Host "Chunk ${Chunk}: $progress bytes"
            # Extract bytes read from progress string
            if ($progress -match "^(\d+)") {
                $totalDownloaded = $totalDownloaded + $ProgressTable["ReadTotal$Chunk"]
            }
        } else {
            Write-Host "Chunk ${Chunk}: Downloading..."
        }
    }
    $elapsed = (Get-Date) - $StartTime
    if ($elapsed.TotalSeconds -gt 0) {
        $speed = [math]::Round($totalDownloaded / $elapsed.TotalSeconds / 1024, 2) # KB/s
        $remainingBytes = $FileLength - $totalDownloaded
        if ($speed -gt 0) {
            $eta = [TimeSpan]::FromSeconds($remainingBytes / ($speed * 1024))
            Write-Host ("Total: {0} / {1} bytes, Speed: {2} KB/s, ETA: {3:hh\:mm\:ss}" -f $totalDownloaded, $FileLength, $speed, $eta)
        } else {
            Write-Host ("Total: {0} / {1} bytes, Speed: 0 KB/s, ETA: --:--:--" -f $totalDownloaded, $FileLength)
        }
    }
    Start-Sleep -Seconds 1
}

# Close the runspace pool and jobs
$RunspacePool.Close()
$RunspacePool.Dispose()

# Combine the downloaded chunks into a single file
$FinalFile = "${OutputFile}.zip"
$OutputStream = [System.IO.File]::Create($FinalFile)
for ($Chunk = 1; $Chunk -le $ChunkNumber; $Chunk++) {
    $PartFile = "${OutputFile}${Chunk}.zip"
    if (Test-Path $PartFile) {
        $bytes = [System.IO.File]::ReadAllBytes($PartFile)
        $OutputStream.Write($bytes, 0, $bytes.Length)
        Remove-Item $PartFile
    } else {
        Write-Host "Warning: $PartFile not found."
    }
}
$OutputStream.Close()
Write-Host "Download complete: $FinalFile"