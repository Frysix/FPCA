Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$AppSettings,
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot
)

# Check for caffeine parameter and start caffeine if enabled
$CaffeineWasStarted = $false
if ($AppSettings.ContainsKey('RunCaffeine') -and ($AppSettings.RunCaffeine -eq 'true' -or $AppSettings.RunCaffeine -eq $true)) {
    if (-not (Test-Path -Path "$ScriptRoot\Assets\Apps\Caffeine\caffeine64.exe")) {
        New-Item -ItemType Directory -Path "$ScriptRoot\Assets\Apps\" -Force | Out-Null
        $CaffeineUrl = "https://ftp.frysix.com/public/file/dwvt_denm0if8r8dzh8u6g/caffeine.zip"
        if (Test-Path -Path "$ScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1") {
            $InstallerComs = @{}
            . "$ScriptRoot\Scripts\Install-Scripts\Threaded-InstallerV2.ps1" -Coms $InstallerComs -Url $CaffeineUrl -OutputFile "$ScriptRoot\Assets\Apps\caffeine.zip" -ChunkNumber 2
        } else {
            Invoke-WebRequest -Uri $CaffeineUrl -OutFile "$ScriptRoot\Assets\Apps\caffeine.zip" -UseBasicParsing -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "$ScriptRoot\Assets\Apps\caffeine.zip") {
            Expand-Archive -Path "$ScriptRoot\Assets\Apps\caffeine.zip" -DestinationPath "$ScriptRoot\Assets\Apps" -Force
            Remove-Item -Path "$ScriptRoot\Assets\Apps\caffeine.zip" -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "Failed to download Caffeine application." -ForegroundColor Red
        }
    }
    if (Test-Path -Path "$ScriptRoot\Assets\Apps\Caffeine\caffeine64.exe") {
        $Proc = Start-Process -FilePath "$ScriptRoot\Assets\Apps\Caffeine\caffeine64.exe" -PassThru
        if ($Proc -and $Proc.Id) {
            $CaffeineWasStarted = $true
        }
    }
}

Return $CaffeineWasStarted