$Label1_Click = {
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'updater-ui.designer.ps1')
$UPDATER_MAIN_FORM.ShowDialog()