# This script generates UI controls for the default configuration and stores them for later use.
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Import the necessary assemblies for Windows Forms and Drawing.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Read the configuration definition file
$ConfigDefinition = Get-Content -Path "$($Global:UiHash['PSScriptroot'])\Assets\refs\DefaultConfigDefinition.json" -Raw | ConvertFrom-Json

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
    
    $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    $size = $graphics.MeasureString($text, $font, $width)
    $graphics.Dispose()
    return [Math]::Ceiling($size.Height)
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
        switch ($item.Type) {
            "CheckBox" {
                $control = New-Object System.Windows.Forms.CheckBox
                $control.Location = New-Object System.Drawing.Point(20, $yPosition)
                $control.Size = New-Object System.Drawing.Size(170, 20)
                $control.Text = $item.DisplayName
                $control.Checked = ($item.DefaultState -eq "true")
                $control.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                $control.BackColor = [System.Drawing.Color]::Transparent
                
                $yPosition += 25
                
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
                
                $descLabel.Name = "${sectionName}_${itemName}_DESC"
                $UiHash.ConfigurationControlsOrdered.Add($descLabel)
                
                $yPosition += $descHeight + 10
            }
            "ComboBox" {
                # Create title label for ComboBox
                $titleLabel = New-Object System.Windows.Forms.Label
                $titleLabel.Text = $item.DisplayName
                $titleLabel.Location = New-Object System.Drawing.Point(20, $yPosition)
                $titleLabel.Size = New-Object System.Drawing.Size(140, 20)
                $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
                $titleLabel.BackColor = [System.Drawing.Color]::Transparent
                $titleLabel.Name = "${sectionName}_${itemName}_TITLE"
                $UiHash.ConfigurationControlsOrdered.Add($titleLabel)
                
                $yPosition += 25
                
                $control = New-Object System.Windows.Forms.ComboBox
                $control.Location = New-Object System.Drawing.Point(30, $yPosition)
                $control.Size = New-Object System.Drawing.Size(140, 25)
                $control.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
                $control.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                
                # Add options
                foreach ($option in $item.Options) {
                    $control.Items.Add($option)
                }
                
                # Set default value
                if ($item.DefaultState -and $control.Items.Contains($item.DefaultState)) {
                    $control.SelectedItem = $item.DefaultState
                } elseif ($control.Items.Count -gt 0) {
                    $control.SelectedIndex = 0
                }
                
                $yPosition += 30
                
                # Add description label below ComboBox with auto-sizing
                $descLabel = New-Object System.Windows.Forms.Label
                $descLabel.Text = $item.Description
                $descLabel.Location = New-Object System.Drawing.Point(30, $yPosition)
                $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $descLabel.ForeColor = [System.Drawing.Color]::Gray
                $descLabel.BackColor = [System.Drawing.Color]::Transparent
                $descLabel.AutoSize = $false
                $descLabel.MaximumSize = New-Object System.Drawing.Size(140, 0)
                
                # Calculate required height for the description
                $descHeight = Get-TextHeight -text $item.Description -font $descLabel.Font -width 140
                $descLabel.Size = New-Object System.Drawing.Size(140, $descHeight)
                
                $descLabel.Name = "${sectionName}_${itemName}_DESC"
                $UiHash.ConfigurationControlsOrdered.Add($descLabel)
                
                $yPosition += $descHeight + 10
            }
            "TextBox" {
                # Create title label for TextBox
                $titleLabel = New-Object System.Windows.Forms.Label
                $titleLabel.Text = $item.DisplayName
                $titleLabel.Location = New-Object System.Drawing.Point(20, $yPosition)
                $titleLabel.Size = New-Object System.Drawing.Size(140, 20)
                $titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
                $titleLabel.BackColor = [System.Drawing.Color]::Transparent
                $titleLabel.Name = "${sectionName}_${itemName}_TITLE"
                $UiHash.ConfigurationControlsOrdered.Add($titleLabel)
                
                $yPosition += 25
                
                $control = New-Object System.Windows.Forms.TextBox
                $control.Location = New-Object System.Drawing.Point(30, $yPosition)
                $control.Size = New-Object System.Drawing.Size(140, 25)
                $control.Text = if ($item.DefaultState) { $item.DefaultState } else { "" }
                $control.Font = New-Object System.Drawing.Font("Segoe UI", 9)
                
                $yPosition += 30
                
                # Add description label below TextBox with auto-sizing
                $descLabel = New-Object System.Windows.Forms.Label
                $descLabel.Text = $item.Description
                $descLabel.Location = New-Object System.Drawing.Point(30, $yPosition)
                $descLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
                $descLabel.ForeColor = [System.Drawing.Color]::Gray
                $descLabel.BackColor = [System.Drawing.Color]::Transparent
                $descLabel.AutoSize = $false
                $descLabel.MaximumSize = New-Object System.Drawing.Size(140, 0)
                
                # Calculate required height for the description
                $descHeight = Get-TextHeight -text $item.Description -font $descLabel.Font -width 140
                $descLabel.Size = New-Object System.Drawing.Size(140, $descHeight)
                
                $descLabel.Name = "${sectionName}_${itemName}_DESC"
                $UiHash.ConfigurationControlsOrdered.Add($descLabel)
                
                $yPosition += $descHeight + 10
            }
        }
        
        if ($control) {
            $control.Name = "${sectionName}_${itemName}"
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
                    $control.Add_SelectedIndexChanged({
                        $Global:UiHash.ConfigurationChanged = $true
                    })
                }
                "TextBox" {
                    $control.Add_TextChanged({
                        $Global:UiHash.ConfigurationChanged = $true
                    })
                }
            }
            
            # Add control to ordered list
            $UiHash.ConfigurationControlsOrdered.Add($control)
            
            # Store control in single hashtable using unique key
            $uniqueKey = "${sectionName}_${itemName}"
            $UiHash.ConfigurationControls[$uniqueKey] = $control
        }
        
        # Add spacing between items
        $yPosition += 10
    }
    
    # Add extra spacing between sections
    $yPosition += 20
}

# Initialize change tracking
$UiHash.ConfigurationChanged = $false

Write-Host "Configuration UI generated successfully. Total controls: $($UiHash.ConfigurationControls.Count)"