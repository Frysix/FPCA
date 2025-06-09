$PC_BOARD_MODEL_LABEL_Click = {
}
$Label2_Click = {
}
$CPU_LABEL_Click = {
}
$Label1_Click = {
}
$Button1_Click = {
}
$MAIN_FORM_Load = {
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'main-ui.designer.ps1')
$MAIN_FORM.ShowDialog()