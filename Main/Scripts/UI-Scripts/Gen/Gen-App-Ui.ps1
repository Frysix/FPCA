# This script generates the UI for the application based on the provided hash table.
Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$UiHash
)

# Import the necessary assemblies for Windows Forms and Drawing.
Add-Type -AssemblyName System.Windows.Forms, System.Drawing


# Import the necessary modules for UI generation.
Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\ParsingHelper.psm1" -Force

# Create a new hashtable to store the UI elements.
$DlInfo = @{}
# Initialize the NewAppUiObjects hashtable in the UiHash.
$Global:UiHash.NewAppUiObjects = @{}

# Get the list of .dlinfo files from the specified directory.
$dlinfoFiles = Get-ChildItem -Path "$($Global:UiHash['PSScriptroot'])\Apps-Data\DownloadInfo\" -Filter "*.dlinfo" -File


foreach ($file in $dlinfoFiles) {
    $ini = Get-FromUTF8File -FilePath $file.FullName
    # Loop through each section in the ini file.
    # For each section, extract the links and other properties.
    foreach ($section in $ini.Keys) {
        $links = @()
        $i = 1
        while ($true) {
            $linkKey = "Link$i"
            if ($ini[$section].ContainsKey($linkKey) -and $ini[$section][$linkKey]) {
                $links += $ini[$section][$linkKey]
                $i++
            } else {
                break
            }
        }
        # Create a new entry in the NewAppUiObjects hashtable for each section.
        $DlInfo[$section] = @{
            Links = $links
            ZipName = $ini[$section]['ZipName']
            Folder  = $ini[$section]['Folder']
            Executable = $ini[$section]['Executable']
            Type = $ini[$section]['Type']
            Category = $ini[$section]['Category']
        }
    }
}
if ($Global:UiHash.UseCustomApp) {
    $CustomDlInfo = @{}
    $CustomDlinfoFiles = Get-ChildItem -Path "$($Global:UiHash['PSScriptroot'])\Apps-Data\DownloadInfo\Custom\" -Filter "*.dlinfo" -File
    foreach ($file in $CustomDlinfoFiles) {
        $ini = Get-FromUTF8File -FilePath $file.FullName
        # Loop through each section in the ini file.
        # For each section, extract the links and other properties.
        foreach ($section in $ini.Keys) {
            $links = @()
            $i = 1
            while ($true) {
                $linkKey = "Link$i"
                if ($ini[$section].ContainsKey($linkKey) -and $ini[$section][$linkKey]) {
                    $links += $ini[$section][$linkKey]
                    $i++
                } else {
                    break
                }
            }
            # Create a new entry in the NewAppUiObjects hashtable for each section.
            $CustomDlInfo[$section] = @{
                Links = $links
                ZipName = $ini[$section]['ZipName']
                Folder  = $ini[$section]['Folder']
                Executable = $ini[$section]['Executable']
                Type = $ini[$section]['Type']
                Category = $ini[$section]['Category']
            }
        }
    }
    # Merge the custom download info into the main download info.
    foreach ($section in $CustomDlInfo.Keys) {
        if (-not $DlInfo.ContainsKey($section)) {
            $DlInfo[$section] = $CustomDlInfo[$section]
        } else {
            # If the section already exists, append the links.
            $DlInfo[$section].Links += $CustomDlInfo[$section].Links
        }
    }
}


$Global:UiHash.yl = 4  # Starting Y position for label
$Global:UiHash.yp = 25  # Y position for progress bar

foreach ($section in $DlInfo.Keys) {
    # Create UI elements
    $Global:UiHash.NewAppUiObjects[$section] = @{}

    $Global:UiHash.NewAppUiObjects[$section].label = New-Object System.Windows.Forms.Label
    $Global:UiHash.NewAppUiObjects[$section]['label'].Text = $section
    $Global:UiHash.NewAppUiObjects[$section]['label'].Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
    $Global:UiHash.NewAppUiObjects[$section]['label'].ForeColor = [System.Drawing.Color]::Black
    $Global:UiHash.NewAppUiObjects[$section]['label'].Size = New-Object System.Drawing.Size(250, 16)
    $Global:UiHash.NewAppUiObjects[$section]['label'].BackColor = [System.Drawing.Color]::Transparent
    $Global:UiHash.NewAppUiObjects[$section]['label'].AutoSize = $true
    $Global:UiHash.NewAppUiObjects[$section]['label'].Name = "lbl$section"
    $Global:UiHash.NewAppUiObjects[$section]['label'].Location = New-Object System.Drawing.Point(3, $Global:UiHash.yl)
    
    $Global:UiHash.NewAppUiObjects[$section].progressBar = New-Object System.Windows.Forms.ProgressBar
    $Global:UiHash.NewAppUiObjects[$section]['progressBar'].Style = 'Continuous'
    $Global:UiHash.NewAppUiObjects[$section]['progressBar'].Minimum = 0
    $Global:UiHash.NewAppUiObjects[$section]['progressBar'].Maximum = 100
    $Global:UiHash.NewAppUiObjects[$section]['progressBar'].Value = 0
    $Global:UiHash.NewAppUiObjects[$section]['progressBar'].Size = New-Object System.Drawing.Size(220, 23)
    $Global:UiHash.NewAppUiObjects[$section]['progressBar'].Name = "prg$section"
    $Global:UiHash.NewAppUiObjects[$section]['progressBar'].Location = New-Object System.Drawing.Point(79, $Global:UiHash.yp)

    $Global:UiHash.NewAppUiObjects[$section].button = New-Object System.Windows.Forms.Button
    $Global:UiHash.NewAppUiObjects[$section]['button'].Text = 'Download'
    $Global:UiHash.NewAppUiObjects[$section]['button'].Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
    $Global:UiHash.NewAppUiObjects[$section]['button'].ForeColor = [System.Drawing.Color]::Black
    $Global:UiHash.NewAppUiObjects[$section]['button'].BackColor = [System.Drawing.Color]::LightGray
    $Global:UiHash.NewAppUiObjects[$section]['button'].AutoSize = $false
    $Global:UiHash.NewAppUiObjects[$section]['button'].Enabled = $true
    $Global:UiHash.NewAppUiObjects[$section]['button'].FlatStyle = 'Popup'
    $Global:UiHash.NewAppUiObjects[$section]['button'].Size = New-Object System.Drawing.Size(70, 23)
    $Global:UiHash.NewAppUiObjects[$section]['button'].Name = "btnDownload$section"
    $Global:UiHash.NewAppUiObjects[$section]['button'].Location = New-Object System.Drawing.Point(3, $Global:UiHash.yp)

    # Do math to position the next set of controls
    $Global:UiHash.yl = $Global:UiHash.yl + 50
    $Global:UiHash.yp = $Global:UiHash.yp + 50
}

$Global:UiHash.DLinfo = $DlInfo

Return $Global:UiHash