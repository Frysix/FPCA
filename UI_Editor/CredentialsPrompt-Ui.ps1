Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'credentialsprompt-ui.designer.ps1')
$CREDSPROMPT_FORM.ShowDialog()