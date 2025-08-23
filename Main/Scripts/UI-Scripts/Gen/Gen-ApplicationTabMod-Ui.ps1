# This script is part of the FPCA project and is used to generate the Mods UI for the Application Tab.
Param (
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

$UiHash.AppTabModUIElements = @{}

# Import Required Assemblies
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Check if there are any mods with Applications data
$hasApplicationMods = $false
foreach ($modtype in $UiHash.AvailableMods.Keys) {
    if ($modtype -eq 'Applications') {
        $hasApplicationMods = $true
        break
    }
}

if (-not $hasApplicationMods) {
    $UiHash.AppTabModUIElements.Default = @{}
    Write-Host "No available mods for Applications, skipping UI generation." -ForegroundColor Yellow
    $NoModsLabel = New-Object System.Windows.Forms.Label
    $NoModsLabel.Text = "No Mods Available..."
    $NoModsLabel.Size = New-Object System.Drawing.Size(70, 60)
    $NoModsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $NoModsLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $NoModsLabel.Location = New-Object System.Drawing.Point(20, 20)
    $NoModsLabel.ForeColor = [System.Drawing.Color]::Black
    $UiHash.AppTabModUIElements.Default['NoModsLabel'] = $NoModsLabel
    return
}

# Define the Y position for the first mod panel
$YPosition = 10

# for each mod that has Applications data, create a panel 
foreach ($mod in $UiHash.AvailableMods.Applications.Keys) {
    # Skip mods that don't have Applications data
    $UiHash.AppTabModUIElements[$mod] = @{}

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

    $UiHash.AppTabModUIElements[$mod]['TitleLabel'] = $TitleLabel

    $YPosition += $finalHeight + 5

    # Create a checkbox for enabling/disabling the mod
    $EnableCheckbox = New-Object System.Windows.Forms.CheckBox
    $EnableCheckbox.Text = "Enable"
    $EnableCheckbox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $EnableCheckbox.Size = New-Object System.Drawing.Size(70, 20)
    $EnableCheckbox.Location = New-Object System.Drawing.Point(13, $YPosition)
    if ($UiHash.EnabledMods -and $UiHash.EnabledMods.ContainsKey($mod)) {
        if ($UiHash.EnabledMods[$mod].ContainsKey('Mod_Data') -and $UiHash.EnabledMods[$mod].Mod_Data.ContainsKey('Applications')) {
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
    $UiHash.AppTabModUIElements[$mod]['EnableCheckbox'] = $EnableCheckbox

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

    $UiHash.AppTabModUIElements[$mod]['VersionLabel'] = $VersionLabel

    $YPosition += $finalHeight + 5

    # Create a Label for the mod's Author
    $AuthorLabel = New-Object System.Windows.Forms.Label
    $AuthorLabel.Text = "Mod Author: $($UiHash['AvailableMods']['All'][$mod]['Information']['Author'])"
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

    $UiHash.AppTabModUIElements[$mod]['AuthorLabel'] = $AuthorLabel

    $YPosition += $finalHeight + 5
}