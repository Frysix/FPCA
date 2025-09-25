$TASK_FORM_Load = {
}
$MAIN_TASKACTIVECOUNT_LABEL_Click = {
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'config-ui.designer.ps1')
$TASK_FORM.ShowDialog()