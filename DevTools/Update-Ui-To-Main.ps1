
# Get the parent folder of the script
$ParentFolder = Split-Path -Parent $PSScriptRoot

# Set paths
$UiScriptPath = "$ParentFolder\Main\Scripts\Ui-Scripts"
$UiEditorPath = "$ParentFolder\UI_Editor"
$UpdaterScriptPath = "$ParentFolder\Updater"


if (test-path -path "$UiScriptPath\Main-Ui.ps1") {
    Remove-Item -Path "$UiScriptPath\Main-Ui.ps1" -Force -ErrorAction SilentlyContinue
}
if (test-path -path "$UiScriptPath\Config-Ui.ps1") {
    Remove-Item -Path "$UiScriptPath\Config-Ui.ps1" -Force -ErrorAction SilentlyContinue
}
if (test-path -path "$UpdaterScriptPath\Updater-Ui.ps1") {
    Remove-Item -Path "$UpdaterScriptPath\Updater-Ui.ps1" -Force -ErrorAction SilentlyContinue
}
if (test-path -path "$UiScriptPath\RemindLater-Ui.ps1") {
    Remove-Item -Path "$UiScriptPath\RemindLater-Ui.ps1" -Force -ErrorAction SilentlyContinue
}
if (test-path -path "$UiScriptPath\RestartOptions-Ui.ps1") {
    Remove-Item -Path "$UiScriptPath\RestartOptions-Ui.ps1" -Force -ErrorAction SilentlyContinue
}

# Copy the Main-Ui.ps1 file from UI_Editor to Ui-Script
Copy-Item -Path "$UiEditorPath\main-ui.designer.ps1" -Destination "$UiScriptPath\Main-Ui.ps1" -Force
Copy-Item -Path "$UiEditorPath\config-ui.designer.ps1" -Destination "$UiScriptPath\Config-Ui.ps1" -Force
Copy-Item -Path "$UiEditorPath\updater-ui.designer.ps1" -Destination "$UpdaterScriptPath\Updater-Ui.ps1" -Force
Copy-Item -Path "$UiEditorPath\remindlater-ui.designer.ps1" -Destination "$UiScriptPath\RemindLater-Ui.ps1" -Force
Copy-Item -Path "$UiEditorPath\restartoptions-ui.designer.ps1" -Destination "$UiScriptPath\RestartOptions-Ui.ps1" -Force