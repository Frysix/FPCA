# Script to manage settings of the app, contains a switch to reset settings to default, save settings, and trigger reload of settings
Param(
    [Parameter(Mandatory=$true,ParameterSetName='Save')]
    [switch]$Save,
    [Parameter(Mandatory=$true,ParameterSetName='Reset')]
    [switch]$Reset,
    [Parameter(Mandatory=$true,ParameterSetName='Reload')]
    [switch]$Reload,
    [Parameter(Mandatory=$false)]
    [switch]$FirstLoad = $false,
    [parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

Try {
    # Check for and import necessary helper module
    if (Test-Path -Path "$($UiHash.PSScriptRoot)\Helper\ParsingHelper.psm1") {
        Import-Module -Name "$($UiHash.PSScriptRoot)\Helper\ParsingHelper.psm1" -Force
    } else {
        Throw "ParsingHelper module not found at path: $($UiHash.PSScriptRoot)\Helper\ParsingHelper.psm1"
    }
    # Define settings file path
    $SettingsFilePath = "$($UiHash.PSScriptRoot)\Settings.ini"
    # Initialize result hashtable
    $Result = @{
        Result = $false
    }
    # Check which action to perform
    # If action is to save settings:
    if ($Save) {
        $NewSettings = @{}
        foreach ($category in $UiHash.SettingsTabUIElements.Keys) {
            if (-not $NewSettings.ContainsKey($category)) {
                $NewSettings[$category] = @{}
            }
            foreach ($setting in $UiHash.SettingsTabUIElements[$category].Keys) {
                if ($settings -ne 'CategoryPanel' -and $setting -ne 'CategoryTab') {
                    $element = $UiHash.SettingsTabUIElements[$category][$setting].Keys | Where-Object { $_ -in @('CheckBox', 'TextBox', 'ComboBox', 'IntTextBox') }
                    switch ($element) {
                        "CheckBox" {
                            if ($UiHash.SettingsTabUIElements[$category][$setting]['CheckBox'].Checked) {
                                $NewSettings[$category][$setting] = "true"
                            } else {
                                $NewSettings[$category][$setting] = "false"
                            }
                        }
                        "TextBox" {
                            $NewSettings[$category][$setting] = $UiHash.SettingsTabUIElements[$category][$setting]['TextBox'].Text
                        }
                        "ComboBox" {
                            $NewSettings[$category][$setting] = $UiHash.SettingsTabUIElements[$category][$setting]['ComboBox'].SelectedItem
                        }
                        "IntTextBox" {
                            $NewSettings[$category][$setting] = [int]$UiHash.SettingsTabUIElements[$category][$setting]['IntTextBox'].Text
                        }
                    }
                }
            }
        }
        # Use helper function to convert hashtable to ini format string
        $IniString = Convert-HashtableToIniString -Hashtable $NewSettings
        # Test if the settings file exists and remove it if so
        if (Test-Path -Path $SettingsFilePath) {
            Remove-Item -Path $SettingsFilePath -Force -ErrorAction SilentlyContinue
        }
        # Save the ini string to the settings file
        $IniString | Out-File -FilePath $SettingsFilePath -Encoding UTF8 -Force
        $Result = @{
            Result = $true
            Message = "Settings saved to $SettingsFilePath"
        }
        $Reload = $true
    # If action is to reset settings:
    } elseif ($Reset) {
        # Load default settings definitions
        if (Test-Path -Path "$($UiHash.PSScriptRoot)\Assets\refs\DefaultSettingsDefinition.json") {
            $DefaultSettingsDefinitions = Convert-JsonToHashtable -FilePath "$($UiHash.PSScriptRoot)\Assets\refs\DefaultSettingsDefinition.json"
        } else {
            Throw "DefaultSettingsDefinition.json file not found at path: $($UiHash.PSScriptRoot)\Assets\refs\DefaultSettingsDefinition.json"
        }
        # Validate that default settings definitions were loaded correctly
        if ($DefaultSettingsDefinitions -eq $null -or $DefaultSettingsDefinitions.Count -eq 0) {
            Throw "Default settings definitions are empty or null."
        }
        # Define new settings hashtable
        $NewSettings = @{}
        # Loop over definitions to build hashtable of default settings and update UI elements
        foreach ($category in $DefaultSettingsDefinitions.Settings.Keys) {
            if (-not $NewSettings.ContainsKey($category)) {
                $NewSettings[$category] = @{}
            }
            foreach ($setting in $DefaultSettingsDefinitions.Settings[$category].Keys) {
                $defaultValue = $DefaultSettingsDefinitions.Settings[$category][$setting].Default
                $NewSettings[$category][$setting] = $defaultValue
                # Update UI elements if they exist
                if ($UiHash.SettingsTabUIElements.ContainsKey($category) -and $UiHash.SettingsTabUIElements[$category].ContainsKey($setting)) {
                    $element = $UiHash.SettingsTabUIElements[$category][$setting].Keys | Where-Object { $_ -in @('CheckBox', 'TextBox', 'ComboBox', 'IntTextBox') }
                    switch ($element) {
                        "CheckBox" {
                            if ($defaultValue -eq "true") {
                                $UiHash.SettingsTabUIElements[$category][$setting]['CheckBox'].Checked = $true
                            } else {
                                $UiHash.SettingsTabUIElements[$category][$setting]['CheckBox'].Checked = $false
                            }
                        }
                        "TextBox" {
                            $UiHash.SettingsTabUIElements[$category][$setting]['TextBox'].Text = $defaultValue
                        }
                        "ComboBox" {
                            if ($UiHash.SettingsTabUIElements[$category][$setting]['ComboBox'].Items -contains $defaultValue) {
                                $UiHash.SettingsTabUIElements[$category][$setting]['ComboBox'].SelectedItem = $defaultValue
                            } else {
                                # If default value is not in items, select the first item if available
                                if ($UiHash.SettingsTabUIElements[$category][$setting]['ComboBox'].Items.Count -gt 0) {
                                    $UiHash.SettingsTabUIElements[$category][$setting]['ComboBox'].SelectedIndex = 0
                                }
                            }
                        }
                        "IntTextBox" {
                            $UiHash.SettingsTabUIElements[$category][$setting]['IntTextBox'].Text = $defaultValue
                        }
                    }
                }
            }
        }
        # Use helper function to convert hashtable to ini format string
        $IniString = Convert-HashtableToIniString -Hashtable $NewSettings
        # Test if the settings file exists and remove it if so
        if (Test-Path -Path $SettingsFilePath) {
            Remove-Item -Path $SettingsFilePath -Force -ErrorAction SilentlyContinue
        }
        # Save the ini string to the settings file
        $IniString | Out-File -FilePath $SettingsFilePath -Encoding UTF8 -Force
        $Result = @{
            Result = $true
            Message = "Settings reset to default and saved to $SettingsFilePath"
        }
        $Reload = $true
    }
    # If action is to reload settings:
    # This section will trigger a change of every values in the active script
    if ($Reload) {
        # Read ini file and convert to hashtable
        if (Test-Path -Path $SettingsFilePath) {
            $ActiveSettings = Get-FromIniFile -FilePath $SettingsFilePath
        } else {
            Throw "Settings.ini file not found at path: $($UiHash.PSScriptRoot)\Settings.ini"
        }

        # Advanced Settings
        # Max Counter Tresholds
        $UiHash.ActiveSettingsValues.InternetCheckUpdateCounter = Convert-StringToInt -InputString $ActiveSettings.Advanced.InternetCheckUpdateCounter
        $UiHash.ActiveSettingsValues.MainFormLoadLoopCounter = Convert-StringToInt -InputString $ActiveSettings.Advanced.MainFormLoadLoopCounter
        $UiHash.ActiveSettingsValues.MainLoopRefreshRate = Convert-StringToInt -InputString $ActiveSettings.Advanced.MainLoopRefreshRate
        $UiHash.ActiveSettingsValues.SettingsOpResultCounterThreshold = Convert-StringToInt -InputString $ActiveSettings.Advanced.SettingsOpResultCounterThreshold
        $UiHash.ActiveSettingsValues.ConfigMainLoopRefreshRate = Convert-StringToInt -InputString $ActiveSettings.Advanced.ConfigMainLoopRefreshRate
        # Ui Elements modification
        $UiHash.ActiveSettingsValues.MainUiTimerInterval = Convert-StringToInt -InputString $ActiveSettings.Advanced.MainUiTimerInterval
        
        # Timer interval will be updated by the timer tick event itself when it detects a change
        # This avoids cross-thread operations that cause freezing

        # General Settings
        $UiHash.ActiveSettingsValues.DeleteOnExit = $ActiveSettings.General.DeleteOnExit

        # Configuration Settings
        $UiHash.ActiveSettingsValues.RestartAfterConfig = $ActiveSettings.Configuration.RestartAfterConfig
        $UiHash.ActiveSettingsValues.RunCaffeine = $ActiveSettings.Configuration.RunCaffeine

        # Build result hashtable
        $Result.Result = $true
    }
    # Return the result hashtable
    Return $Result
} Catch {
    # Handle any errors that occur during the process
    Return $Result = @{
        Result = $false
        Message = "Error Occured at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
    }
}