$Button3_Click = {
}
$Button1_Click = {
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'settings-ui.designer.ps1')
$SETTINGS_FORM.ShowDialog()