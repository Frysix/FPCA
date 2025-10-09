$RESTARTREMINDER_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$REMINDER_DESC_LABEL = $null
[System.Windows.Forms.TextBox]$REMINDER_MINS_INPUT_TEXTBOX = $null
[System.Windows.Forms.Label]$REMINDER_MINS_DESC_LABEL = $null
[System.Windows.Forms.Label]$REMINDER_ESTIMATEDTIME_LABEL = $null
[System.Windows.Forms.Button]$REMINDER_CONFIRM_BUTTON = $null
[System.Windows.Forms.Button]$REMINDER_CANCEL_BUTTON = $null
function InitializeComponent
{
$REMINDER_DESC_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$REMINDER_MINS_INPUT_TEXTBOX = (New-Object -TypeName System.Windows.Forms.TextBox)
$REMINDER_MINS_DESC_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$REMINDER_ESTIMATEDTIME_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$REMINDER_CONFIRM_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$REMINDER_CANCEL_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESTARTREMINDER_FORM.SuspendLayout()
#
#REMINDER_DESC_LABEL
#
$REMINDER_DESC_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$REMINDER_DESC_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]9))
$REMINDER_DESC_LABEL.Name = [System.String]'REMINDER_DESC_LABEL'
$REMINDER_DESC_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]300,[System.Int32]43))
$REMINDER_DESC_LABEL.TabIndex = [System.Int32]0
$REMINDER_DESC_LABEL.Text = [System.String]'Select in how much time you want to be reminded to restart the computer:'
#
#REMINDER_MINS_INPUT_TEXTBOX
#
$REMINDER_MINS_INPUT_TEXTBOX.BackColor = [System.Drawing.SystemColors]::ButtonHighlight
$REMINDER_MINS_INPUT_TEXTBOX.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$REMINDER_MINS_INPUT_TEXTBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$REMINDER_MINS_INPUT_TEXTBOX.ForeColor = [System.Drawing.SystemColors]::WindowText
$REMINDER_MINS_INPUT_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]65,[System.Int32]53))
$REMINDER_MINS_INPUT_TEXTBOX.Name = [System.String]'REMINDER_MINS_INPUT_TEXTBOX'
$REMINDER_MINS_INPUT_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]98,[System.Int32]23))
$REMINDER_MINS_INPUT_TEXTBOX.TabIndex = [System.Int32]1
$REMINDER_MINS_INPUT_TEXTBOX.Text = [System.String]'15'
$REMINDER_MINS_INPUT_TEXTBOX.TextAlign = [System.Windows.Forms.HorizontalAlignment]::Center
$REMINDER_MINS_INPUT_TEXTBOX.add_TextChanged($TextBox1_TextChanged)
#
#REMINDER_MINS_DESC_LABEL
#
$REMINDER_MINS_DESC_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$REMINDER_MINS_DESC_LABEL.ForeColor = [System.Drawing.Color]::Black
$REMINDER_MINS_DESC_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]169,[System.Int32]52))
$REMINDER_MINS_DESC_LABEL.Name = [System.String]'REMINDER_MINS_DESC_LABEL'
$REMINDER_MINS_DESC_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]84,[System.Int32]23))
$REMINDER_MINS_DESC_LABEL.TabIndex = [System.Int32]2
$REMINDER_MINS_DESC_LABEL.Text = [System.String]'Minutes'
$REMINDER_MINS_DESC_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$REMINDER_MINS_DESC_LABEL.add_Click($REMINDER_MINS_DESC_LABEL_Click)
#
#REMINDER_ESTIMATEDTIME_LABEL
#
$REMINDER_ESTIMATEDTIME_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$REMINDER_ESTIMATEDTIME_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]44,[System.Int32]79))
$REMINDER_ESTIMATEDTIME_LABEL.Name = [System.String]'REMINDER_ESTIMATEDTIME_LABEL'
$REMINDER_ESTIMATEDTIME_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]232,[System.Int32]23))
$REMINDER_ESTIMATEDTIME_LABEL.TabIndex = [System.Int32]3
$REMINDER_ESTIMATEDTIME_LABEL.Text = [System.String]'Reminder scheduled for: 00:00:00 AM/PM'
#
#REMINDER_CONFIRM_BUTTON
#
$REMINDER_CONFIRM_BUTTON.BackColor = [System.Drawing.SystemColors]::ButtonHighlight
$REMINDER_CONFIRM_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$REMINDER_CONFIRM_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$REMINDER_CONFIRM_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]117))
$REMINDER_CONFIRM_BUTTON.Name = [System.String]'REMINDER_CONFIRM_BUTTON'
$REMINDER_CONFIRM_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]84,[System.Int32]27))
$REMINDER_CONFIRM_BUTTON.TabIndex = [System.Int32]4
$REMINDER_CONFIRM_BUTTON.Text = [System.String]'Confirm'
$REMINDER_CONFIRM_BUTTON.UseVisualStyleBackColor = $false
$REMINDER_CONFIRM_BUTTON.add_Click($Button1_Click)
#
#REMINDER_CANCEL_BUTTON
#
$REMINDER_CANCEL_BUTTON.BackColor = [System.Drawing.SystemColors]::ButtonHighlight
$REMINDER_CANCEL_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$REMINDER_CANCEL_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$REMINDER_CANCEL_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]228,[System.Int32]117))
$REMINDER_CANCEL_BUTTON.Name = [System.String]'REMINDER_CANCEL_BUTTON'
$REMINDER_CANCEL_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]84,[System.Int32]27))
$REMINDER_CANCEL_BUTTON.TabIndex = [System.Int32]5
$REMINDER_CANCEL_BUTTON.Text = [System.String]'Cancel'
$REMINDER_CANCEL_BUTTON.UseVisualStyleBackColor = $false
$REMINDER_CANCEL_BUTTON.add_Click($REMINDER_CANCEL_BUTTON_Click)
#
#RESTARTREMINDER_FORM
#
$RESTARTREMINDER_FORM.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Inherit
$RESTARTREMINDER_FORM.BackColor = [System.Drawing.SystemColors]::Control
$RESTARTREMINDER_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]324,[System.Int32]151))
$RESTARTREMINDER_FORM.Controls.Add($REMINDER_CANCEL_BUTTON)
$RESTARTREMINDER_FORM.Controls.Add($REMINDER_CONFIRM_BUTTON)
$RESTARTREMINDER_FORM.Controls.Add($REMINDER_ESTIMATEDTIME_LABEL)
$RESTARTREMINDER_FORM.Controls.Add($REMINDER_MINS_DESC_LABEL)
$RESTARTREMINDER_FORM.Controls.Add($REMINDER_MINS_INPUT_TEXTBOX)
$RESTARTREMINDER_FORM.Controls.Add($REMINDER_DESC_LABEL)
$RESTARTREMINDER_FORM.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$RESTARTREMINDER_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$RESTARTREMINDER_FORM.MaximizeBox = $false
$RESTARTREMINDER_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$RESTARTREMINDER_FORM.Text = [System.String]'FPCA - Restart Reminder'
$RESTARTREMINDER_FORM.TopMost = $true
$RESTARTREMINDER_FORM.add_Load($RESTARTREMINDER_FORM_Load)
$RESTARTREMINDER_FORM.ResumeLayout($false)
$RESTARTREMINDER_FORM.PerformLayout()
Add-Member -InputObject $RESTARTREMINDER_FORM -Name REMINDER_DESC_LABEL -Value $REMINDER_DESC_LABEL -MemberType NoteProperty
Add-Member -InputObject $RESTARTREMINDER_FORM -Name REMINDER_MINS_INPUT_TEXTBOX -Value $REMINDER_MINS_INPUT_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $RESTARTREMINDER_FORM -Name REMINDER_MINS_DESC_LABEL -Value $REMINDER_MINS_DESC_LABEL -MemberType NoteProperty
Add-Member -InputObject $RESTARTREMINDER_FORM -Name REMINDER_ESTIMATEDTIME_LABEL -Value $REMINDER_ESTIMATEDTIME_LABEL -MemberType NoteProperty
Add-Member -InputObject $RESTARTREMINDER_FORM -Name REMINDER_CONFIRM_BUTTON -Value $REMINDER_CONFIRM_BUTTON -MemberType NoteProperty
Add-Member -InputObject $RESTARTREMINDER_FORM -Name REMINDER_CANCEL_BUTTON -Value $REMINDER_CANCEL_BUTTON -MemberType NoteProperty
}
. InitializeComponent
