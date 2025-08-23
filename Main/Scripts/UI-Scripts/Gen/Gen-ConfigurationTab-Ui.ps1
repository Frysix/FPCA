# This script serves to generate the UI for the configuration tab in FPCA.
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Safety checks
if (-not $UiHash) {
    Write-Host "Error: UiHash parameter is required" -ForegroundColor Red
    return
}

try {
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
} catch {
    Write-Host "Error loading Windows Forms assemblies: $($_.Exception.Message)" -ForegroundColor Red
    return
}

$UiHash.ConfigTabDefinitionElements = @{}

if ($null -ne $UiHash.EnabledMods) {
    foreach ($mod in $UiHash.EnabledMods.Keys) {
        if ($UiHash.EnabledMods[$mod].ContainsKey('Mod_Data') -and $UiHash.EnabledMods[$mod].Mod_Data.ContainsKey("Configuration")) {
            foreach ($category in $UiHash.EnabledMods[$mod].Mod_Data.Configuration.Keys) {
                if (-not ($UiHash.ConfigTabDefinitionElements.ContainsKey($category))) {
                    $UiHash.ConfigTabDefinitionElements[$category] = @{}
                }
                foreach ($config in $UiHash.EnabledMods[$mod].Mod_Data.Configuration[$category].Keys) {
                    $UiHash.ConfigTabDefinitionElements[$category][$config] = $UiHash.EnabledMods[$mod].Mod_Data.Configuration[$category][$config]
                }
            }
        } else {
            Write-Host "Mod $mod does not contain Configuration data, skipping..." -ForegroundColor Yellow
        }
    }
}

# Import ParsingHelper module for JSON parsing
Try {
    Import-Module -Name "$($UiHash['PSScriptroot'])\Helper\ParsingHelper.psm1" -Force
} Catch {
    Write-Host "Failed to import ParsingHelper module. Please ensure it is present in the Helper directory."
    Exit 1 
}

# Get the default configuration elements
$DefaultConfigDefinition = Convert-JsonToHashtable -FilePath "$($UiHash['PSScriptroot'])\Assets\refs\DefaultConfigDefinition.json"

if ($DefaultConfigDefinition -and $DefaultConfigDefinition.ContainsKey('Configuration')) {
    foreach ($category in $DefaultConfigDefinition.Configuration.Keys) {
        if (-not ($UiHash.ConfigTabDefinitionElements.ContainsKey($category))) {
            $UiHash.ConfigTabDefinitionElements[$category] = @{}
        }
        foreach ($config in $DefaultConfigDefinition.Configuration[$category].Keys) {
            if (-not ($UiHash.ConfigTabDefinitionElements[$category].ContainsKey($config))) {
                $UiHash.ConfigTabDefinitionElements[$category][$config] = $DefaultConfigDefinition.Configuration[$category][$config]
            }
        }
    }
} else {
    Write-Host "Warning: Default configuration definition is missing or malformed." -ForegroundColor Yellow
    Throw
}

# Reset all Previous Check States
$PreviousCheckStates = @{}
# If the ConfigTabUIElements already exists, store the previous check states

if ($UiHash.ConfigTabUIElements -and $UiHash.ConfigTabUIElements.ContainsKey('Configs')) {
    # Store the previous check states of the checkboxes
    foreach ($config in $UiHash.ConfigTabUIElements.Configs.Keys) {
        if ($UiHash.ConfigTabUIElements.Configs[$config].ContainsKey('MainCheckBox')) {
            if (-not $PreviousCheckStates.ContainsKey($config)) {
                $PreviousCheckStates[$config] = @{}
            }
            $PreviousCheckStates[$config]['MainCheckBox'] = $UiHash.ConfigTabUIElements.Configs[$config].MainCheckBox.Checked
        }
    }
}

# Reset de ConfigTabUIElements
$UiHash.ConfigTabUIElements = @{
    Configs = @{}
    Categories = @{}
}

# Initialize positioning variables
[int]$Row1XPoint = 5
[int]$Row2XPoint = 225
[int]$Row1YPoint = 5
[int]$Row2YPoint = 5
[bool]$Row1 = $true
[bool]$doPlaceTextBox = $false
[bool]$doPlaceComboBox = $false
[bool]$doPlaceInstallOptions = $false

# Safety check: Ensure ConfigTabDefinitionElements exists and is not empty
if (-not $UiHash.ConfigTabDefinitionElements -or $UiHash.ConfigTabDefinitionElements.Keys.Count -eq 0) {
    Write-Host "Warning: No configuration elements found to generate UI." -ForegroundColor Yellow
    return
}

# Iterate over each category and its configurations and create UI elements
foreach ($category in $UiHash.ConfigTabDefinitionElements.Keys) {

    # Create a Category Label
    $CategoryLabel = New-Object System.Windows.Forms.Label
    $CategoryLabel.Text = "${category}:"
    $CategoryLabel.Font = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
    $CategoryLabel.ForeColor = [System.Drawing.Color]::Blue
    $CategoryLabel.Size = New-Object System.Drawing.Size(220, 30)

    #Locationing for category labels
    if ($Row1) {
        $CategoryLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
        $Row1YPoint += 35
    } else {
        $CategoryLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
        $Row2YPoint += 35
    }

    # Store the Category Label in the hashtable
    $UiHash.ConfigTabUIElements.Categories[$category] = $CategoryLabel

    # Go over each config in the category
    foreach ($config in $UiHash.ConfigTabDefinitionElements[$category].Keys) {

        # Initialize the hashtable for this config
        $UiHash.ConfigTabUIElements.Configs[$config] = @{}

        # Create a Title for the config
        $ConfigTitleLabel = New-Object System.Windows.Forms.Label
        $ConfigTitleLabel.Text = "$($UiHash.ConfigTabDefinitionElements[$category][$config]['DisplayName']):"
        $ConfigTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
        $ConfigTitleLabel.ForeColor = [System.Drawing.Color]::Black
        $ConfigTitleLabel.MaximumSize = New-Object System.Drawing.Size(180, 0)
        $ConfigTitleLabel.AutoSize = $true
        # Calculate the actual height needed for the text
        $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
        $textSize = $graphics.MeasureString($ConfigTitleLabel.Text, $ConfigTitleLabel.Font, 180)
        $calculatedHeight = [Math]::Ceiling($textSize.Height)
        $graphics.Dispose()
        $configtitlefinalHeight = [Math]::Max(20, $calculatedHeight)
        # Assign the size with the calculated height
        $ConfigTitleLabel.Size = New-Object System.Drawing.Size(180, $configtitlefinalHeight)

        # Create a label for the config description
        $DescriptionLabel = New-Object System.Windows.Forms.Label
        $DescriptionLabel.Text = "$($UiHash.ConfigTabDefinitionElements[$category][$config]['Description'])"
        $DescriptionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)
        $DescriptionLabel.ForeColor = [System.Drawing.Color]::DarkGray
        $DescriptionLabel.MaximumSize = New-Object System.Drawing.Size(180, 0)
        $DescriptionLabel.AutoSize = $true
        # Calculate the actual height needed for the text
        $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
        $textSize = $graphics.MeasureString($DescriptionLabel.Text, $DescriptionLabel.Font, 180)
        $calculatedHeight = [Math]::Ceiling($textSize.Height)
        $graphics.Dispose()
        $descriptionfinalHeight = [Math]::Max(15, $calculatedHeight)
        # Assign the size with the calculated height
        $DescriptionLabel.Size = New-Object System.Drawing.Size(180, $descriptionfinalHeight)

        # Create a checkbox for enabling/disabling the config
        $MainCheckBox = New-Object System.Windows.Forms.CheckBox
        $MainCheckBox.Text = "Enable"
        $MainCheckBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
        $MainCheckBox.Size = New-Object System.Drawing.Size(70, 20)
        # Set the checkbox state based on previous state or default
        if ($PreviousCheckStates.ContainsKey($config)) {
            $MainCheckBox.Checked = $PreviousCheckStates[$config]['MainCheckBox']
            if ($MainCheckBox.Checked) {
                $MainCheckBox.ForeColor = [System.Drawing.Color]::Green
            } else {
                $MainCheckBox.ForeColor = [System.Drawing.Color]::Black
            }
        } else {
            if ($UiHash.ConfigTabDefinitionElements[$category][$config].ContainsKey('DefaultState') -and $UiHash.ConfigTabDefinitionElements[$category][$config].DefaultState -eq 'true') {
                $MainCheckBox.Checked = $true
                $MainCheckBox.ForeColor = [System.Drawing.Color]::Green
            } else {
                $MainCheckBox.Checked = $false
                $MainCheckBox.ForeColor = [System.Drawing.Color]::Black
            }
        }

        # Check the configs type to determine secondary controls
        switch ($UiHash.ConfigTabDefinitionElements[$category][$config]['Type']) {
            "CheckBox" {
                # No additional controls needed for CheckBox type
                Write-Host "Simple CheckBox type, no additional controls needed." -ForegroundColor Cyan
            }
            "TextBox" {
                # If the maincheckbox is checked, create a TextBox for user input
                if ($MainCheckBox.Checked) {
                    $InputTextBox = New-Object System.Windows.Forms.TextBox
                    if ($UiHash.ConfigTabDefinitionElements[$category][$config].ContainsKey('DefaultText')) {
                        $InputTextBox.Text = "$($UiHash.ConfigTabDefinitionElements[$category][$config]['DefaultText'])"
                    } else {
                        $InputTextBox.Text = ""
                    }
                    $InputTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
                    $InputTextBox.Size = New-Object System.Drawing.Size(120, 20)
                    $doPlaceTextBox = $true
                    Write-Host "TextBox created for config ${config} with default text '$($InputTextBox.Text)'." -ForegroundColor Cyan
                }
            }
            "ComboBox" {
                # If the maincheckbox is checked, create a ComboBox for user selection
                if ($MainCheckBox.Checked -and $UiHash.ConfigTabDefinitionElements[$category][$config].ContainsKey('Options')) {
                    $InputComboBox = New-Object System.Windows.Forms.ComboBox
                    $InputComboBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
                    $InputComboBox.Size = New-Object System.Drawing.Size(120, 20)
                    foreach ($option in $UiHash.ConfigTabDefinitionElements[$category][$config]['Options']) {
                        $InputComboBox.Items.Add($option) | Out-Null
                    }
                    # Set default selected item if specified
                    if ($UiHash.ConfigTabDefinitionElements[$category][$config].ContainsKey('DefaultOption')) {
                        $InputComboBox.SelectedItem = "$($UiHash.ConfigTabDefinitionElements[$category][$config]['DefaultOption'])"
                    } else {
                        $InputComboBox.SelectedIndex = 0
                    }
                    $doPlaceComboBox = $true
                    Write-Host "ComboBox created for config: ${config} with options." -ForegroundColor Cyan
                } else {
                    Write-Host "Warning: ComboBox type specified but no Options provided for config: ${config}." -ForegroundColor Yellow
                }
            }
        }

        # Checks if the category is Install, if so, create additional UI elements
        if ($category -eq "Install" -and $MainCheckBox.Checked) {
            # Create base install checkboxes
            # Create shortcut option
            $CreateShortcutCheckBox = New-Object System.Windows.Forms.CheckBox
            $CreateShortcutCheckBox.Text = "Create Desktop Shortcut"
            $CreateShortcutCheckBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
            $CreateShortcutCheckBox.Size = New-Object System.Drawing.Size(180, 20)

            # Create default remind option checkbox
            $RemindDefaultCheckBox = New-Object System.Windows.Forms.CheckBox
            $RemindDefaultCheckBox.Text = "Remind to set as default"
            $RemindDefaultCheckBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
            $RemindDefaultCheckBox.Size = New-Object System.Drawing.Size(180, 20)

            if ($UiHash.ConfigTabDefinitionElements[$category][$config].ContainsKey('OptionsDefaults')) {
                if ($UiHash.ConfigTabDefinitionElements[$category][$config].OptionsDefaults.ContainsKey('CreateShortcut') -and $UiHash.ConfigTabDefinitionElements[$category][$config].OptionsDefaults.CreateShortcut -eq 'true') {
                    $CreateShortcutCheckBox.Checked = $true
                    $CreateShortcutCheckBox.ForeColor = [System.Drawing.Color]::Green
                } else {
                    $CreateShortcutCheckBox.Checked = $false
                    $CreateShortcutCheckBox.ForeColor = [System.Drawing.Color]::Black
                }
                if ($UiHash.ConfigTabDefinitionElements[$category][$config].OptionsDefaults.ContainsKey('RemindDefault') -and $UiHash.ConfigTabDefinitionElements[$category][$config].OptionsDefaults.RemindDefault -eq 'true') {
                    $RemindDefaultCheckBox.Checked = $true
                    $RemindDefaultCheckBox.ForeColor = [System.Drawing.Color]::Green
                } else {
                    $RemindDefaultCheckBox.Checked = $false
                    $RemindDefaultCheckBox.ForeColor = [System.Drawing.Color]::Black
                }
            } else {
                # Default both to unchecked if no defaults provided
                $CreateShortcutCheckBox.Checked = $false
                $CreateShortcutCheckBox.ForeColor = [System.Drawing.Color]::Black
                $RemindDefaultCheckBox.Checked = $false
                $RemindDefaultCheckBox.ForeColor = [System.Drawing.Color]::Black
            }

            $doPlaceInstallOptions = $true
            Write-Host "Install options created for config: ${config}." -ForegroundColor Cyan
        }

        # Locationing for config elements
        if ($Row1) {
            $Row1XPoint += 5
            $ConfigTitleLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
            $Row1YPoint += $configtitlefinalHeight + 5
            $Row1XPoint += 10
            $DescriptionLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
            $Row1YPoint += $descriptionfinalHeight + 5
            $MainCheckBox.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
            $Row1YPoint += 25
            if ($doPlaceTextBox) {
                $Row1XPoint += 5
                $InputTextBox.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                $Row1XPoint -= 5
                $Row1YPoint += 25
            } elseif ($doPlaceComboBox) {
                $Row1XPoint += 5
                $InputComboBox.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                $Row1XPoint -= 5
                $Row1YPoint += 25
            }
            if ($doPlaceInstallOptions) {
                $Row1XPoint += 5
                $CreateShortcutCheckBox.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                $Row1YPoint += 25
                $RemindDefaultCheckBox.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                $Row1YPoint += 25
                $Row1XPoint -= 5
            }
            $Row1XPoint -= 15
        } else {
            $Row2XPoint += 5
            $ConfigTitleLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
            $Row2YPoint += $configtitlefinalHeight + 5
            $Row2XPoint += 10
            $DescriptionLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
            $Row2YPoint += $descriptionfinalHeight + 5
            $MainCheckBox.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
            $Row2YPoint += 25
            if ($doPlaceTextBox) {
                $Row2XPoint += 5
                $InputTextBox.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                $Row2XPoint -= 5
                $Row2YPoint += 25
            } elseif ($doPlaceComboBox) {
                $Row2XPoint += 5
                $InputComboBox.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                $Row2XPoint -= 5
                $Row2YPoint += 25
            }
            if ($doPlaceInstallOptions) {
                $Row2XPoint += 5
                $CreateShortcutCheckBox.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                $Row2YPoint += 25
                $RemindDefaultCheckBox.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                $Row2YPoint += 25
                $Row2XPoint -= 5
            }
            $Row2XPoint -= 15
        }

        # Store the UI elements in the hashtable
        $UiHash.ConfigTabUIElements.Configs[$config]['TitleLabel'] = $ConfigTitleLabel
        $UiHash.ConfigTabUIElements.Configs[$config]['DescriptionLabel'] = $DescriptionLabel
        $UiHash.ConfigTabUIElements.Configs[$config]['MainCheckBox'] = $MainCheckBox
        if ($doPlaceTextBox) {
            $UiHash.ConfigTabUIElements.Configs[$config]['InputTextBox'] = $InputTextBox
            $doPlaceTextBox = $false
        } elseif ($doPlaceComboBox) {
            $UiHash.ConfigTabUIElements.Configs[$config]['InputComboBox'] = $InputComboBox
            $doPlaceComboBox = $false
        }
        if ($doPlaceInstallOptions) {
            $UiHash.ConfigTabUIElements.Configs[$config]['CreateShortcutCheckBox'] = $CreateShortcutCheckBox
            $UiHash.ConfigTabUIElements.Configs[$config]['RemindDefaultCheckBox'] = $RemindDefaultCheckBox
            $doPlaceInstallOptions = $false
        }
    }
    # Make the check to compare the need to switch rows
    if ($Row1YPoint -gt $Row2YPoint) {
        $Row1 = $false
    } else {
        $Row1 = $true
    }
}