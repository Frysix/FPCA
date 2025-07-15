Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Create new settings hashtable
$newSettings = @{}

# Process all settings controls
foreach ($sectionName in $UiHash.SettingsControls.Keys) {
    $newSettings[$sectionName] = @{}
    
    foreach ($settingName in $UiHash.SettingsControls[$sectionName].Keys) {
        $control = $UiHash.SettingsControls[$sectionName][$settingName]
        
        # Get value based on control type
        switch ($control.Tag.Type) {
            "CheckBox" {
                $newSettings[$sectionName][$settingName] = $control.Checked.ToString().ToLower()
            }
            "ComboBox" {
                $newSettings[$sectionName][$settingName] = $control.SelectedItem.ToString()
            }
            "TextBox" {
                $newSettings[$sectionName][$settingName] = $control.Text
            }
            "IntegerTextBox" {
                # Ensure the value is an integer
                if ([int]::TryParse($control.Text, [ref]$null)) {
                    $newSettings[$sectionName][$settingName] = $control.Text
                } else {
                    Write-Host "Invalid integer value for $($sectionName[$settingName]): $($control.Text)"
                    $newSettings[$sectionName][$settingName] = "0"  
                }
            }
        }
    }
}

# Save to file
$settingsContent = [System.Collections.Generic.List[string]]::new()
foreach ($sectionName in $newSettings.Keys) {
    $settingsContent.Add("[$sectionName]")
    foreach ($settingName in $newSettings[$sectionName].Keys) {
        $settingsContent.Add("$settingName=$($newSettings[$sectionName][$settingName])")
    }
    $settingsContent.Add("")
}

Set-Content -Path "$($Global:UiHash['PSScriptroot'])\Settings.ini" -Value $settingsContent -Encoding UTF8
Write-Host "Settings saved successfully!"
$UiHash.SettingsChanged = $false