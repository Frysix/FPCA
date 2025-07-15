param (
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Ensure the assembly for Windows Forms is loaded
Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
[System.Windows.Forms.Application]::EnableVisualStyles()


if (-not $UiHash.ContainsKey('ActiveTasks')) {
    Throw "UiHash must contain 'ActiveTasks' key with a hashtable of tasks."
}

$TaskList = @()

foreach ($activetask in $UiHash.ActiveTasks.Keys) {
    $TaskList += $activetask
}


# Base positions
$yPosition = 10
$ypPosition = 35
$UiHash.TaskControls = @{}

foreach ($task in $TaskList) {
    # Title label
    $TaskNameLabel = New-Object System.Windows.Forms.Label
    $TaskNameLabel.Text = $TaskNameLabel.Text = $UiHash.ActiveTasks[$task].TaskDefinition.DisplayName
    $TaskNameLabel.Location = New-Object System.Drawing.Point(10, $yPosition)
    $TaskNameLabel.Size = New-Object System.Drawing.Size(350, 20)
    $TaskNameLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $TaskNameLabel.ForeColor = [System.Drawing.Color]::Black
    $TaskNameLabel.AutoSize = $false
    $TaskNameLabel.Location = New-Object System.Drawing.Point(10, $yPosition)

    # Progress bar
    $ProgressBar = New-Object System.Windows.Forms.ProgressBar
    $ProgressBar.Minimum = 0
    $ProgressBar.Maximum = 100
    $ProgressBar.Value = 0
    $ProgressBar.Size = New-Object System.Drawing.Size(200, 20)
    $ProgressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
    $ProgressBar.ForeColor = [System.Drawing.Color]::Green
    $ProgressBar.MarqueeAnimationSpeed = 0
    $ProgressBar.Visible = $true
    $ProgressBar.AutoSize = $false
    $ProgressBar.Location = New-Object System.Drawing.Point(10, $ypPosition)


    # Status label
    $StatusLabel = New-Object System.Windows.Forms.Label
    $StatusLabel.Text = "Initializing..."
    $StatusLabel.Size = New-Object System.Drawing.Size(100, 20)
    $StatusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $StatusLabel.ForeColor = [System.Drawing.Color]::Gray
    $StatusLabel.AutoSize = $false
    $StatusLabel.Location = New-Object System.Drawing.Point(220, $ypPosition)

    # Store controls in UiHash
    $UiHash.TaskControls[$task] = @{
        TaskNameLabel = $TaskNameLabel
        ProgressBar   = $ProgressBar
        StatusLabel   = $StatusLabel
    }

    # Increment yPosition for next task
    $yPosition += 60
    $ypPosition += 60
}