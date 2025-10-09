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
        if (-not (Test-Path -Path "$ScriptRoot\Assets\Apps")) {
            New-Item -Path "$ScriptRoot\Assets\Apps" -ItemType Directory | Out-Null
        }
        if (Test-Path -Path "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1") {
            . "$ScriptRoot\Scripts\Install-Scripts\File-Installer.ps1" -ScriptRoot $ScriptRoot -RefName "CAFFEINE" -OutputPath "$ScriptRoot\Assets\Apps\"
        } else {
            Write-Host "File-Installer.ps1 not found, cannot install Caffeine." -ForegroundColor Red
            return $CaffeineWasStarted
        }
        if ($Coms.Status -eq 'Completed') {
            Write-Host "Caffeine installed successfully." -ForegroundColor Green
        } else {
            Write-Host "Failed to install Caffeine." -ForegroundColor Red
            return $CaffeineWasStarted
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