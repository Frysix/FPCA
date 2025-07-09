Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'config-ui.designer.ps1')
$TASK_FORM.ShowDialog()