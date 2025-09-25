# Script to generate the Settings Tab UI
Param (
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

Try {
    # Import Required Assemblies
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    if (-not (Test-Path -Path "$($UiHash.PSScriptRoot)\Helper\ParsingHelper.psm1")) {
        throw "Required module ParsingHelper.psm1 not found in Helper folder."
    }
    Import-Module -Name "$($UiHash.PSScriptRoot)\Helper\ParsingHelper.psm1" -Force -ErrorAction Stop

    $UiHash.SettingsTabUIElements = @{}

    # import the settings definition and the current settings from the ini file
    if (-not (Test-Path -Path "$($UiHash.PSScriptRoot)\Assets\refs\DefaultSettingsDefinition.json")) {
        throw "Required file DefaultSettingsDefinition.json not found in Assets\refs folder."
    }
    $SettingsDefinition = Convert-JsonToHashtable -FilePath "$($UiHash.PSScriptRoot)\Assets\refs\DefaultSettingsDefinition.json"
    if (Test-Path -Path "$($UiHash.PSScriptRoot)\Settings.ini") {
        $CurrentSettings = Get-FromIniFile -FilePath "$($UiHash.PSScriptRoot)\Settings.ini"
    } else {
        New-Item -Path "$($UiHash.PSScriptRoot)\Settings.ini" -ItemType File -Force | Out-Null
        $CurrentSettings = @{}
    }
    
    # for each category in the settings definition, create a tab and add the settings
    foreach ($category in $SettingsDefinition.Settings.Keys) {
        # Initialize hashtable for each category
        if (-not $UiHash.SettingsTabUIElements.ContainsKey($category)) {
            $UiHash.SettingsTabUIElements[$category] = @{}
        }

        # Create a tab for each category
        $CategoryTab = New-Object System.Windows.Forms.TabPage
        $CategoryTab.Text = $category
        $CategoryTab.BackColor = [System.Drawing.Color]::LightGray

        # Create a panel inside the tab to hold the settings
        $CategoryPanel = New-Object System.Windows.Forms.Panel
        $CategoryPanel.Size = New-Object System.Drawing.Size(603, 350)
        $CategoryPanel.BackColor = [System.Drawing.Color]::Silver
        $CategoryPanel.Location = New-Object System.Drawing.Point(5, 5)
        $CategoryPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $CategoryPanel.AutoScroll = $true
        $CategoryTab.Controls.Add($CategoryPanel)

        # Store references in the hashtable
        $UiHash.SettingsTabUIElements[$category]['CategoryTab'] = $CategoryTab
        $UiHash.SettingsTabUIElements[$category]['CategoryPanel'] = $CategoryPanel

        #Positionning variables definition
        $Row1YPosition = 10
        $Row1XPosition = 10
        $Row2YPosition = 10
        $Row2XPosition = 280
        $Row1 = $true

        foreach ($setting in $SettingsDefinition.Settings[$category].Keys) {
            # Initialize hashtable for each setting
            if (-not $UiHash.SettingsTabUIElements[$category].ContainsKey($setting)) {
                $UiHash.SettingsTabUIElements[$category][$setting] = @{}
            }

            # Create a title label for each setting
            $DisplayNameLabel = New-Object System.Windows.Forms.Label
            $DisplayNameLabel.Text = $SettingsDefinition.Settings[$category][$setting].DisplayName
            $DisplayNameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
            $DisplayNameLabel.ForeColor = [System.Drawing.Color]::Black
            $DisplayNameLabel.AutoSize = $true
            $DisplayNameLabel.MaximumSize = New-Object System.Drawing.Size(250, 0)
            $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
            $textSize = $graphics.MeasureString($DisplayNameLabel.Text, $DisplayNameLabel.Font, 250)
            $calculatedHeight = [Math]::Ceiling($textSize.Height)
            $graphics.Dispose()
            $DisplayNameLabel_finalHeight = [Math]::Max(20, $calculatedHeight)
            $DisplayNameLabel.Size = New-Object System.Drawing.Size(250, $DisplayNameLabel_finalHeight)

            # Create a description label for each setting
            $DescriptionLabel = New-Object System.Windows.Forms.Label
            $DescriptionLabel.Text = $SettingsDefinition.Settings[$category][$setting].Description
            $DescriptionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Italic)
            $DescriptionLabel.ForeColor = [System.Drawing.Color]::White
            $DescriptionLabel.AutoSize = $true
            $DescriptionLabel.MaximumSize = New-Object System.Drawing.Size(250, 0)
            $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
            $textSize = $graphics.MeasureString($DescriptionLabel.Text, $DescriptionLabel.Font, 250)
            $calculatedHeight = [Math]::Ceiling($textSize.Height)
            $graphics.Dispose()
            $DescriptionLabel_finalHeight = [Math]::Max(20, $calculatedHeight)
            $DescriptionLabel.Size = New-Object System.Drawing.Size(250, $DescriptionLabel_finalHeight)

            # Determine the control type and create the appropriate control
            switch ($SettingsDefinition.Settings[$category][$setting].Type) {
                "CheckBox" {
                    # Create a CheckBox for each setting of type CheckBox
                    $CheckBox = New-Object System.Windows.Forms.CheckBox
                    $CheckBox.Text = "Enable"
                    $CheckBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
                    $CheckBox.ForeColor = [System.Drawing.Color]::Black
                    $CheckBox.Size = New-Object System.Drawing.Size(150, 20)
                    # Set the checked state based on current settings or default
                    if ($CurrentSettings.ContainsKey($category) -and $CurrentSettings[$category].ContainsKey($setting)) {
                        if ($CurrentSettings[$category][$setting] -eq "true") {
                            $CheckBox.Checked = $true
                        } else {
                            $CheckBox.Checked = $false
                        }
                    } else {
                        if ($SettingsDefinition.Settings[$category][$setting].Default -eq "true") {
                            $CheckBox.Checked = $true
                        } else {
                            $CheckBox.Checked = $false
                        }
                    }
                }
                "TextBox" {
                    # Create a TextBox for each setting of type TextBox
                    $TextBox = New-Object System.Windows.Forms.TextBox
                    $TextBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
                    $TextBox.Size = New-Object System.Drawing.Size(150, 20)
                    # Set the text based on current settings or default
                    if ($CurrentSettings.ContainsKey($category) -and $CurrentSettings[$category].ContainsKey($setting)) {
                        $TextBox.Text = $CurrentSettings[$category][$setting]
                    } else {
                        if ($SettingsDefinition.Settings[$category][$setting].ContainsKey('Default')) {
                            $TextBox.Text = $SettingsDefinition.Settings[$category][$setting].Default
                        } else {
                            $TextBox.Text = ""
                        }
                    }
                }
                "IntTextBox" {
                    # Create a TextBox for each setting of type IntTextBox that only allows integers
                    $IntTextBox = New-Object System.Windows.Forms.TextBox
                    $IntTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
                    $IntTextBox.Size = New-Object System.Drawing.Size(150, 20)
                    # Set the text based on current settings or default
                    if ($CurrentSettings.ContainsKey($category) -and $CurrentSettings[$category].ContainsKey($setting)) {
                        $IntTextBox.Text = $CurrentSettings[$category][$setting]
                    } else {
                        if ($SettingsDefinition.Settings[$category][$setting].ContainsKey('Default')) {
                            $IntTextBox.Text = $SettingsDefinition.Settings[$category][$setting].Default
                        } else {
                            $IntTextBox.Text = ""
                        }
                    }
                    # Add event to allow only integers
                    $IntTextBox.Add_KeyPress({
                        if (-not ([char]::IsControl($_.KeyChar) -or [char]::IsDigit($_.KeyChar))) {
                            $_.Handled = $true
                        }
                    })
                }
                "ComboBox" {
                    # Create a ComboBox for each setting of type ComboBox
                    $ComboBox = New-Object System.Windows.Forms.ComboBox
                    $ComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
                    $ComboBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
                    $ComboBox.Size = New-Object System.Drawing.Size(150, 20)
                    foreach ($option in $SettingsDefinition.Settings[$category][$setting].Options) {
                        $ComboBox.Items.Add($option) | Out-Null
                    }
                    # Set the selected value based on current settings or default
                    if ($CurrentSettings.ContainsKey($category) -and $CurrentSettings[$category].ContainsKey($setting)) {
                        $ComboBox.SelectedItem = $CurrentSettings[$category][$setting]
                    } else {
                        $ComboBox.SelectedItem = $SettingsDefinition.Settings[$category][$setting].Default
                    }
                }
            }
            # Positioning logic
            if ($Row1) {
                # Place in Row 1
                $DisplayNameLabel.Location = New-Object System.Drawing.Point($Row1XPosition, $Row1YPosition)
                $Row1YPosition += $DisplayNameLabel_finalHeight + 5
                $Row1XPosition += 6
                $DescriptionLabel.Location = New-Object System.Drawing.Point($Row1XPosition, $Row1YPosition)
                $Row1YPosition += $DescriptionLabel_finalHeight + 5
                $Row1XPosition += 3
                switch ($SettingsDefinition.Settings[$category][$setting].Type) {
                    "CheckBox" {
                        $CheckBox.Location = New-Object System.Drawing.Point($Row1XPosition, $Row1YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['CheckBox'] = $CheckBox
                    }
                    "TextBox" {
                        $TextBox.Location = New-Object System.Drawing.Point($Row1XPosition, $Row1YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['TextBox'] = $TextBox
                    }
                    "IntTextBox" {
                        $IntTextBox.Location = New-Object System.Drawing.Point($Row1XPosition, $Row1YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['IntTextBox'] = $IntTextBox
                    }
                    "ComboBox" {
                        $ComboBox.Location = New-Object System.Drawing.Point($Row1XPosition, $Row1YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['ComboBox'] = $ComboBox
                    }
                }
                $Row1YPosition += 40
                $Row1XPosition -= 9
            } else {
                # Place in Row 2
                $DisplayNameLabel.Location = New-Object System.Drawing.Point($Row2XPosition, $Row2YPosition)
                $Row2YPosition += $DisplayNameLabel_finalHeight + 5
                $Row2XPosition += 6
                $DescriptionLabel.Location = New-Object System.Drawing.Point($Row2XPosition, $Row2YPosition)
                $Row2YPosition += $DescriptionLabel_finalHeight + 5
                $Row2XPosition += 3
                switch ($SettingsDefinition.Settings[$category][$setting].Type) {
                    "CheckBox" {
                        $CheckBox.Location = New-Object System.Drawing.Point($Row2XPosition, $Row2YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['CheckBox'] = $CheckBox
                    }
                    "TextBox" {
                        $TextBox.Location = New-Object System.Drawing.Point($Row2XPosition, $Row2YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['TextBox'] = $TextBox
                    }
                    "IntTextBox" {
                        $IntTextBox.Location = New-Object System.Drawing.Point($Row2XPosition, $Row2YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['IntTextBox'] = $IntTextBox
                    }
                    "ComboBox" {
                        $ComboBox.Location = New-Object System.Drawing.Point($Row2XPosition, $Row2YPosition)
                        $UiHash.SettingsTabUIElements[$category][$setting]['ComboBox'] = $ComboBox
                    }
                }
                $Row2YPosition += 40
                $Row2XPosition -= 9
            }
            # Add recurrent references to the labels and controls in the hashtable
            $UiHash.SettingsTabUIElements[$category][$setting]['DisplayNameLabel'] = $DisplayNameLabel
            $UiHash.SettingsTabUIElements[$category][$setting]['DescriptionLabel'] = $DescriptionLabel
            # Add the labels to the panel
            $UiHash.SettingsTabUIElements[$category]['CategoryPanel'].Controls.Add($UiHash.SettingsTabUIElements[$category][$setting]['DisplayNameLabel'])
            $UiHash.SettingsTabUIElements[$category]['CategoryPanel'].Controls.Add($UiHash.SettingsTabUIElements[$category][$setting]['DescriptionLabel'])
            $UiHash.SettingsTabUIElements[$category]['CategoryPanel'].Controls.Add($UiHash.SettingsTabUIElements[$category][$setting]["$($SettingsDefinition.Settings[$category][$setting].Type)"])
            # Alternate between Row 1 and Row 2
            if ($Row1YPosition -gt $Row2YPosition) {
                $Row1 = $false
            } else {
                $Row1 = $true
            }
        }
    }

} Catch {

}