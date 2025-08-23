# This script is part of the FPCA project and is used to parse and enable mods, it is the main mod loader.
# It parses from a specific file structure for mod definitions and enables them based on user input.
Param (
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

#Test for the modpath in the main folder.
if (-not (Test-Path -Path "$($UiHash.PSScriptRoot)\Mods")) {
    New-Item -ItemType Directory -Path "$($UiHash.PSScriptRoot)\Mods"
    Write-Host "Created Mods directory at $($UiHash.PSScriptRoot)\Mods"
    return
}

# Import modules for parsing definitions
Import-Module -Name "$($UiHash.PSScriptRoot)\Helper\ParsingHelper.psm1" -Force

# Index all folders in the Mods directory
$ModFolders = Get-ChildItem -Path "$($UiHash.PSScriptRoot)\Mods" -Directory
# Create an hashtable to hold mod definitions
$AvailableMods = @{}
$AvailableMods.All = @{}

# Check if the ModDefinition.json file exists in each folder and parse it
foreach ($folder in $ModFolders) {
    if (Test-Path -Path "$($folder.FullName)\Mod.json") {
        $def = Convert-JsonToHashtable -FilePath "$($folder.FullName)\Mod.json"
        if ($def.Information.AppVersion -eq $UiHash.FPCAInfo.Version) {
            foreach ($key in $def.Mod_Data.Keys) {
                Write-Host "Indexing mod: $($def.Information.Name) with key: $key"
                if (-not $AvailableMods.ContainsKey($key)) {
                    $AvailableMods[$key] = @{}
                }
                $AvailableMods[$key][$def.Information.Name] = $def.Mod_Data[$key]
            }
            $AvailableMods.All[$def.Information.Name] = $def
            Write-Host "Mod: $($def.Information.Name) in $($folder.FullName). Successfully indexed." -ForegroundColor Green
        } else {
            Write-Host "Mod $($def.Information.Name) is not compatible with FPCA version $($UiHash.FPCAInfo.Version), skipping..." -ForegroundColor Yellow
        }
    } else {
        Write-Host "No Mod.json found in $($folder.FullName), skipping..." -ForegroundColor Yellow
    }
}

# Update the UI hash with available mods
$UiHash.AvailableMods = $AvailableMods