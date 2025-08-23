# This script is part of the FPCA project and is used to generate the Mods UI for the Configuration Tab.
Param (
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

$UiHash.ConfigTabModUIElements = @{}

# Import Required Assemblies
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Check if there are any mods with Configuration data
$hasConfigMods = $false
foreach ($modtype in $UiHash.AvailableMods.Keys) {
    if ($modtype -eq 'Configuration') {
        $hasConfigMods = $true
        break
    }
}

# if no mods with Configuration data, create a default label and exit
if (-not $hasConfigMods) {
    $UiHash.ConfigTabModUIElements.Default = @{}
    Write-Host "No available mods for Configuration, skipping UI generation." -ForegroundColor Yellow
    $NoModsLabel = New-Object System.Windows.Forms.Label
    $NoModsLabel.Text = "No Mods Available..."
    $NoModsLabel.Size = New-Object System.Drawing.Size(70, 60)
    $NoModsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $NoModsLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $NoModsLabel.Location = New-Object System.Drawing.Point(20, 20)
    $NoModsLabel.ForeColor = [System.Drawing.Color]::Black
    $UiHash.ConfigTabModUIElements.Default['NoModsLabel'] = $NoModsLabel
    return
}

# Define the Y position for the first mod panel
$YPosition = 10

foreach ($mod in $UiHash.AvailableMods.Configuration.Keys) {
    # Skip mods that don't have Configuration data
    $UiHash.ConfigTabModUIElements[$mod] = @{}

    # Create a Title for the mod
    $TitleLabel = New-Object System.Windows.Forms.Label
    $TitleLabel.Text = "${mod}:"
    $TitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $TitleLabel.ForeColor = [System.Drawing.Color]::Blue

    $TitleLabel.MaximumSize = New-Object System.Drawing.Size(90, 0)
    $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    $textSize = $graphics.MeasureString($TitleLabel.Text, $TitleLabel.Font, 90)
    $calculatedHeight = [Math]::Ceiling($textSize.Height)
    $graphics.Dispose()
    $finalHeight = [Math]::Max(20, $calculatedHeight)

    $TitleLabel.Size = New-Object System.Drawing.Size(90, $finalHeight)
    $TitleLabel.Location = New-Object System.Drawing.Point(10, $YPosition)

    $UiHash.ConfigTabModUIElements[$mod]['TitleLabel'] = $TitleLabel

    $YPosition += $finalHeight + 5

    # Create a checkbox to enable/disable the mod
    $EnableCheckbox = New-Object System.Windows.Forms.CheckBox
    $EnableCheckbox.Text = "Enable"
    $EnableCheckbox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $EnableCheckbox.ForeColor = [System.Drawing.Color]::Black
    $EnableCheckbox.Size = New-Object System.Drawing.Size(70, 20)
    $EnableCheckbox.Location = New-Object System.Drawing.Point(15, $YPosition)
    if ($UiHash.EnabledMods -and $UiHash.EnabledMods.ContainsKey($mod)) {
        if ($UiHash.EnabledMods[$mod].ContainsKey('Mod_Data') -and $UiHash.EnabledMods[$mod].Mod_Data.ContainsKey('Configuration')) {
            $EnableCheckbox.Checked = $true
            $EnableCheckbox.ForeColor = [System.Drawing.Color]::Green
        } else {
            $EnableCheckbox.Checked = $false
            $EnableCheckbox.ForeColor = [System.Drawing.Color]::Black
        }
    } else {
        $EnableCheckbox.Checked = $false
        $EnableCheckbox.ForeColor = [System.Drawing.Color]::Black
    }

    $UiHash.ConfigTabModUIElements[$mod]['EnableCheckbox'] = $EnableCheckbox
    $YPosition += 25

    # Create a Label for the mod's version
    $VersionLabel = New-Object System.Windows.Forms.Label
    $VersionLabel.Text = "Mod Version: $($UiHash['AvailableMods']['All'][$mod]['Information']['ModVersion'])"
    $VersionLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $VersionLabel.ForeColor = [System.Drawing.Color]::DarkGray

    $VersionLabel.MaximumSize = New-Object System.Drawing.Size(80, 0)
    $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    $textSize = $graphics.MeasureString($VersionLabel.Text, $VersionLabel.Font, 80)
    $calculatedHeight = [Math]::Ceiling($textSize.Height)
    $graphics.Dispose()
    $finalHeight = [Math]::Max(20, $calculatedHeight)

    $VersionLabel.Size = New-Object System.Drawing.Size(80, $finalHeight)
    $VersionLabel.Location = New-Object System.Drawing.Point(15, $YPosition)

    $UiHash.ConfigTabModUIElements[$mod]['VersionLabel'] = $VersionLabel

    $YPosition += $finalHeight + 5

    # Create a Label for the mod author
    $AuthorLabel = New-Object System.Windows.Forms.Label
    $AuthorLabel.Text = "Author: $($UiHash['AvailableMods']['All'][$mod]['Information']['Author'])"
    $AuthorLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $AuthorLabel.ForeColor = [System.Drawing.Color]::DarkGray
    $AuthorLabel.MaximumSize = New-Object System.Drawing.Size(80, 0)

    $graphics = [System.Drawing.Graphics]::FromHwnd([System.IntPtr]::Zero)
    $textSize = $graphics.MeasureString($AuthorLabel.Text, $AuthorLabel.Font, 80)
    $calculatedHeight = [Math]::Ceiling($textSize.Height)
    $graphics.Dispose()
    $finalHeight = [Math]::Max(20, $calculatedHeight)
    $AuthorLabel.Size = New-Object System.Drawing.Size(80, $finalHeight)
    $AuthorLabel.Location = New-Object System.Drawing.Point(15, $YPosition)

    $UiHash.ConfigTabModUIElements[$mod]['AuthorLabel'] = $AuthorLabel

    $YPosition += $finalHeight + 10
}