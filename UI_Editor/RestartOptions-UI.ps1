Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'restartoptions-ui.designer.ps1.ps1')
$RESTARTOPTIONS_FORM.ShowDialog()