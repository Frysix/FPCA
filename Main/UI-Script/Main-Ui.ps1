$MAIN_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$CHECKBOX_PANNEL = $null
[System.Windows.Forms.Panel]$SIDE_PANNEL = $null
function InitializeComponent
{
$CHECKBOX_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SIDE_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_FORM.SuspendLayout()
#
#CHECKBOX_PANNEL
#
$CHECKBOX_PANNEL.BackColor = [System.Drawing.Color]::Gray
$CHECKBOX_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]115,[System.Int32]12))
$CHECKBOX_PANNEL.Name = [System.String]'CHECKBOX_PANNEL'
$CHECKBOX_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]431,[System.Int32]301))
$CHECKBOX_PANNEL.TabIndex = [System.Int32]0
#
#SIDE_PANNEL
#
$SIDE_PANNEL.BackColor = [System.Drawing.Color]::Gray
$SIDE_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
$SIDE_PANNEL.Name = [System.String]'SIDE_PANNEL'
$SIDE_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]92,[System.Int32]301))
$SIDE_PANNEL.TabIndex = [System.Int32]1
#
#MAIN_FORM
#
$MAIN_FORM.AutoValidate = [System.Windows.Forms.AutoValidate]::EnablePreventFocusChange
$MAIN_FORM.BackColor = [System.Drawing.Color]::LightSlateGray
$MAIN_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]558,[System.Int32]325))
$MAIN_FORM.Controls.Add($SIDE_PANNEL)
$MAIN_FORM.Controls.Add($CHECKBOX_PANNEL)
$MAIN_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$MAIN_FORM.MaximizeBox = $false
$MAIN_FORM.MinimizeBox = $false
$MAIN_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MAIN_FORM.Text = [System.String]'FPCA - (Frysix''s Powershell Configurator App)'
$MAIN_FORM.TopMost = $true
$MAIN_FORM.ResumeLayout($false)
Add-Member -InputObject $MAIN_FORM -Name CHECKBOX_PANNEL -Value $CHECKBOX_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SIDE_PANNEL -Value $SIDE_PANNEL -MemberType NoteProperty
}
. InitializeComponent
