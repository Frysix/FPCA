$CREDSPROMPT_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.TextBox]$CREDSPROMPT_USERNAME_TEXTBOX = $null
[System.Windows.Forms.TextBox]$CREDSPROMPT_PASSWORD_TEXTBOX = $null
[System.Windows.Forms.Button]$CREDSPROMPT_CONFIRM_BUTTON = $null
[System.Windows.Forms.Button]$CREDSPROMPT_CANCEL_BUTTON = $null
[System.Windows.Forms.Label]$CREDSPROMPT_PASSWORD_LABEL = $null
[System.Windows.Forms.Label]$CREDSPROMPT_USERNAME_LABEL = $null
[System.Windows.Forms.Label]$CREDSPROMPT_CUSTOMTEXT_LABEL = $null
function InitializeComponent
{
$CREDSPROMPT_USERNAME_TEXTBOX = (New-Object -TypeName System.Windows.Forms.TextBox)
$CREDSPROMPT_PASSWORD_TEXTBOX = (New-Object -TypeName System.Windows.Forms.TextBox)
$CREDSPROMPT_CONFIRM_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$CREDSPROMPT_CANCEL_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$CREDSPROMPT_PASSWORD_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$CREDSPROMPT_USERNAME_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$CREDSPROMPT_CUSTOMTEXT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$CREDSPROMPT_FORM.SuspendLayout()
#
#CREDSPROMPT_USERNAME_TEXTBOX
#
$CREDSPROMPT_USERNAME_TEXTBOX.BackColor = [System.Drawing.Color]::White
$CREDSPROMPT_USERNAME_TEXTBOX.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CREDSPROMPT_USERNAME_TEXTBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CREDSPROMPT_USERNAME_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]41,[System.Int32]108))
$CREDSPROMPT_USERNAME_TEXTBOX.Name = [System.String]'CREDSPROMPT_USERNAME_TEXTBOX'
$CREDSPROMPT_USERNAME_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]271,[System.Int32]29))
$CREDSPROMPT_USERNAME_TEXTBOX.TabIndex = [System.Int32]0
#
#CREDSPROMPT_PASSWORD_TEXTBOX
#
$CREDSPROMPT_PASSWORD_TEXTBOX.BackColor = [System.Drawing.Color]::White
$CREDSPROMPT_PASSWORD_TEXTBOX.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CREDSPROMPT_PASSWORD_TEXTBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]12))
$CREDSPROMPT_PASSWORD_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]41,[System.Int32]166))
$CREDSPROMPT_PASSWORD_TEXTBOX.Name = [System.String]'CREDSPROMPT_PASSWORD_TEXTBOX'
$CREDSPROMPT_PASSWORD_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]271,[System.Int32]29))
$CREDSPROMPT_PASSWORD_TEXTBOX.TabIndex = [System.Int32]1
#
#CREDSPROMPT_CONFIRM_BUTTON
#
$CREDSPROMPT_CONFIRM_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$CREDSPROMPT_CONFIRM_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CREDSPROMPT_CONFIRM_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]221))
$CREDSPROMPT_CONFIRM_BUTTON.Name = [System.String]'CREDSPROMPT_CONFIRM_BUTTON'
$CREDSPROMPT_CONFIRM_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]32))
$CREDSPROMPT_CONFIRM_BUTTON.TabIndex = [System.Int32]2
$CREDSPROMPT_CONFIRM_BUTTON.Text = [System.String]'Confirm'
$CREDSPROMPT_CONFIRM_BUTTON.UseVisualStyleBackColor = $true
#
#CREDSPROMPT_CANCEL_BUTTON
#
$CREDSPROMPT_CANCEL_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::System
$CREDSPROMPT_CANCEL_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9))
$CREDSPROMPT_CANCEL_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]239,[System.Int32]221))
$CREDSPROMPT_CANCEL_BUTTON.Name = [System.String]'CREDSPROMPT_CANCEL_BUTTON'
$CREDSPROMPT_CANCEL_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]100,[System.Int32]32))
$CREDSPROMPT_CANCEL_BUTTON.TabIndex = [System.Int32]3
$CREDSPROMPT_CANCEL_BUTTON.Text = [System.String]'Cancel'
$CREDSPROMPT_CANCEL_BUTTON.UseVisualStyleBackColor = $true
#
#CREDSPROMPT_PASSWORD_LABEL
#
$CREDSPROMPT_PASSWORD_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$CREDSPROMPT_PASSWORD_LABEL.ForeColor = [System.Drawing.Color]::White
$CREDSPROMPT_PASSWORD_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]140))
$CREDSPROMPT_PASSWORD_LABEL.Name = [System.String]'CREDSPROMPT_PASSWORD_LABEL'
$CREDSPROMPT_PASSWORD_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]300,[System.Int32]23))
$CREDSPROMPT_PASSWORD_LABEL.TabIndex = [System.Int32]4
$CREDSPROMPT_PASSWORD_LABEL.Text = [System.String]'Password:'
$CREDSPROMPT_PASSWORD_LABEL.TextAlign = [System.Drawing.ContentAlignment]::BottomLeft
#
#CREDSPROMPT_USERNAME_LABEL
#
$CREDSPROMPT_USERNAME_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CREDSPROMPT_USERNAME_LABEL.ForeColor = [System.Drawing.Color]::White
$CREDSPROMPT_USERNAME_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]82))
$CREDSPROMPT_USERNAME_LABEL.Name = [System.String]'CREDSPROMPT_USERNAME_LABEL'
$CREDSPROMPT_USERNAME_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]300,[System.Int32]23))
$CREDSPROMPT_USERNAME_LABEL.TabIndex = [System.Int32]5
$CREDSPROMPT_USERNAME_LABEL.Text = [System.String]'Username:'
$CREDSPROMPT_USERNAME_LABEL.TextAlign = [System.Drawing.ContentAlignment]::BottomLeft
#
#CREDSPROMPT_CUSTOMTEXT_LABEL
#
$CREDSPROMPT_CUSTOMTEXT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CREDSPROMPT_CUSTOMTEXT_LABEL.ForeColor = [System.Drawing.Color]::White
$CREDSPROMPT_CUSTOMTEXT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]9))
$CREDSPROMPT_CUSTOMTEXT_LABEL.Name = [System.String]'CREDSPROMPT_CUSTOMTEXT_LABEL'
$CREDSPROMPT_CUSTOMTEXT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]327,[System.Int32]73))
$CREDSPROMPT_CUSTOMTEXT_LABEL.TabIndex = [System.Int32]6
$CREDSPROMPT_CUSTOMTEXT_LABEL.Text = [System.String]'<CUSTOMTEXT>'
#
#CREDSPROMPT_FORM
#
$CREDSPROMPT_FORM.BackColor = [System.Drawing.Color]::Gray
$CREDSPROMPT_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]351,[System.Int32]264))
$CREDSPROMPT_FORM.Controls.Add($CREDSPROMPT_CUSTOMTEXT_LABEL)
$CREDSPROMPT_FORM.Controls.Add($CREDSPROMPT_USERNAME_LABEL)
$CREDSPROMPT_FORM.Controls.Add($CREDSPROMPT_PASSWORD_LABEL)
$CREDSPROMPT_FORM.Controls.Add($CREDSPROMPT_CANCEL_BUTTON)
$CREDSPROMPT_FORM.Controls.Add($CREDSPROMPT_CONFIRM_BUTTON)
$CREDSPROMPT_FORM.Controls.Add($CREDSPROMPT_PASSWORD_TEXTBOX)
$CREDSPROMPT_FORM.Controls.Add($CREDSPROMPT_USERNAME_TEXTBOX)
$CREDSPROMPT_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$CREDSPROMPT_FORM.MaximizeBox = $false
$CREDSPROMPT_FORM.Name = [System.String]'CREDSPROMPT_FORM'
$CREDSPROMPT_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$CREDSPROMPT_FORM.Text = [System.String]'FPCA - Input Credentials'
$CREDSPROMPT_FORM.ResumeLayout($false)
$CREDSPROMPT_FORM.PerformLayout()
Add-Member -InputObject $CREDSPROMPT_FORM -Name CREDSPROMPT_USERNAME_TEXTBOX -Value $CREDSPROMPT_USERNAME_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $CREDSPROMPT_FORM -Name CREDSPROMPT_PASSWORD_TEXTBOX -Value $CREDSPROMPT_PASSWORD_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $CREDSPROMPT_FORM -Name CREDSPROMPT_CONFIRM_BUTTON -Value $CREDSPROMPT_CONFIRM_BUTTON -MemberType NoteProperty
Add-Member -InputObject $CREDSPROMPT_FORM -Name CREDSPROMPT_CANCEL_BUTTON -Value $CREDSPROMPT_CANCEL_BUTTON -MemberType NoteProperty
Add-Member -InputObject $CREDSPROMPT_FORM -Name CREDSPROMPT_PASSWORD_LABEL -Value $CREDSPROMPT_PASSWORD_LABEL -MemberType NoteProperty
Add-Member -InputObject $CREDSPROMPT_FORM -Name CREDSPROMPT_USERNAME_LABEL -Value $CREDSPROMPT_USERNAME_LABEL -MemberType NoteProperty
Add-Member -InputObject $CREDSPROMPT_FORM -Name CREDSPROMPT_CUSTOMTEXT_LABEL -Value $CREDSPROMPT_CUSTOMTEXT_LABEL -MemberType NoteProperty
}
. InitializeComponent
