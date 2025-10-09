$RESTARTOPTIONS_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Label]$RESTARTOPTIONS_DESC_LABEL = $null
[System.Windows.Forms.Button]$RESTARTOPTIONS_RESTARTPC_BUTTON = $null
[System.Windows.Forms.Button]$RESTARTOPTIONS_RESTARTBIOS_BUTTON = $null
[System.Windows.Forms.Button]$RESTARTOPTIONS_RESTARTRE_BUTTON = $null
[System.Windows.Forms.Button]$RESTARTOPTIONS_RESTARTFPCA_BUTTON = $null
[System.Windows.Forms.Button]$RESTARTOPTIONS_REMINDLATER_BUTTON = $null
[System.Windows.Forms.Button]$RESTARTOPTIONS_NORESTART_BUTTON = $null
function InitializeComponent
{
$RESTARTOPTIONS_DESC_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$RESTARTOPTIONS_RESTARTPC_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESTARTOPTIONS_RESTARTBIOS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESTARTOPTIONS_RESTARTRE_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESTARTOPTIONS_RESTARTFPCA_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESTARTOPTIONS_REMINDLATER_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESTARTOPTIONS_NORESTART_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESTARTOPTIONS_FORM.SuspendLayout()
#
#RESTARTOPTIONS_DESC_LABEL
#
$RESTARTOPTIONS_DESC_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$RESTARTOPTIONS_DESC_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]18))
$RESTARTOPTIONS_DESC_LABEL.Name = [System.String]'RESTARTOPTIONS_DESC_LABEL'
$RESTARTOPTIONS_DESC_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]237,[System.Int32]23))
$RESTARTOPTIONS_DESC_LABEL.TabIndex = [System.Int32]0
$RESTARTOPTIONS_DESC_LABEL.Text = [System.String]'Do you want to restart the Computer?'
$RESTARTOPTIONS_DESC_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#
#RESTARTOPTIONS_RESTARTPC_BUTTON
#
$RESTARTOPTIONS_RESTARTPC_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7))
$RESTARTOPTIONS_RESTARTPC_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]56))
$RESTARTOPTIONS_RESTARTPC_BUTTON.Name = [System.String]'RESTARTOPTIONS_RESTARTPC_BUTTON'
$RESTARTOPTIONS_RESTARTPC_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESTARTOPTIONS_RESTARTPC_BUTTON.TabIndex = [System.Int32]1
$RESTARTOPTIONS_RESTARTPC_BUTTON.Text = [System.String]'PC Restart'
$RESTARTOPTIONS_RESTARTPC_BUTTON.UseVisualStyleBackColor = $true
#
#RESTARTOPTIONS_RESTARTBIOS_BUTTON
#
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7))
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]85))
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.Name = [System.String]'RESTARTOPTIONS_RESTARTBIOS_BUTTON'
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.TabIndex = [System.Int32]2
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.Text = [System.String]'Bios Restart'
$RESTARTOPTIONS_RESTARTBIOS_BUTTON.UseVisualStyleBackColor = $true
#
#RESTARTOPTIONS_RESTARTRE_BUTTON
#
$RESTARTOPTIONS_RESTARTRE_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7))
$RESTARTOPTIONS_RESTARTRE_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]93,[System.Int32]56))
$RESTARTOPTIONS_RESTARTRE_BUTTON.Name = [System.String]'RESTARTOPTIONS_RESTARTRE_BUTTON'
$RESTARTOPTIONS_RESTARTRE_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESTARTOPTIONS_RESTARTRE_BUTTON.TabIndex = [System.Int32]3
$RESTARTOPTIONS_RESTARTRE_BUTTON.Text = [System.String]'RE Restart'
$RESTARTOPTIONS_RESTARTRE_BUTTON.UseVisualStyleBackColor = $true
#
#RESTARTOPTIONS_RESTARTFPCA_BUTTON
#
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7))
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]93,[System.Int32]85))
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.Name = [System.String]'RESTARTOPTIONS_RESTARTFPCA_BUTTON'
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.TabIndex = [System.Int32]4
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.Text = [System.String]'FPCA Restart'
$RESTARTOPTIONS_RESTARTFPCA_BUTTON.UseVisualStyleBackColor = $true
#
#RESTARTOPTIONS_REMINDLATER_BUTTON
#
$RESTARTOPTIONS_REMINDLATER_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7))
$RESTARTOPTIONS_REMINDLATER_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]56))
$RESTARTOPTIONS_REMINDLATER_BUTTON.Name = [System.String]'RESTARTOPTIONS_REMINDLATER_BUTTON'
$RESTARTOPTIONS_REMINDLATER_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESTARTOPTIONS_REMINDLATER_BUTTON.TabIndex = [System.Int32]5
$RESTARTOPTIONS_REMINDLATER_BUTTON.Text = [System.String]'Restart Later'
$RESTARTOPTIONS_REMINDLATER_BUTTON.UseVisualStyleBackColor = $true
#
#RESTARTOPTIONS_NORESTART_BUTTON
#
$RESTARTOPTIONS_NORESTART_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7))
$RESTARTOPTIONS_NORESTART_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]174,[System.Int32]85))
$RESTARTOPTIONS_NORESTART_BUTTON.Name = [System.String]'RESTARTOPTIONS_NORESTART_BUTTON'
$RESTARTOPTIONS_NORESTART_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]75,[System.Int32]23))
$RESTARTOPTIONS_NORESTART_BUTTON.TabIndex = [System.Int32]6
$RESTARTOPTIONS_NORESTART_BUTTON.Text = [System.String]'No Restart'
$RESTARTOPTIONS_NORESTART_BUTTON.UseVisualStyleBackColor = $true
#
#RESTARTOPTIONS_FORM
#
$RESTARTOPTIONS_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]261,[System.Int32]119))
$RESTARTOPTIONS_FORM.Controls.Add($RESTARTOPTIONS_NORESTART_BUTTON)
$RESTARTOPTIONS_FORM.Controls.Add($RESTARTOPTIONS_REMINDLATER_BUTTON)
$RESTARTOPTIONS_FORM.Controls.Add($RESTARTOPTIONS_RESTARTFPCA_BUTTON)
$RESTARTOPTIONS_FORM.Controls.Add($RESTARTOPTIONS_RESTARTRE_BUTTON)
$RESTARTOPTIONS_FORM.Controls.Add($RESTARTOPTIONS_RESTARTBIOS_BUTTON)
$RESTARTOPTIONS_FORM.Controls.Add($RESTARTOPTIONS_RESTARTPC_BUTTON)
$RESTARTOPTIONS_FORM.Controls.Add($RESTARTOPTIONS_DESC_LABEL)
$RESTARTOPTIONS_FORM.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$RESTARTOPTIONS_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$RESTARTOPTIONS_FORM.MaximizeBox = $false
$RESTARTOPTIONS_FORM.Name = [System.String]'RESTARTOPTIONS_FORM'
$RESTARTOPTIONS_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$RESTARTOPTIONS_FORM.Text = [System.String]'FPCA - Restart Options'
$RESTARTOPTIONS_FORM.TopMost = $true
$RESTARTOPTIONS_FORM.ResumeLayout($false)
Add-Member -InputObject $RESTARTOPTIONS_FORM -Name RESTARTOPTIONS_DESC_LABEL -Value $RESTARTOPTIONS_DESC_LABEL -MemberType NoteProperty
Add-Member -InputObject $RESTARTOPTIONS_FORM -Name RESTARTOPTIONS_RESTARTPC_BUTTON -Value $RESTARTOPTIONS_RESTARTPC_BUTTON -MemberType NoteProperty
Add-Member -InputObject $RESTARTOPTIONS_FORM -Name RESTARTOPTIONS_RESTARTBIOS_BUTTON -Value $RESTARTOPTIONS_RESTARTBIOS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $RESTARTOPTIONS_FORM -Name RESTARTOPTIONS_RESTARTRE_BUTTON -Value $RESTARTOPTIONS_RESTARTRE_BUTTON -MemberType NoteProperty
Add-Member -InputObject $RESTARTOPTIONS_FORM -Name RESTARTOPTIONS_RESTARTFPCA_BUTTON -Value $RESTARTOPTIONS_RESTARTFPCA_BUTTON -MemberType NoteProperty
Add-Member -InputObject $RESTARTOPTIONS_FORM -Name RESTARTOPTIONS_REMINDLATER_BUTTON -Value $RESTARTOPTIONS_REMINDLATER_BUTTON -MemberType NoteProperty
Add-Member -InputObject $RESTARTOPTIONS_FORM -Name RESTARTOPTIONS_NORESTART_BUTTON -Value $RESTARTOPTIONS_NORESTART_BUTTON -MemberType NoteProperty
}
. InitializeComponent
