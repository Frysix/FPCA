$Button1_Click = {
}
$MAIN_FORM_Load = {
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'main-ui.designer.ps1')
$MAIN_FORM.ShowDialog()