Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Read the settings definition and create default settings.ini
$SettingsDefinition = Get-Content -Path "$($Global:UiHash['PSScriptroot'])\Assets\refs\SettingsDefinition.json" -Raw | ConvertFrom-Json

$defaultSettings = [System.Collections.Generic.List[string]]::new()

foreach ($sectionName in $SettingsDefinition.PSObject.Properties.Name) {
    $section = $SettingsDefinition.$sectionName
    $defaultSettings.Add("[$sectionName]")
    
    foreach ($settingName in $section.PSObject.Properties.Name) {
        $setting = $section.$settingName
        $defaultSettings.Add("$settingName=$($setting.Default)")
    }
    $defaultSettings.Add("")
}

Set-Content -Path "$($Global:UiHash['PSScriptroot'])\Settings.ini" -Value $defaultSettings -Encoding UTF8
Write-Host "Default settings file created."