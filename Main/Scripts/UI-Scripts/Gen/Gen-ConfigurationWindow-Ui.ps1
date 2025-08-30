# Generation Script for Configuration Window UI
# This script sets up the UI elements for displaying active tasks and their progress in the configuration window
Param(
    [parameter(Mandatory=$true)]
    [hashtable]$UiHash,
    [Parameter(Mandatory=$true,ParameterSetName="Generate")]
    [switch]$Generate,
    [Parameter(Mandatory=$true,ParameterSetName="Refresh")]
    [switch]$Refresh,
    [Parameter(Mandatory=$true,ParameterSetName="Check")]
    [switch]$Check
)

Try {
    # Ensure the assembly for Windows Forms is loaded
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
    [System.Windows.Forms.Application]::EnableVisualStyles()
    # Check for ActiveTasks key
    if (-not $UiHash.ContainsKey('ActiveTasks')) {
        Throw "UiHash must contain 'ActiveTasks' key with a hashtable of tasks."
    }
    # Generate or Refresh the Task List
    $TaskList = @()
    foreach ($activetask in $UiHash.ActiveTasks.Keys) {
        $TaskList += $activetask
    }
    # Base positions
    $Row1XPoint = 10
    $Row2XPoint = 430
    $Row1YPoint = 10
    $Row2YPoint = 10
    $UiHash.TaskControls = @{}
    $Row1 = $true
    foreach ($task in $TaskList) {
        # Panel for each task
        $TaskPanel = New-Object System.Windows.Forms.Panel
        $TaskPanel.Size = New-Object System.Drawing.Size(400, 130)
        $TaskPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
        $TaskPanel.BackColor = [System.Drawing.Color]::Silver
        $TaskPanel.AutoScroll = $true
        # Title Label
        $TaskNameLabel = New-Object System.Windows.Forms.Label
        $TaskNameLabel.Text = $UiHash.ActiveTasks[$task].TaskDefinition.DisplayName
        $TaskNameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
        $TaskNameLabel.ForeColor = [System.Drawing.Color]::Black
        $TaskNameLabel.MaximumSize = New-Object System.Drawing.Size(365, 0)
        $TaskNameLabel.AutoSize = $true
        # Get text size to adjust height
        $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
        $textSize = $graphics.MeasureString($TaskNameLabel.Text, $TaskNameLabel.Font, 365)
        $calculatedHeight = [Math]::Ceiling($textSize.Height)
        $graphics.Dispose()
        $TaskNameLabel_finalHeight = [Math]::Max(20, $calculatedHeight)
        $TaskNameLabel.Size = New-Object System.Drawing.Size(365, $TaskNameLabel_finalHeight)
        $TaskNameLabel.Location = New-Object System.Drawing.Point(5, 10)
        # Progress Bar
        $ProgressBar = New-Object System.Windows.Forms.ProgressBar
        $ProgressBar.Minimum = 0
        $ProgressBar.Maximum = 100
        $ProgressBar.Value = 0
        $ProgressBar.Size = New-Object System.Drawing.Size(365, 30)
        $ProgressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
        $ProgressBar.ForeColor = [System.Drawing.Color]::Green
        $ProgressBar.MarqueeAnimationSpeed = 0
        $ProgressBar.Visible = $true
        $PBarPoint = $TaskNameLabel_finalHeight + 15
        $ProgressBar.Location = New-Object System.Drawing.Point(15, $PBarPoint)
        # Status Label (Comment Label)
        $StatusLabel = New-Object System.Windows.Forms.Label
        $StatusLabel.Text = "Initializing..."
        $StatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
        $StatusLabel.ForeColor = [System.Drawing.Color]::Gray
        $StatusLabel.MaximumSize = New-Object System.Drawing.Size(365, 0)
        $StatusLabel.AutoSize = $true
        $StatLabPoint = $PBarPoint + 35
        $StatusLabel.Location = New-Object System.Drawing.Point(20, $StatLabPoint)
        # Positioning
        if ($Row1) {
            $TaskPanel.Location = New-Object System.Drawing.Point($Row1XPoint, $Row1YPoint)
            $Row1YPoint += $TaskPanel.Height + 10
        } elseif (-not $Row1) {
            $TaskPanel.Location = New-Object System.Drawing.Point($Row2XPoint, $Row2YPoint)
            $Row2YPoint += $TaskPanel.Height + 10
        }
        # Add controls to panel
        $TaskPanel.Controls.Add($TaskNameLabel)
        $TaskPanel.Controls.Add($ProgressBar)
        $TaskPanel.Controls.Add($StatusLabel)
        # Store controls in UiHash
        $UiHash.TaskControls[$task] = @{
            TaskNameLabel = $TaskNameLabel
            ProgressBar   = $ProgressBar
            StatusLabel   = $StatusLabel
            TaskPanel     = $TaskPanel
        }
        # Switch depending on height
        if ($Row1YPoint -gt $Row2YPoint) {
            $Row1 = $false
        } else {
            $Row1 = $true
        }
    }

} Catch {
    Write-Host "Error generating configuration window UI: $($_.Exception.Message)" -ForegroundColor Red
}