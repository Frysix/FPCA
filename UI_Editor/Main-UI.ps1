$CUSTOMCONFIG_CONTROL_PANEL_Paint = {
}
$CONFIG_START_BUTTON_Click = {
}
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX_CheckedChanged = {
}
$REFRESH_APP_BUTTON_Click = {
}
$USECUSTOM_APP_CHECKBOX_CheckedChanged = {
}
$VERSION_LABEL_Click = {
}
$STOFFICE_LAUNCH_CHECKBOX_CheckedChanged = {
}
$CheckBox2_CheckedChanged = {
}
$FIREFOX_INSTALL_CHECKBOX_CheckedChanged = {
}
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