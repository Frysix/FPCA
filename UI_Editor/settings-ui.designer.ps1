$SETTINGS_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.TabControl]$SETTINGS_TABCONTROL = $null
[System.Windows.Forms.TabPage]$TabPage1 = $null
[System.Windows.Forms.Button]$CANCEL_SETTINGS_BUTTON = $null
[System.Windows.Forms.Button]$RESET_SETTINGS_BUTTON = $null
[System.Windows.Forms.Button]$SAVE_SETTINGS_BUTTON = $null
function InitializeComponent
{
$SETTINGS_TABCONTROL = (New-Object -TypeName System.Windows.Forms.TabControl)
$TabPage1 = (New-Object -TypeName System.Windows.Forms.TabPage)
$CANCEL_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESET_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$SAVE_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$SETTINGS_TABCONTROL.SuspendLayout()
$SETTINGS_FORM.SuspendLayout()
#
#SETTINGS_TABCONTROL
#
$SETTINGS_TABCONTROL.Controls.Add($TabPage1)
$SETTINGS_TABCONTROL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$SETTINGS_TABCONTROL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]4))
$SETTINGS_TABCONTROL.Multiline = $true
$SETTINGS_TABCONTROL.Name = [System.String]'SETTINGS_TABCONTROL'
$SETTINGS_TABCONTROL.SelectedIndex = [System.Int32]0
$SETTINGS_TABCONTROL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]303,[System.Int32]283))
$SETTINGS_TABCONTROL.TabIndex = [System.Int32]0
#
#TabPage1
#
$TabPage1.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$TabPage1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]22))
$TabPage1.Name = [System.String]'TabPage1'
$TabPage1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]295,[System.Int32]257))
$TabPage1.TabIndex = [System.Int32]0
$TabPage1.Text = [System.String]'TabPage1'
$TabPage1.UseVisualStyleBackColor = $true
#
#CANCEL_SETTINGS_BUTTON
#
$CANCEL_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$CANCEL_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]232,[System.Int32]293))
$CANCEL_SETTINGS_BUTTON.Name = [System.String]'CANCEL_SETTINGS_BUTTON'
$CANCEL_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$CANCEL_SETTINGS_BUTTON.TabIndex = [System.Int32]1
$CANCEL_SETTINGS_BUTTON.Text = [System.String]'Cancel'
$CANCEL_SETTINGS_BUTTON.UseVisualStyleBackColor = $true
$CANCEL_SETTINGS_BUTTON.add_Click($Button1_Click)
#
#RESET_SETTINGS_BUTTON
#
$RESET_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$RESET_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]151,[System.Int32]293))
$RESET_SETTINGS_BUTTON.Name = [System.String]'RESET_SETTINGS_BUTTON'
$RESET_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESET_SETTINGS_BUTTON.TabIndex = [System.Int32]2
$RESET_SETTINGS_BUTTON.Text = [System.String]'Reset'
$RESET_SETTINGS_BUTTON.UseVisualStyleBackColor = $true
#
#SAVE_SETTINGS_BUTTON
#
$SAVE_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$SAVE_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]293))
$SAVE_SETTINGS_BUTTON.Name = [System.String]'SAVE_SETTINGS_BUTTON'
$SAVE_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$SAVE_SETTINGS_BUTTON.TabIndex = [System.Int32]4
$SAVE_SETTINGS_BUTTON.Text = [System.String]'Save'
$SAVE_SETTINGS_BUTTON.UseVisualStyleBackColor = $true
$SAVE_SETTINGS_BUTTON.add_Click($Button3_Click)
#
#SETTINGS_FORM
#
$SETTINGS_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]310,[System.Int32]319))
$SETTINGS_FORM.Controls.Add($SAVE_SETTINGS_BUTTON)
$SETTINGS_FORM.Controls.Add($RESET_SETTINGS_BUTTON)
$SETTINGS_FORM.Controls.Add($CANCEL_SETTINGS_BUTTON)
$SETTINGS_FORM.Controls.Add($SETTINGS_TABCONTROL)
$SETTINGS_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$SETTINGS_FORM.MaximizeBox = $false
$SETTINGS_FORM.Text = [System.String]'Settings - FPCA'
$SETTINGS_FORM.TopMost = $true
$SETTINGS_TABCONTROL.ResumeLayout($false)
$SETTINGS_FORM.ResumeLayout($false)
Add-Member -InputObject $SETTINGS_FORM -Name SETTINGS_TABCONTROL -Value $SETTINGS_TABCONTROL -MemberType NoteProperty
Add-Member -InputObject $SETTINGS_FORM -Name TabPage1 -Value $TabPage1 -MemberType NoteProperty
Add-Member -InputObject $SETTINGS_FORM -Name CANCEL_SETTINGS_BUTTON -Value $CANCEL_SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $SETTINGS_FORM -Name RESET_SETTINGS_BUTTON -Value $RESET_SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $SETTINGS_FORM -Name SAVE_SETTINGS_BUTTON -Value $SAVE_SETTINGS_BUTTON -MemberType NoteProperty
}
. InitializeComponent
