Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'config-ui.designer.ps1')
$Form1.ShowDialog()