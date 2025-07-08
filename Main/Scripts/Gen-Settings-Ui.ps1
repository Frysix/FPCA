# This script generates the UI for the general app Settings based on the provided hash table.
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Import the necessary assemblies for Windows Forms and Drawing.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Import the necessary modules for UI generation.
Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\ParsingHelper.psm1" -Force

# Check if the Settings file exists
if (-not (Test-Path -Path "$($Global:UiHash['PSScriptroot'])\Settings.ini")) {
    # Generate default settings file
    . "$($Global:UiHash['PSScriptroot'])\Scripts\Gen-DefaultSettings.ps1"
}

# Read the settings file
$SettingsData = Get-FromUTF8File -FilePath "$($Global:UiHash['PSScriptroot'])\Settings.ini"

# Read the settings definition file
$SettingsDefinition = Get-Content -Path "$($Global:UiHash['PSScriptroot'])\Assets\refs\SettingsDefinition.json" -Raw | ConvertFrom-Json


$UiHash.SettingsControls = @{}
$UiHash.SettingsTabPages = @{}

# Process each section from the settings definition
foreach ($sectionName in $SettingsDefinition.PSObject.Properties.Name) {
    $section = $SettingsDefinition.$sectionName
    
    # Create a new tab for this section
    $tabPage = New-Object System.Windows.Forms.TabPage
    $tabPage.Text = $sectionName
    $tabPage.Name = "${sectionName}_TAB"
    $tabPage.UseVisualStyleBackColor = $true
    
    # Create a panel for the tab content
    $panel = New-Object System.Windows.Forms.Panel
    $panel.AutoScroll = $true
    $panel.Dock = [System.Windows.Forms.DockStyle]::Fill
    
    $yPosition = 10
    
    # Process each setting in this section
    foreach ($settingName in $section.PSObject.Properties.Name) {
        $setting = $section.$settingName
        $currentValue = $SettingsData[$sectionName][$settingName]
        
        # Create title label above the control
        $titleLabel = New-Object System.Windows.Forms.Label
        $titleLabel.Text = $settingName
        $titleLabel.Location = New-Object System.Drawing.Point(10, $yPosition)
        $titleLabel.Size = New-Object System.Drawing.Size(330, 20)
        $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $panel.Controls.Add($titleLabel)
        
        # Move Y position down for the control
        $yPosition += 25
        
        # Create the appropriate control based on type
        $control = $null
        switch ($setting.Type) {
            "CheckBox" {
                $control = New-Object System.Windows.Forms.CheckBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Size = New-Object System.Drawing.Size(330, 20)
                $control.Checked = ($currentValue -eq "true")
                $control.Text = "Enable $settingName"
            }
            "ComboBox" {
                $control = New-Object System.Windows.Forms.ComboBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Size = New-Object System.Drawing.Size(220, 25)
                $control.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
                
                # Add options
                foreach ($option in $setting.Options) {
                    $control.Items.Add($option)
                }
                
                # Set current value
                if ($currentValue -and $control.Items.Contains($currentValue)) {
                    $control.SelectedItem = $currentValue
                } else {
                    $control.SelectedItem = $setting.Default
                }
            }
            "TextBox" {
                $control = New-Object System.Windows.Forms.TextBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Size = New-Object System.Drawing.Size(220, 25)
                $control.Text = if ($currentValue) { $currentValue } else { $setting.Default }
            }
        }
        
        if ($control) {
            $control.Name = "${sectionName}_${settingName}"
            $control.Tag = @{
                Section = $sectionName
                Setting = $settingName
                Type = $setting.Type
            }
            
            # Add event handler for changes
            switch ($setting.Type) {
                "CheckBox" {
                    $control.Add_CheckedChanged({
                        $Global:UiHash.SettingsChanged = $true
                    })
                }
                "ComboBox" {
                    $control.Add_SelectedIndexChanged({
                        $Global:UiHash.SettingsChanged = $true
                    })
                }
                "TextBox" {
                    $control.Add_TextChanged({
                        $Global:UiHash.SettingsChanged = $true
                    })
                }
            }
            
            $panel.Controls.Add($control)
            
            # Store control for later access
            if (-not $UiHash.SettingsControls.ContainsKey($sectionName)) {
                $UiHash.SettingsControls[$sectionName] = @{}
            }
            $UiHash.SettingsControls[$sectionName][$settingName] = $control
        }
        
        # Move Y position down for the description
        $yPosition += 30
        
        # Add description label below the control
        $descLabel = New-Object System.Windows.Forms.Label
        $descLabel.Text = $setting.Description
        $descLabel.Location = New-Object System.Drawing.Point(20, $yPosition)
        $descLabel.Size = New-Object System.Drawing.Size(330, 20)
        $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
        $descLabel.ForeColor = [System.Drawing.Color]::Gray
        $panel.Controls.Add($descLabel)
        
        # Move Y position down for spacing before next setting
        $yPosition += 35
    }
    
    $tabPage.Controls.Add($panel)
    
    # Store the tab page in hashtable
    $UiHash.SettingsTabPages[$sectionName] = $tabPage
}

# Initialize change tracking
$UiHash.SettingsChanged = $false