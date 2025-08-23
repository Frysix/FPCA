# This script serves to generate the UI for the application tab in FPCA.
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Safety checks
if (-not $UiHash) {
    Write-Host "Error: UiHash parameter is required" -ForegroundColor Red
    return
}

# Add Windows Forms assembly if not already loaded
try {
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
} catch {
    Write-Host "Error loading Windows Forms assemblies: $($_.Exception.Message)" -ForegroundColor Red
    return
}

$UiHash.AppTabDefinitionElements = @{}

# Iterate through enabled mods and populate the AppTabDefinitionElements hashtable
if ($null -ne $UiHash.EnabledMods) {
    foreach ($mod in $UiHash.EnabledMods.Keys) {
        if ($UiHash.EnabledMods[$mod].ContainsKey('Mod_Data') -and $UiHash.EnabledMods[$mod].Mod_Data.ContainsKey("Applications")) {
            foreach ($category in $UiHash.EnabledMods[$mod].Mod_Data.Applications.Keys) {
                if (-not ($UiHash.AppTabDefinitionElements.ContainsKey($category))) {
                    $UiHash.AppTabDefinitionElements[$category] = @{}
                }
                foreach ($app in $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category].Keys) {
                    $UiHash.AppTabDefinitionElements[$category][$app] = @{
                        DisplayName = $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category][$app].DisplayName
                        Description = $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category][$app].Description
                        Author = $UiHash.EnabledMods[$mod].Information.Author
                        AvailableTypes = @{}
                    }
                    $appType = $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category][$app].AppType
                    # Handle both string and array AppType values
                    if (($appType -is [array] -and $appType -contains "Portable") -or ($appType -eq "Portable")) {
                        $exepath = Join-Path $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category][$app].Files.Portable.Folder $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category][$app].Files.Portable.Executable
                        if (Test-Path -Path $exepath) {
                            $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Portable = $true
                        } else {
                            $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Portable = $false
                        }
                    }
                    if (($appType -is [array] -and $appType -contains "Installer") -or ($appType -eq "Installer")) {
                        $exepath = Join-Path $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category][$app].Files.Installer.Folder $UiHash.EnabledMods[$mod].Mod_Data.Applications[$category][$app].Files.Installer.Executable
                        if (Test-Path -Path $exepath) {
                            $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Installer = $true
                        } else {
                            $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Installer = $false
                        }
                    }
                }
            }
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

# Add Default App Definition to the AppTabDefinitionElements hashtable
$DefaultAppDefinition = Convert-JsonToHashtable -FilePath "$($UiHash['PSScriptroot'])\Assets\refs\DefaultAppsDefinition.json"

# Merge DefaultAppDefinition into AppTabDefinitionElements
foreach ($category in $DefaultAppDefinition.Applications.Keys) {
    if (-not ($UiHash.AppTabDefinitionElements.ContainsKey($category))) {
        $UiHash.AppTabDefinitionElements[$category] = @{}
    }
    foreach ($app in $DefaultAppDefinition.Applications[$category].Keys) {
        $UiHash.AppTabDefinitionElements[$category][$app] = @{
            DisplayName = $DefaultAppDefinition.Applications[$category][$app].DisplayName
            Description = $DefaultAppDefinition.Applications[$category][$app].Description
            Author = $DefaultAppDefinition.Information.Author
            AvailableTypes = @{}
        }
        if ($DefaultAppDefinition.Applications[$category][$app].AppType -eq "Portable") {
            $exepath = Join-Path $DefaultAppDefinition.Applications[$category][$app].Files.Portable.Folder $DefaultAppDefinition.Applications[$category][$app].Files.Portable.Executable
            if (Test-Path -Path $exepath) {
                $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Portable = $true
            } else {
                $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Portable = $false
            }
        }
        if ($DefaultAppDefinition.Applications[$category][$app].AppType -eq "Installer") {
            $exepath = Join-Path $DefaultAppDefinition.Applications[$category][$app].Files.Installer.Folder $DefaultAppDefinition.Applications[$category][$app].Files.Installer.Executable
            if (Test-Path -Path $exepath) {
                $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Installer = $true
            } else {
                $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.Installer = $false
            }
        }
    }
}



# Initialize AppTabUIElements
$UiHash.AppTabUIElements = @{
    Buttons = @{}
    Labels = @{}
    ProgressBars = @{}
}

$Row1XPoint = 5
$Row2XPoint = 225
$Row1YPoint = 5
$Row2YPoint = 5
$Row1 = $true

foreach ($category in $UiHash.AppTabDefinitionElements.Keys) {
    # Debug
    Write-Host "Processing category: $category" -ForegroundColor Cyan
    # Create a label for the category
    $CategoryLabel = New-Object System.Windows.Forms.Label
    $CategoryLabel.Text = "$($category):"
    $CategoryLabel.Font = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
    $CategoryLabel.ForeColor = [System.Drawing.Color]::Blue
    $CategoryLabel.Size = New-Object System.Drawing.Size(220, 30)
    if ($Row1) {
        $CategoryLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
        $Row1XPoint += 10
    } else {
        $CategoryLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
        $Row2XPoint += 10
    }
    # Add the category label to the AppTabUIElements
    $UiHash.AppTabUIElements.Labels["$($category)_Label"] = $CategoryLabel
    Write-Host "$($category)_Label created with text: $($CategoryLabel.Text)" -ForegroundColor Green
    # Loop through each app in the category
    foreach ($app in $UiHash.AppTabDefinitionElements[$category].Keys) {
        # Create a label for each title
        Write-Host "Processing app: $app" -ForegroundColor Cyan
        $AppTitleLabel = New-Object System.Windows.Forms.Label
        $AppTitleLabel.Text = "$($UiHash.AppTabDefinitionElements[$category][$app].DisplayName):"
        $AppTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $AppTitleLabel.ForeColor = [System.Drawing.Color]::Black
        $AppTitleLabel.MaximumSize = New-Object System.Drawing.Size(180, 0)
        $AppTitleLabel.AutoSize = $true
        
        # Calculate the actual height needed for the text
        $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
        $textSize = $graphics.MeasureString($AppTitleLabel.Text, $AppTitleLabel.Font, 180)
        $calculatedHeight = [Math]::Ceiling($textSize.Height)
        $graphics.Dispose()

        $AppTitleHeight = [Math]::Max(20, $calculatedHeight)
        $AppTitleLabel.Size = New-Object System.Drawing.Size(180, $AppTitleHeight)

        # Create a label for the author
        $AppAuthorLabel = New-Object System.Windows.Forms.Label
        $AppAuthorLabel.Text = "Author: $($UiHash.AppTabDefinitionElements[$category][$app].Author)"
        $AppAuthorLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
        $AppAuthorLabel.ForeColor = [System.Drawing.Color]::DimGray
        $AppAuthorLabel.Size = New-Object System.Drawing.Size(180, 20)
        # Create a label for each description
        $AppDescriptionLabel = New-Object System.Windows.Forms.Label
        $AppDescriptionLabel.Text = $UiHash.AppTabDefinitionElements[$category][$app].Description
        $AppDescriptionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
        $AppDescriptionLabel.ForeColor = [System.Drawing.Color]::Gray
        $AppDescriptionLabel.MaximumSize = New-Object System.Drawing.Size(180, 0)  
        $AppDescriptionLabel.AutoSize = $true
        
        # Calculate the actual height needed for the text
        $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
        $textSize = $graphics.MeasureString($AppDescriptionLabel.Text, $AppDescriptionLabel.Font, 180)
        $calculatedHeight = [Math]::Ceiling($textSize.Height)
        $graphics.Dispose()
        
        # Ensure minimum height of 20px and apply the calculated height
        $finalHeight = [Math]::Max(20, $calculatedHeight)
        $AppDescriptionLabel.Size = New-Object System.Drawing.Size(180, $finalHeight)

        if ($Row1) {
            $Row1YPoint += 40
            $AppTitleLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
            $Row1YPoint += $AppTitleHeight + 10
            $AppAuthorLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
            $Row1XPoint += 10
            $Row1YPoint += 20
            $AppDescriptionLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
            $Row1YPoint += $finalHeight + 10  
            $Row1XPoint -= 5
        } else {
            $Row2YPoint += 40
            $AppTitleLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
            $Row2YPoint += $AppTitleHeight + 10
            $AppAuthorLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
            $Row2XPoint += 10
            $Row2YPoint += 20
            $AppDescriptionLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
            $Row2YPoint += $finalHeight + 10
            $Row2XPoint -= 5
        }
        # Add the app title and description labels to the AppTabUIElements
        $UiHash.AppTabUIElements.Labels["$($app)_TitleLabel"] = $AppTitleLabel
        $UiHash.AppTabUIElements.Labels["$($app)_AuthorLabel"] = $AppAuthorLabel
        $UiHash.AppTabUIElements.Labels["$($app)_DescriptionLabel"] = $AppDescriptionLabel
        if ($Row1) {
            Write-Host "$($app)_TitleLabel, $($app)_AuthorLabel, and $($app)_DescriptionLabel created on Row 1" -ForegroundColor Green
        } else {
            Write-Host "$($app)_TitleLabel, $($app)_AuthorLabel, and $($app)_DescriptionLabel created on Row 2" -ForegroundColor Green
        }

        # Loop through available types for the app
        foreach ($type in $UiHash.AppTabDefinitionElements[$category][$app].AvailableTypes.GetEnumerator()) {
            # Debug
            Write-Host "Processing type: $($type.Name) for app: $app"
            $TypeTitleLabel = New-Object System.Windows.Forms.Label
            $TypeTitleLabel.Text = "Type: $($type.Name)"
            $TypeTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
            $TypeTitleLabel.ForeColor = [System.Drawing.Color]::Black
            $TypeTitleLabel.Size = New-Object System.Drawing.Size(100, 20)
            if ($type.Value -eq $true) {
                # Since the app is installed, create a button to launch it and type title label
                $LaunchButton = New-Object System.Windows.Forms.Button
                $LaunchButton.Text = "Start"
                $LaunchButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
                $LaunchButton.Size = New-Object System.Drawing.Size(50, 25)
                $LaunchButton.BackColor = [System.Drawing.Color]::Silver
                $LaunchButton.ForeColor = [System.Drawing.Color]::Black
                $LaunchButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
                if ($Row1) {
                    $TypeTitleLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                    $Row1YPoint += 30
                    $LaunchButton.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                    $Row1YPoint += 35
                    Write-Host "Launch button for $app created on Row 1" -ForegroundColor Green
                } else {
                    $TypeTitleLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                    $Row2YPoint += 30
                    $LaunchButton.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                    $Row2YPoint += 35
                    Write-Host "Launch button for $app created on Row 2" -ForegroundColor Green
                }
                # Add the type title label and launch button to the AppTabUIElements
                $UiHash.AppTabUIElements.Buttons["$($type.Name)_$($app)_LaunchButton"] = $LaunchButton
            } else {
                # Since the app is not installed, create a button and a progressbar to install it
                $InstallButton = New-Object System.Windows.Forms.Button
                $InstallButton.Text = "Install"
                $InstallButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
                $InstallButton.Size = New-Object System.Drawing.Size(50, 25)
                $InstallButton.BackColor = [System.Drawing.Color]::Silver
                $InstallButton.ForeColor = [System.Drawing.Color]::Black
                $InstallButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
                $ProgressBar = New-Object System.Windows.Forms.ProgressBar
                $ProgressBar.Size = New-Object System.Drawing.Size(180, 20)
                $ProgressBar.Style = 'Continuous'
                $ProgressBar.BackColor = [System.Drawing.Color]::LightGray
                if ($Row1) {
                    $TypeTitleLabel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                    $Row1YPoint += 30
                    $InstallButton.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                    $Row1YPoint += 35
                    $ProgressBar.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
                    $Row1YPoint += 30
                    Write-Host "Install button and progressbar for $app created on Row 1" -ForegroundColor Green
                } else {
                    $TypeTitleLabel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                    $Row2YPoint += 30
                    $InstallButton.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                    $Row2YPoint += 35
                    $ProgressBar.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
                    $Row2YPoint += 30
                    Write-Host "Install button and progressbar for $app created on Row 2" -ForegroundColor Green
                }
                # Add the install button, and progress bar to the AppTabUIElements
                $UiHash.AppTabUIElements.Buttons["$($type.Name)_$($app)_InstallButton"] = $InstallButton
                $UiHash.AppTabUIElements.ProgressBars["$($type.Name)_$($app)_ProgressBar"] = $ProgressBar
            }
            $UiHash.AppTabUIElements.Labels["$($type.Name)_$($app)_TypeLabel"] = $TypeTitleLabel
            Write-Host "$($type.Name)_$($app)_TypeLabel created with text: $($TypeTitleLabel.Text)" -ForegroundColor Green
        }
        if ($Row1) {
            $Row1XPoint -= 5
        } else {
            $Row2XPoint -= 5
        }
    }
    # Increment the Y position for the next category
    if ($Row1) {
        $Row1YPoint += 20
        $Row1XPoint -= 10
        Write-Host "Moving to Row 2" -ForegroundColor Yellow
    } else {
        $Row2YPoint += 20
        $Row2XPoint -= 10
        Write-Host "Moving to Row 1" -ForegroundColor Yellow
    }
    # Check if we need to switch rows based on Y points
    if ($Row1YPoint -gt $Row2YPoint) {
        $Row1 = $false
    } else {
        $Row1 = $true
    }
}