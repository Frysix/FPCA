# This script generates the UI for the default config tab based on the provided hash table.
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Import the necessary assemblies for Windows Forms and Drawing.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing


# Import the necessary modules for UI generation.
Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\ParsingHelper.psm1" -Force

if (-not (test-path -path "$($Global:UiHash['PSScriptroot'])\Assets\config\Default.config")) {
    ### CODE TO GENERATE DEFAULT CONFIG FILE ###
}

$DisplayData = Get-FromUTF8File -FilePath "$($Global:UiHash['PSScriptroot'])\Assets\config\Default.config"

# Group items by TaskType
$groupedData = @{}
foreach ($section in $DisplayData.Keys) {
    $taskType = $DisplayData[$section]['TaskType']
    if (-not $groupedData.ContainsKey($taskType)) {
        $groupedData[$taskType] = @()
    }
    $groupedData[$taskType] += @{
        Section = $section
        DisplayName = $DisplayData[$section]['DisplayName']
        DefaultState = $DisplayData[$section]['DefaultState']
        ScriptPath = $DisplayData[$section]['ScriptPath']
    }
}

# Sort TaskTypes (Install, Settings, Misc, etc.)
$sortedTaskTypes = $groupedData.Keys | Sort-Object

# Create UI elements
$yPosition = 3
$xPosition = 3

if ($UiHash.ContainsKey('DefaultConfigUiObjects')) {
    $OldUiObjects = $UiHash.DefaultConfigUiObjects
}
$UiHash.DefaultConfigUiObjects = @{}
if (-not $UiHash.ContainsKey('DefaultConfigGroupLabels')) {
    $UiHash.DefaultConfigGroupLabels = @{}
}
if (-not $UiHash.ContainsKey('ConfigCheckBoxStates')) {
    $UiHash.ConfigCheckBoxStates = @{}
}
$UiHash.ConfigCheckBoxChanged = $false

foreach ($taskType in $sortedTaskTypes) {
    # Create a group label for each TaskType
    $groupLabel = New-Object System.Windows.Forms.Label
    $groupLabel.Text = "${taskType}:"
    $groupLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $groupLabel.Location = New-Object System.Drawing.Point($xPosition, $yPosition)
    $groupLabel.Size = New-Object System.Drawing.Size(100, 20)
    $groupLabel.ForeColor = [System.Drawing.Color]::DarkBlue
    
    # Store the group label
    $UiHash.DefaultConfigGroupLabels[$taskType] = $groupLabel
    
    $yPosition += 25
    
    # Create checkboxes for items in this group
    foreach ($item in $groupedData[$taskType]) {
    
        if ($OldUiObjects -and $OldUiObjects.ContainsKey($item.Section)) {
            # Reuse old checkbox if it exists and preserve its state
            $checkbox = $OldUiObjects[$item.Section].CheckBox
            # Keep the current checked state (user's selection)
            $userSelectedState = $checkbox.Checked
        } else {
            # Create a new checkbox
            $checkbox = New-Object System.Windows.Forms.CheckBox
            # For new checkboxes, use the default state
            $userSelectedState = ($item.DefaultState -eq "true")
        }
        
        # Update properties (but preserve the checked state)
        $checkbox.Text = $item.DisplayName
        $checkbox.Location = New-Object System.Drawing.Point(($xPosition + 20), $yPosition)
        $checkbox.Size = New-Object System.Drawing.Size(170, 20)
        $checkbox.Checked = $userSelectedState  # Use preserved state
        $checkbox.Name = "$($item.Section)_CHECKBOX"
        
        # Store the current state
        $Global:UiHash.ConfigCheckBoxStates[$item.Section] = $checkbox.Checked

        # Only add event handler for new checkboxes to avoid duplicate handlers

        $checkbox.Add_CheckedChanged({
            $Global:UiHash.ConfigCheckBoxChanged = $true
        })

        # Update color based on checked state
        if ($checkbox.Checked) {
            $checkbox.ForeColor = [System.Drawing.Color]::Green
        }

        # Store in UiHash for later access
        $UiHash.DefaultConfigUiObjects[$item.Section] = @{
            CheckBox = $checkbox
            TaskType = $taskType
            DisplayName = $item.DisplayName
            ScriptPath = $item.ScriptPath
        }
    
        $yPosition += 20
    }
}
