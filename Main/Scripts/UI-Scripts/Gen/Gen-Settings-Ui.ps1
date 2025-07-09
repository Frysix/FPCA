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
    . "$($Global:UiHash['PSScriptroot'])\Scripts\Settings-Scripts\Gen\Gen-DefaultSettings.ps1"
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
        $titleLabel.Size = New-Object System.Drawing.Size(320, 20)
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
                $control.Size = New-Object System.Drawing.Size(320, 20)
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
                
                # Check if this is an integer-only field
                if ($setting.PSObject.Properties.Name -contains "IntegerOnly" -and $setting.IntegerOnly -eq $true) {
                    # Add integer-only validation
                    $control.Add_KeyPress({
                        param($sender, $e)
                        # Allow backspace, delete, and control characters
                        if ($e.KeyChar -eq 8 -or $e.KeyChar -eq 127 -or [char]::IsControl($e.KeyChar)) {
                            return
                        }
                        # Allow minus sign only at the beginning for negative numbers
                        if ($e.KeyChar -eq 45 -and $sender.SelectionStart -eq 0 -and $sender.Text.IndexOf('-') -eq -1) {
                            return
                        }
                        # Allow digits only
                        if (-not [char]::IsDigit($e.KeyChar)) {
                            $e.Handled = $true
                        }
                    })
                    
                    # Validate on text change to handle paste operations
                    $control.Add_TextChanged({
                        param($sender, $e)
                        $textBox = $sender
                        $text = $textBox.Text
                        
                        # Allow empty text
                        if ([string]::IsNullOrEmpty($text)) {
                            $Global:UiHash.SettingsChanged = $true
                            return
                        }
                        
                        # Check if it's a valid integer
                        $intValue = 0
                        if (-not [int]::TryParse($text, [ref]$intValue)) {
                            # Remove any non-digit characters (except minus at start)
                            $cleanText = $text -replace '[^\d\-]', ''
                            # Ensure minus is only at the beginning
                            if ($cleanText.IndexOf('-') -gt 0) {
                                $cleanText = $cleanText.Replace('-', '')
                            }
                            # Remove extra minus signs
                            $minusCount = ($cleanText.ToCharArray() | Where-Object { $_ -eq '-' }).Count
                            if ($minusCount -gt 1) {
                                $cleanText = '-' + $cleanText.Replace('-', '')
                            }
                            
                            # If the text was changed, update it
                            if ($cleanText -ne $text) {
                                $cursorPos = $textBox.SelectionStart
                                $textBox.Text = $cleanText
                                $textBox.SelectionStart = [Math]::Min($cursorPos, $cleanText.Length)
                            }
                        }
                        
                        $Global:UiHash.SettingsChanged = $true
                    })
                } else {
                    # Regular text box change event
                    $control.Add_TextChanged({
                        $Global:UiHash.SettingsChanged = $true
                    })
                }
            }
            "IntegerTextBox" {
                $control = New-Object System.Windows.Forms.TextBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Size = New-Object System.Drawing.Size(220, 25)
                $control.Text = if ($currentValue) { $currentValue } else { $setting.Default }
                
                # Add integer-only validation
                $control.Add_KeyPress({
                    param($sender, $e)
                    # Allow backspace, delete, and control characters
                    if ($e.KeyChar -eq 8 -or $e.KeyChar -eq 127 -or [char]::IsControl($e.KeyChar)) {
                        return
                    }
                    # Allow minus sign only at the beginning for negative numbers
                    if ($e.KeyChar -eq 45 -and $sender.SelectionStart -eq 0 -and $sender.Text.IndexOf('-') -eq -1) {
                        return
                    }
                    # Allow digits only
                    if (-not [char]::IsDigit($e.KeyChar)) {
                        $e.Handled = $true
                    }
                })
                
                # Validate on text change to handle paste operations
                $control.Add_TextChanged({
                    param($sender, $e)
                    $textBox = $sender
                    $text = $textBox.Text
                    
                    # Allow empty text
                    if ([string]::IsNullOrEmpty($text)) {
                        $Global:UiHash.SettingsChanged = $true
                        return
                    }
                    
                    # Check if it's a valid integer
                    $intValue = 0
                    if (-not [int]::TryParse($text, [ref]$intValue)) {
                        # Remove any non-digit characters (except minus at start)
                        $cleanText = $text -replace '[^\d\-]', ''
                        # Ensure minus is only at the beginning
                        if ($cleanText.IndexOf('-') -gt 0) {
                            $cleanText = $cleanText.Replace('-', '')
                        }
                        # Remove extra minus signs
                        $minusCount = ($cleanText.ToCharArray() | Where-Object { $_ -eq '-' }).Count
                        if ($minusCount -gt 1) {
                            $cleanText = '-' + $cleanText.Replace('-', '')
                        }
                        
                        # If the text was changed, update it
                        if ($cleanText -ne $text) {
                            $cursorPos = $textBox.SelectionStart
                            $textBox.Text = $cleanText
                            $textBox.SelectionStart = [Math]::Min($cursorPos, $cleanText.Length)
                        }
                    }
                    
                    $Global:UiHash.SettingsChanged = $true
                })
            }
        }
        
        if ($control) {
            $control.Name = "${sectionName}_${settingName}"
            $control.Tag = @{
                Section = $sectionName
                Setting = $settingName
                Type = $setting.Type
            }
            
            # Add event handlers for non-TextBox controls (TextBox handlers are added above)
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
        $descLabel.Size = New-Object System.Drawing.Size(320, 20)
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