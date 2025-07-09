$SETTINGS_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.TabControl]$SETTINGS_TABCONTROL = $null
[System.Windows.Forms.Button]$BACK_SETTINGS_BUTTON = $null
[System.Windows.Forms.Button]$RESET_SETTINGS_BUTTON = $null
[System.Windows.Forms.Button]$SAVE_SETTINGS_BUTTON = $null
function InitializeComponent
{
$SETTINGS_TABCONTROL = (New-Object -TypeName System.Windows.Forms.TabControl)
$BACK_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESET_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$SAVE_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$SETTINGS_FORM.SuspendLayout()
#
#SETTINGS_TABCONTROL
#
$SETTINGS_TABCONTROL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$SETTINGS_TABCONTROL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]4))
$SETTINGS_TABCONTROL.Multiline = $true
$SETTINGS_TABCONTROL.Name = [System.String]'SETTINGS_TABCONTROL'
$SETTINGS_TABCONTROL.SelectedIndex = [System.Int32]0
$SETTINGS_TABCONTROL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]389,[System.Int32]283))
$SETTINGS_TABCONTROL.TabIndex = [System.Int32]0
#
#BACK_SETTINGS_BUTTON
#
$BACK_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$BACK_SETTINGS_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$BACK_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]318,[System.Int32]293))
$BACK_SETTINGS_BUTTON.Name = [System.String]'BACK_SETTINGS_BUTTON'
$BACK_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$BACK_SETTINGS_BUTTON.TabIndex = [System.Int32]1
$BACK_SETTINGS_BUTTON.Text = [System.String]'Back'
$BACK_SETTINGS_BUTTON.UseVisualStyleBackColor = $true
$BACK_SETTINGS_BUTTON.add_Click($Button1_Click)
#
#RESET_SETTINGS_BUTTON
#
$RESET_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$RESET_SETTINGS_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$RESET_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]237,[System.Int32]293))
$RESET_SETTINGS_BUTTON.Name = [System.String]'RESET_SETTINGS_BUTTON'
$RESET_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESET_SETTINGS_BUTTON.TabIndex = [System.Int32]2
$RESET_SETTINGS_BUTTON.Text = [System.String]'Reset'
$RESET_SETTINGS_BUTTON.UseVisualStyleBackColor = $true
#
#SAVE_SETTINGS_BUTTON
#
$SAVE_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$SAVE_SETTINGS_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$SAVE_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]8,[System.Int32]293))
$SAVE_SETTINGS_BUTTON.Name = [System.String]'SAVE_SETTINGS_BUTTON'
$SAVE_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$SAVE_SETTINGS_BUTTON.TabIndex = [System.Int32]4
$SAVE_SETTINGS_BUTTON.Text = [System.String]'Save'
$SAVE_SETTINGS_BUTTON.UseVisualStyleBackColor = $true
$SAVE_SETTINGS_BUTTON.add_Click($Button3_Click)
#
#SETTINGS_FORM
#
$SETTINGS_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]396,[System.Int32]319))
$SETTINGS_FORM.Controls.Add($SAVE_SETTINGS_BUTTON)
$SETTINGS_FORM.Controls.Add($RESET_SETTINGS_BUTTON)
$SETTINGS_FORM.Controls.Add($BACK_SETTINGS_BUTTON)
$SETTINGS_FORM.Controls.Add($SETTINGS_TABCONTROL)
$SETTINGS_FORM.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$SETTINGS_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$SETTINGS_FORM.MaximizeBox = $false
$SETTINGS_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
$SETTINGS_FORM.Text = [System.String]'Settings - FPCA'
$SETTINGS_FORM.TopMost = $true
$SETTINGS_FORM.ResumeLayout($false)
Add-Member -InputObject $SETTINGS_FORM -Name SETTINGS_TABCONTROL -Value $SETTINGS_TABCONTROL -MemberType NoteProperty
Add-Member -InputObject $SETTINGS_FORM -Name BACK_SETTINGS_BUTTON -Value $BACK_SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $SETTINGS_FORM -Name RESET_SETTINGS_BUTTON -Value $RESET_SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $SETTINGS_FORM -Name SAVE_SETTINGS_BUTTON -Value $SAVE_SETTINGS_BUTTON -MemberType NoteProperty
}
. InitializeComponent
