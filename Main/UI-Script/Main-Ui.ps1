$MAIN_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$SIDE_PANNEL = $null
[System.Windows.Forms.Button]$SETTINGS_BUTTON = $null
[System.Windows.Forms.TabControl]$MAIN_TAB_CONTROL = $null
[System.Windows.Forms.TabPage]$CONFIG_TAB = $null
[System.Windows.Forms.TabPage]$APP_TAB = $null
[System.Windows.Forms.Label]$VERSION_LABEL = $null
[System.Windows.Forms.Label]$VERSION_NUMBER_LABEL = $null
function InitializeComponent
{
$SIDE_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TAB_CONTROL = (New-Object -TypeName System.Windows.Forms.TabControl)
$CONFIG_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$APP_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$VERSION_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$VERSION_NUMBER_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$SIDE_PANNEL.SuspendLayout()
$MAIN_TAB_CONTROL.SuspendLayout()
$MAIN_FORM.SuspendLayout()
#
#SIDE_PANNEL
#
$SIDE_PANNEL.BackColor = [System.Drawing.Color]::Gray
$SIDE_PANNEL.Controls.Add($SETTINGS_BUTTON)
$SIDE_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
$SIDE_PANNEL.Name = [System.String]'SIDE_PANNEL'
$SIDE_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]92,[System.Int32]301))
$SIDE_PANNEL.TabIndex = [System.Int32]1
#
#MAIN_TAB_CONTROL
#
$MAIN_TAB_CONTROL.Controls.Add($CONFIG_TAB)
$MAIN_TAB_CONTROL.Controls.Add($APP_TAB)
$MAIN_TAB_CONTROL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$MAIN_TAB_CONTROL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]12))
$MAIN_TAB_CONTROL.Name = [System.String]'MAIN_TAB_CONTROL'
$MAIN_TAB_CONTROL.SelectedIndex = [System.Int32]0
$MAIN_TAB_CONTROL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]436,[System.Int32]301))
$MAIN_TAB_CONTROL.TabIndex = [System.Int32]2
#
#CONFIG_TAB
#
$CONFIG_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$CONFIG_TAB.Name = [System.String]'CONFIG_TAB'
$CONFIG_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$CONFIG_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]428,[System.Int32]273))
$CONFIG_TAB.TabIndex = [System.Int32]0
$CONFIG_TAB.Text = [System.String]'Configuration'
$CONFIG_TAB.UseVisualStyleBackColor = $true
#
#APP_TAB
#
$APP_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$APP_TAB.Name = [System.String]'APP_TAB'
$APP_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$APP_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]428,[System.Int32]273))
$APP_TAB.TabIndex = [System.Int32]1
$APP_TAB.Text = [System.String]'App'
$APP_TAB.UseVisualStyleBackColor = $true
#
#VERSION_LABEL
#
$VERSION_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$VERSION_LABEL.ForeColor = [System.Drawing.Color]::White
$VERSION_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]446,[System.Int32]9))
$VERSION_LABEL.Name = [System.String]'VERSION_LABEL'
$VERSION_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]57,[System.Int32]17))
$VERSION_LABEL.TabIndex = [System.Int32]3
$VERSION_LABEL.Text = [System.String]'Version:'
#
#VERSION_NUMBER_LABEL
#
$VERSION_NUMBER_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$VERSION_NUMBER_LABEL.ForeColor = [System.Drawing.Color]::White
$VERSION_NUMBER_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]499,[System.Int32]9))
$VERSION_NUMBER_LABEL.Name = [System.String]'VERSION_NUMBER_LABEL'
$VERSION_NUMBER_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]40,[System.Int32]17))
$VERSION_NUMBER_LABEL.TabIndex = [System.Int32]0
$VERSION_NUMBER_LABEL.Text = [System.String]'0.0'
#
#SETTINGS_BUTTON
#
$SETTINGS_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]271))
$SETTINGS_BUTTON.Name = [System.String]'SETTINGS_BUTTON'
$SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]26))
$SETTINGS_BUTTON.TabIndex = [System.Int32]0
$SETTINGS_BUTTON.Text = [System.String]'Settings'
$SETTINGS_BUTTON.UseVisualStyleBackColor = $true
$SETTINGS_BUTTON.add_Click($Button1_Click)
#
#MAIN_FORM
#
$MAIN_FORM.AutoValidate = [System.Windows.Forms.AutoValidate]::EnablePreventFocusChange
$MAIN_FORM.BackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)))

$MAIN_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]558,[System.Int32]325))
$MAIN_FORM.Controls.Add($VERSION_NUMBER_LABEL)
$MAIN_FORM.Controls.Add($VERSION_LABEL)
$MAIN_FORM.Controls.Add($MAIN_TAB_CONTROL)
$MAIN_FORM.Controls.Add($SIDE_PANNEL)
$MAIN_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$MAIN_FORM.MaximizeBox = $false
$MAIN_FORM.MinimizeBox = $false
$MAIN_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MAIN_FORM.Text = [System.String]'FPCA - (Frysix''s Powershell Configurator App)'
$MAIN_FORM.TopMost = $true
$SIDE_PANNEL.ResumeLayout($false)
$MAIN_TAB_CONTROL.ResumeLayout($false)
$MAIN_FORM.ResumeLayout($false)
Add-Member -InputObject $MAIN_FORM -Name SIDE_PANNEL -Value $SIDE_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_BUTTON -Value $SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MAIN_TAB_CONTROL -Value $MAIN_TAB_CONTROL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_TAB -Value $CONFIG_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_TAB -Value $APP_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_LABEL -Value $VERSION_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_NUMBER_LABEL -Value $VERSION_NUMBER_LABEL -MemberType NoteProperty
}
. InitializeComponent
