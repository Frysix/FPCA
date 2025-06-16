Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'apps-ui.designer.ps1')
$Form1.ShowDialog()