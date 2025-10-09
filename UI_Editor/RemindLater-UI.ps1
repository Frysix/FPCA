$RESTARTREMINDER_FORM_Load = {
}
$REMINDER_CANCEL_BUTTON_Click = {
}
$Button1_Click = {
}
$REMINDER_MINS_DESC_LABEL_Click = {
}
$TextBox1_TextChanged = {
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'remindlater-ui.designer.ps1')
$RESTARTREMINDER_FORM.ShowDialog()