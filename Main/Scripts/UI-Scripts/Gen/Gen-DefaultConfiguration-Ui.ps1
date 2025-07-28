# This script generates UI controls for the default configuration and stores them for later use.
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Import the necessary assemblies for Windows Forms and Drawing.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Read the configuration definition file
$ConfigDefinition = Get-Content -Path "$($Global:UiHash['PSScriptroot'])\Assets\refs\DefaultConfigDefinition.json" -Raw | ConvertFrom-Json

# Function to preserve current control states before regenerating
function Save-ControlStates {
    param([hashtable]$UiHash)
    
    if (-not $UiHash.ContainsKey('PreservedControlStates')) {
        $UiHash.PreservedControlStates = @{}
    }
    
    if ($UiHash.ContainsKey('ConfigurationControls')) {
        foreach ($controlName in $UiHash.ConfigurationControls.Keys) {
            $control = $UiHash.ConfigurationControls[$controlName]
            
            if ($control -is [System.Windows.Forms.CheckBox]) {
                $UiHash.PreservedControlStates[$controlName] = $control.Checked
            } elseif ($control -is [System.Windows.Forms.ComboBox]) {
                $UiHash.PreservedControlStates[$controlName] = $control.SelectedItem
            } elseif ($control -is [System.Windows.Forms.TextBox]) {
                $UiHash.PreservedControlStates[$controlName] = $control.Text
            }
        }
    }
}

# Function to restore control states after regenerating
function Restore-ControlStates {
    param([hashtable]$UiHash)
    
    if ($UiHash.ContainsKey('PreservedControlStates') -and $UiHash.ContainsKey('ConfigurationControls')) {
        foreach ($controlName in $UiHash.PreservedControlStates.Keys) {
            if ($UiHash.ConfigurationControls.ContainsKey($controlName)) {
                $control = $UiHash.ConfigurationControls[$controlName]
                $savedValue = $UiHash.PreservedControlStates[$controlName]
                
                try {
                    if ($control -is [System.Windows.Forms.CheckBox]) {
                        $control.Checked = $savedValue
                    } elseif ($control -is [System.Windows.Forms.ComboBox] -and $savedValue -ne $null) {
                        if ($control.Items.Contains($savedValue)) {
                            $control.SelectedItem = $savedValue
                        }
                    } elseif ($control -is [System.Windows.Forms.TextBox] -and $savedValue -ne $null) {
                        $control.Text = $savedValue
                    }
                } catch {
                    # Ignore restoration errors for individual controls
                }
            }
        }
        
        # After restoring states, update visibility for ComboBox/TextBox sub-controls
        foreach ($controlName in $UiHash.ConfigurationControls.Keys) {
            $control = $UiHash.ConfigurationControls[$controlName]
            
            # Check if this is a sub-control (ComboBox or TextBox)
            if ($controlName.EndsWith("_COMBO") -or $controlName.EndsWith("_TEXT")) {
                # Get the parent checkbox name
                $parentCheckboxName = $controlName -replace "_COMBO|_TEXT", ""
                
                if ($UiHash.ConfigurationControls.ContainsKey($parentCheckboxName)) {
                    $parentCheckbox = $UiHash.ConfigurationControls[$parentCheckboxName]
                    $control.Visible = $parentCheckbox.Checked
                    
                    # Handle description visibility - show when sub-control is hidden
                    $descLabelName = "${controlName}_DESC"
                    if ($UiHash.ConfigurationControls.ContainsKey($descLabelName)) {
                        $UiHash.ConfigurationControls[$descLabelName].Visible = $parentCheckbox.Checked
                    }
                    
                    # Handle placeholder description - show when sub-control is hidden
                    $placeholderDescName = "${parentCheckboxName}_PLACEHOLDER_DESC"
                    if ($UiHash.ConfigurationControls.ContainsKey($placeholderDescName)) {
                        $UiHash.ConfigurationControls[$placeholderDescName].Visible = -not $parentCheckbox.Checked
                    }
                }
            }
        }
    }
}

# Save current control states before regenerating
Save-ControlStates -UiHash $UiHash

# Initialize storage for configuration controls
$UiHash.ConfigurationControls = @{}
$UiHash.ConfigurationControlsOrdered = [System.Collections.Generic.List[System.Windows.Forms.Control]]::new()

# Get the configuration sections (Install, Settings, Drivers, etc.) and sort them
$configSections = $ConfigDefinition.Configuration.PSObject.Properties.Name | Sort-Object

$yPosition = 10

# Helper function to calculate text height
function Get-TextHeight {
    param(
        [string]$text,
        [System.Drawing.Font]$font,
        [int]$width
    )
    
    if ([string]::IsNullOrEmpty($text)) {
        return $font.Height
    }
    
    $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    $size = $graphics.MeasureString($text, $font, $width)
    $graphics.Dispose()
    return [Math]::Ceiling($size.Height)
}

# Helper function to calculate required height for multi-line text
function Get-MultiLineTextHeight {
    param(
        [string]$text,
        [System.Drawing.Font]$font,
        [int]$width,
        [int]$minLines = 1
    )
    
    if ([string]::IsNullOrEmpty($text)) {
        return $font.Height * $minLines
    }
    
    $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    $size = $graphics.MeasureString($text, $font, $width)
    $graphics.Dispose()
    
    $calculatedHeight = [Math]::Ceiling($size.Height)
    $minHeight = $font.Height * $minLines
    
    return [Math]::Max($calculatedHeight, $minHeight)
}

# Process each section
foreach ($sectionName in $configSections) {
    $section = $ConfigDefinition.Configuration.$sectionName
    
    # Create section title with only first letter capitalized
    $sectionTitle = New-Object System.Windows.Forms.Label
    $formattedSectionName = $sectionName.Substring(0,1).ToUpper() + $sectionName.Substring(1).ToLower()
    $sectionTitle.Text = $formattedSectionName + ":"
    $sectionTitle.Location = New-Object System.Drawing.Point(10, $yPosition)
    $sectionTitle.Size = New-Object System.Drawing.Size(170, 25)
    $sectionTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $sectionTitle.ForeColor = [System.Drawing.Color]::DarkBlue
    $sectionTitle.BackColor = [System.Drawing.Color]::Transparent
    $sectionTitle.Name = "${sectionName}_TITLE"
    $UiHash.ConfigurationControlsOrdered.Add($sectionTitle)
    
    $yPosition += 35
    
    # Get all items in this section and sort them by DisplayName
    $items = $section.PSObject.Properties.Name | Sort-Object { $section.$_.DisplayName }
    
    # Process each item in this section
    foreach ($itemName in $items) {
        $item = $section.$itemName
        
        # Create the appropriate control based on type
        $control = $null
        $subControl = $null
        
        # Determine if checkbox should be checked (check preserved state first)
        $isChecked = $false
        if ($UiHash.ContainsKey('PreservedControlStates') -and $UiHash.PreservedControlStates.ContainsKey($itemName)) {
            $isChecked = $UiHash.PreservedControlStates[$itemName]
        } else {
            # Use default state for first-time creation
            if ($item.Type -eq "CheckBox") {
                $isChecked = ($item.DefaultState -eq "true")
            } else {
                $isChecked = ($item.DefaultState -ne $null -and $item.DefaultState -ne "")
            }
        }
        
        switch ($item.Type) {
            "CheckBox" {
                $control = New-Object System.Windows.Forms.CheckBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Text = $item.DisplayName
                $control.Checked = $isChecked
                $control.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                $control.BackColor = [System.Drawing.Color]::Transparent
                $control.AutoSize = $false
                
                # Calculate required height for the checkbox text
                $checkboxHeight = Get-TextHeight -text $item.DisplayName -font $control.Font -width 170
                # Ensure minimum height for checkbox functionality
                $checkboxHeight = [Math]::Max($checkboxHeight, 20)
                
                $control.Size = New-Object System.Drawing.Size(170, $checkboxHeight)
                
                $yPosition += $checkboxHeight + 5
                
                # Add description label below CheckBox with auto-sizing
                $descLabel = New-Object System.Windows.Forms.Label
                $descLabel.Text = $item.Description
                $descLabel.Location = New-Object System.Drawing.Point(20, $yPosition)
                $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $descLabel.ForeColor = [System.Drawing.Color]::Gray
                $descLabel.BackColor = [System.Drawing.Color]::Transparent
                $descLabel.AutoSize = $false
                $descLabel.MaximumSize = New-Object System.Drawing.Size(170, 0)
                
                # Calculate required height for the description
                $descHeight = Get-TextHeight -text $item.Description -font $descLabel.Font -width 170
                $descLabel.Size = New-Object System.Drawing.Size(170, $descHeight)
                
                $descLabel.Name = "${itemName}_DESC"
                $UiHash.ConfigurationControlsOrdered.Add($descLabel)
                
                $yPosition += $descHeight + 10
            }
            "ComboBox" {
                # Create main checkbox for ComboBox with dynamic sizing
                $control = New-Object System.Windows.Forms.CheckBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Text = $item.DisplayName
                $control.Checked = $isChecked
                $control.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                $control.BackColor = [System.Drawing.Color]::Transparent
                $control.AutoSize = $false
                
                # Calculate required height for the checkbox text
                $checkboxHeight = Get-TextHeight -text $item.DisplayName -font $control.Font -width 170
                # Ensure minimum height for checkbox functionality
                $checkboxHeight = [Math]::Max($checkboxHeight, 20)
                
                $control.Size = New-Object System.Drawing.Size(170, $checkboxHeight)
                
                $yPosition += $checkboxHeight + 5
                
                # Always create description label - it will be positioned based on checkbox state
                $descHeight = Get-TextHeight -text $item.Description -font (New-Object System.Drawing.Font("Segoe UI", 8)) -width 130
                
                if ($isChecked) {
                    # Create the ComboBox as a sub-control
                    $subControl = New-Object System.Windows.Forms.ComboBox
                    $subControl.Location = New-Object System.Drawing.Point(40, $yPosition)
                    $subControl.Size = New-Object System.Drawing.Size(130, 25)
                    $subControl.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
                    $subControl.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                    $subControl.Visible = $true
                    
                    # Add options
                    foreach ($option in $item.Options) {
                        $subControl.Items.Add($option)
                    }
                    
                    # Set default or preserved value
                    $comboValue = $null
                    if ($UiHash.ContainsKey('PreservedControlStates') -and $UiHash.PreservedControlStates.ContainsKey("${itemName}_COMBO")) {
                        $comboValue = $UiHash.PreservedControlStates["${itemName}_COMBO"]
                    } else {
                        $comboValue = $item.DefaultState
                    }
                    
                    if ($comboValue -and $subControl.Items.Contains($comboValue)) {
                        $subControl.SelectedItem = $comboValue
                    } elseif ($subControl.Items.Count -gt 0) {
                        $subControl.SelectedIndex = 0
                    }
                    
                    $subControl.Name = "${itemName}_COMBO"
                    $subControl.Tag = @{
                        Section = $sectionName
                        Item = $itemName
                        Type = "ComboBox"
                        ParentCheckbox = $itemName
                        Script = if ($item.PSObject.Properties.Name -contains "Script") { $item.Script } else { $null }
                        PreConfigScript = if ($item.PSObject.Properties.Name -contains "PreConfigScript") { $item.PreConfigScript } else { $null }
                        DisplayName = $item.DisplayName
                        Description = $item.Description
                    }
                    
                    $UiHash.ConfigurationControlsOrdered.Add($subControl)
                    $UiHash.ConfigurationControls["${itemName}_COMBO"] = $subControl
                    
                    $yPosition += 30
                    
                    # Add description label below ComboBox
                    $descLabel = New-Object System.Windows.Forms.Label
                    $descLabel.Text = $item.Description
                    $descLabel.Location = New-Object System.Drawing.Point(40, $yPosition)
                    $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                    $descLabel.ForeColor = [System.Drawing.Color]::Gray
                    $descLabel.BackColor = [System.Drawing.Color]::Transparent
                    $descLabel.AutoSize = $false
                    $descLabel.MaximumSize = New-Object System.Drawing.Size(130, 0)
                    $descLabel.Visible = $true
                    $descLabel.Size = New-Object System.Drawing.Size(130, $descHeight)
                    
                    $descLabel.Name = "${itemName}_COMBO_DESC"
                    $UiHash.ConfigurationControlsOrdered.Add($descLabel)
                    $UiHash.ConfigurationControls["${itemName}_COMBO_DESC"] = $descLabel
                    
                } else {
                    # Create placeholder description in the sub-control's position
                    $placeholderDesc = New-Object System.Windows.Forms.Label
                    $placeholderDesc.Text = $item.Description
                    $placeholderDesc.Location = New-Object System.Drawing.Point(40, $yPosition)
                    $placeholderDesc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                    $placeholderDesc.ForeColor = [System.Drawing.Color]::Gray
                    $placeholderDesc.BackColor = [System.Drawing.Color]::Transparent
                    $placeholderDesc.AutoSize = $false
                    $placeholderDesc.MaximumSize = New-Object System.Drawing.Size(130, 0)
                    $placeholderDesc.Visible = $true
                    $placeholderDesc.Size = New-Object System.Drawing.Size(130, $descHeight)
                    
                    $placeholderDesc.Name = "${itemName}_PLACEHOLDER_DESC"
                    $UiHash.ConfigurationControlsOrdered.Add($placeholderDesc)
                    $UiHash.ConfigurationControls["${itemName}_PLACEHOLDER_DESC"] = $placeholderDesc
                }
                
                $yPosition += $descHeight + 10
            }
            "TextBox" {
                # Create main checkbox for TextBox with dynamic sizing
                $control = New-Object System.Windows.Forms.CheckBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Text = $item.DisplayName
                $control.Checked = $isChecked
                $control.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                $control.BackColor = [System.Drawing.Color]::Transparent
                $control.AutoSize = $false
                
                # Calculate required height for the checkbox text
                $checkboxHeight = Get-TextHeight -text $item.DisplayName -font $control.Font -width 170
                # Ensure minimum height for checkbox functionality
                $checkboxHeight = [Math]::Max($checkboxHeight, 20)
                
                $control.Size = New-Object System.Drawing.Size(170, $checkboxHeight)
                
                $yPosition += $checkboxHeight + 5
                
                # Calculate description height for consistent spacing
                $descHeight = Get-TextHeight -text $item.Description -font (New-Object System.Drawing.Font("Segoe UI", 8)) -width 130
                
                if ($isChecked) {
                    # Get preserved text or use default
                    $textValue = ""
                    if ($UiHash.ContainsKey('PreservedControlStates') -and $UiHash.PreservedControlStates.ContainsKey("${itemName}_TEXT")) {
                        $textValue = $UiHash.PreservedControlStates["${itemName}_TEXT"]
                    } else {
                        $textValue = if ($item.DefaultState) { $item.DefaultState } else { "" }
                    }
                    
                    # Create the TextBox as a sub-control
                    $subControl = New-Object System.Windows.Forms.TextBox
                    $subControl.Location = New-Object System.Drawing.Point(40, $yPosition)
                    $subControl.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                    $subControl.Visible = $true
                    $subControl.Multiline = $true
                    $subControl.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
                    $subControl.WordWrap = $true
                    $subControl.Text = $textValue
                    
                    # Calculate required height for the text (minimum 2 lines)
                    $textHeight = Get-MultiLineTextHeight -text $textValue -font $subControl.Font -width 130 -minLines 2
                    $subControl.Size = New-Object System.Drawing.Size(130, $textHeight)
                    
                    $subControl.Name = "${itemName}_TEXT"
                    $subControl.Tag = @{
                        Section = $sectionName
                        Item = $itemName
                        Type = "TextBox"
                        ParentCheckbox = $itemName
                        Script = if ($item.PSObject.Properties.Name -contains "Script") { $item.Script } else { $null }
                        PreConfigScript = if ($item.PSObject.Properties.Name -contains "PreConfigScript") { $item.PreConfigScript } else { $null }
                        DisplayName = $item.DisplayName
                        Description = $item.Description
                    }
                    
                    $UiHash.ConfigurationControlsOrdered.Add($subControl)
                    $UiHash.ConfigurationControls["${itemName}_TEXT"] = $subControl
                    
                    $yPosition += $textHeight + 5
                    
                    # Add description label below TextBox
                    $descLabel = New-Object System.Windows.Forms.Label
                    $descLabel.Text = $item.Description
                    $descLabel.Location = New-Object System.Drawing.Point(40, $yPosition)
                    $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                    $descLabel.ForeColor = [System.Drawing.Color]::Gray
                    $descLabel.BackColor = [System.Drawing.Color]::Transparent
                    $descLabel.AutoSize = $false
                    $descLabel.MaximumSize = New-Object System.Drawing.Size(130, 0)
                    $descLabel.Visible = $true
                    $descLabel.Size = New-Object System.Drawing.Size(130, $descHeight)
                    
                    $descLabel.Name = "${itemName}_TEXT_DESC"
                    $UiHash.ConfigurationControlsOrdered.Add($descLabel)
                    $UiHash.ConfigurationControls["${itemName}_TEXT_DESC"] = $descLabel
                    
                    $yPosition += $descHeight + 10
                    
                } else {
                    # Create placeholder description in the sub-control's position
                    $placeholderDesc = New-Object System.Windows.Forms.Label
                    $placeholderDesc.Text = $item.Description
                    $placeholderDesc.Location = New-Object System.Drawing.Point(40, $yPosition)
                    $placeholderDesc.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                    $placeholderDesc.ForeColor = [System.Drawing.Color]::Gray
                    $placeholderDesc.BackColor = [System.Drawing.Color]::Transparent
                    $placeholderDesc.AutoSize = $false
                    $placeholderDesc.MaximumSize = New-Object System.Drawing.Size(130, 0)
                    $placeholderDesc.Visible = $true
                    $placeholderDesc.Size = New-Object System.Drawing.Size(130, $descHeight)
                    
                    $placeholderDesc.Name = "${itemName}_PLACEHOLDER_DESC"
                    $UiHash.ConfigurationControlsOrdered.Add($placeholderDesc)
                    $UiHash.ConfigurationControls["${itemName}_PLACEHOLDER_DESC"] = $placeholderDesc
                    
                    $yPosition += $descHeight + 10
                }
            }
        }
        
        if ($control) {
            # Use only the itemName without the section prefix
            $control.Name = $itemName
            $control.Tag = @{
                Section = $sectionName
                Item = $itemName
                Type = $item.Type
                Script = if ($item.PSObject.Properties.Name -contains "Script") { $item.Script } else { $null }
                PreConfigScript = if ($item.PSObject.Properties.Name -contains "PreConfigScript") { $item.PreConfigScript } else { $null }
                DisplayName = $item.DisplayName
                Description = $item.Description
            }
            
            # Add event handlers
            switch ($item.Type) {
                "CheckBox" {
                    $control.Add_CheckedChanged({
                        $Global:UiHash.ConfigurationChanged = $true
                    })
                }
                "ComboBox" {
                    # Main checkbox event handler for ComboBox
                    $control.Add_CheckedChanged({
                        # Force a full panel refresh while preserving settings
                        $Global:UiHash.REFRESH_CONFIG_PANEL = $true
                    })
                    
                    # Sub-control event handler (only if it exists)
                    if ($subControl) {
                        $subControl.Add_SelectedIndexChanged({
                            $Global:UiHash.ConfigurationChanged = $true
                        })
                    }
                }
                "TextBox" {
                    # Main checkbox event handler for TextBox
                    $control.Add_CheckedChanged({
                        # Force a full panel refresh while preserving settings
                        $Global:UiHash.REFRESH_CONFIG_PANEL = $true
                    })
                    
                    # Sub-control text changed only marks as changed, no refresh (only if it exists)
                    if ($subControl) {
                        $subControl.Add_TextChanged({
                            $Global:UiHash.ConfigurationChanged = $true
                        })
                    }
                }
            }
            
            # Add control to ordered list
            $UiHash.ConfigurationControlsOrdered.Add($control)
            
            # Store control using only the itemName as key
            $UiHash.ConfigurationControls[$itemName] = $control
        }
        
        # Add spacing between items
        $yPosition += 10
    }
    
    # Add extra spacing between sections
    $yPosition += 20
}

# Initialize change tracking
$UiHash.ConfigurationChanged = $false

# Restore control states after regenerating (this handles any missed state restoration)
Restore-ControlStates -UiHash $UiHash

Write-Host "Configuration UI generated successfully. Total controls: $($UiHash.ConfigurationControls.Count)"