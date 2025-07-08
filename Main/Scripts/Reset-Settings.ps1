Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash,
    [Switch]$ConfirmReset
)

# Import the necessary modules for UI generation.
Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\ParsingHelper.psm1" -Force
Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\FormHelper.psm1" -Force

# Show confirmation dialog if requested
if ($ConfirmReset) {
    $result = Show-TopMostMessageBox -Message "Are you sure you want to reset all settings to their default values? This action cannot be undone." -Title "FPCA - Reset Settings" -Buttons "YesNo" -Icon "Warning"
    if ($result -eq [System.Windows.Forms.DialogResult]::No) {
        Write-Host "Settings reset cancelled."
        return
    }
}

# Read the settings definition file to get default values
$SettingsDefinition = Get-Content -Path "$($Global:UiHash['PSScriptroot'])\Assets\refs\SettingsDefinition.json" -Raw | ConvertFrom-Json

# Create default settings hashtable
$defaultSettings = @{}

# Process each section from the settings definition
foreach ($sectionName in $SettingsDefinition.PSObject.Properties.Name) {
    $section = $SettingsDefinition.$sectionName
    $defaultSettings[$sectionName] = @{}
    
    # Process each setting in this section
    foreach ($settingName in $section.PSObject.Properties.Name) {
        $setting = $section.$settingName
        $defaultSettings[$sectionName][$settingName] = $setting.Default
    }
}

# Generate the settings file content
$settingsContent = [System.Collections.Generic.List[string]]::new()
$sectionCount = $defaultSettings.Keys.Count
$sectionIndex = 0

foreach ($sectionName in $defaultSettings.Keys) {
    $settingsContent.Add("[$sectionName]")
    foreach ($settingName in $defaultSettings[$sectionName].Keys) {
        $settingsContent.Add("$settingName=$($defaultSettings[$sectionName][$settingName])")
    }
    $sectionIndex++
    # Only add a blank line if not the last section
    if ($sectionIndex -lt $sectionCount) {
        $settingsContent.Add("")
    }
}

# Backup existing settings file
if (Test-Path -Path "$($Global:UiHash['PSScriptroot'])\Settings.ini") {
    $backupPath = "$($Global:UiHash['PSScriptroot'])\Settings.ini.backup"
    Copy-Item -Path "$($Global:UiHash['PSScriptroot'])\Settings.ini" -Destination $backupPath -Force
    Write-Host "Backup created: $backupPath"
}

# Write the default settings to the file
Set-Content -Path "$($Global:UiHash['PSScriptroot'])\Settings.ini" -Value $settingsContent -Encoding UTF8

# Update the UI controls to reflect the default values if they exist
if ($UiHash.ContainsKey('SettingsControls')) {
    foreach ($sectionName in $UiHash.SettingsControls.Keys) {
        foreach ($settingName in $UiHash.SettingsControls[$sectionName].Keys) {
            $control = $UiHash.SettingsControls[$sectionName][$settingName]
            $defaultValue = $defaultSettings[$sectionName][$settingName]
            
            # Update control based on its type
            switch ($control.Tag.Type) {
                "CheckBox" {
                    $control.Checked = ($defaultValue -eq "true")
                }
                "ComboBox" {
                    if ($control.Items.Contains($defaultValue)) {
                        $control.SelectedItem = $defaultValue
                    }
                }
                "TextBox" {
                    $control.Text = $defaultValue
                }
            }
        }
    }
}

# Mark settings as changed so they can be saved
$UiHash.SettingsChanged = $true

Write-Host "Settings have been reset to default values successfully."