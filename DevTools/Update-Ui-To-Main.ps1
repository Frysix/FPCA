
# Get the parent folder of the script
$ParentFolder = Split-Path -Parent $PSScriptRoot

# Set paths
$UiScriptPath = "$ParentFolder\Main\Ui-Script"
$UiEditorPath = "$ParentFolder\UI_Editor"


if (test-path -path "$UiScriptPath\Main-Ui.ps1") {
    Remove-Item -Path "$UiScriptPath\Main-Ui.ps1" -Force -ErrorAction SilentlyContinue
}

# Copy the Main-Ui.ps1 file from UI_Editor to Ui-Script
Copy-Item -Path "$UiEditorPath\main-ui.designer.ps1" -Destination "$UiScriptPath\main-ui.designer.ps1" -Force

# Wait for a moment to ensure the file is copied
start-sleep -Seconds 1

# Rename the copied file to Main-Ui.ps1
Rename-Item -Path "$UiScriptPath\main-ui.designer.ps1" -NewName "Main-Ui.ps1" -Force