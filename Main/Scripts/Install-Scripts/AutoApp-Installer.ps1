# Installation Script for Nvidia Application
# This script installs the Nvidia application and handles any prerequisites or configurations needed.
Param(
    [Parameter(Mandatory=$true)]
    [Hashtable]$Coms,
    [Parameter(Mandatory=$true)]
    [string]$TaskName,
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot
)

$Coms.Status = "Running"
$Coms.Progress = 0

# Check if the Nvidia application is already installed
$installed = Get-Command "nvidia-smi" -ErrorAction SilentlyContinue

if ($installed) {
    Write-Host "${TaskName} application is already installed."
    $Coms.Status = "Completed"
    $Coms.Progress = 100
    return
}

# Import modules for parsing definitions
Import-Module "${ScriptRoot}\Helper\ParsingHelper.psm1" -Force

# Get the Nvidia application definition
$InstallDefinitions = Convert-JsonToHashtable -FilePath "${ScriptRoot}\Assets\refs\DefaultInstallDefinition.json"

# Check if the task name exists in the installation definitions
if (-not $InstallDefinitions.Installations.ContainsKey($TaskName)) {
    Write-Host "No installation definition found for Installation: $TaskName"
    $Coms.Status = "Failed"
    $Coms.Progress = 100
    return
}

if (-not $InstallDefinitions.Installations[$TaskName].ContainsKey("Links")) {
    Write-Host "No links found for Installation: $TaskName"
    $Coms.Status = "Failed"
    $Coms.Progress = 100
    return
}

$Links = $InstallDefinitions.Installations[$TaskName].Links

# Download and install the Nvidia application
foreach ($link in $Links) {
    try {
        $Coms.Comment = "Downloading from link: $($link.Value)"
        Write-Host "Downloading from: $($link.Value)"
        & "${ScriptRoot}\Threaded-InstallerV2.ps1" -Coms $Coms -TaskName $TaskName -Url $($link.Value) -OutputFile "$env:TEMP\NvidiaAppInstaller.exe"

    } catch {
        Write-Host "Failed to Install from link: $($link.Value)"
        $Coms.Comment = "Failed to install from link: $($link.Value)"
    }
}