$MAIN_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$SIDE_PANNEL = $null
[System.Windows.Forms.Label]$PC_RAM_FREQUENCY_LABEL = $null
[System.Windows.Forms.Label]$PC_RAM_GBCOUNT_LABEL = $null
[System.Windows.Forms.Label]$RAM_LABEL = $null
[System.Windows.Forms.Label]$PC_GPU_MODEL_LABEL = $null
[System.Windows.Forms.Label]$GPU_LABEL = $null
[System.Windows.Forms.Label]$PC_BOARD_MODEL_LABEL = $null
[System.Windows.Forms.Label]$PC_BOARD_BRANDNAME_LABEL = $null
[System.Windows.Forms.Label]$BOARD_LABEL = $null
[System.Windows.Forms.Label]$PC_CPU_NAME_LABEL = $null
[System.Windows.Forms.Label]$CPU_LABEL = $null
[System.Windows.Forms.LinkLabel]$SYSTEMINFO_LINK_LABEL = $null
[System.Windows.Forms.Button]$SETTINGS_BUTTON = $null
[System.Windows.Forms.TabControl]$MAIN_TAB_CONTROL = $null
[System.Windows.Forms.TabPage]$CONFIG_TAB = $null
[System.Windows.Forms.Button]$Button1 = $null
[System.Windows.Forms.TabPage]$APP_TAB = $null
[System.Windows.Forms.Label]$VERSION_LABEL = $null
[System.Windows.Forms.Label]$VERSION_NUMBER_LABEL = $null
function InitializeComponent
{
$SIDE_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$MAIN_TAB_CONTROL = (New-Object -TypeName System.Windows.Forms.TabControl)
$CONFIG_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$APP_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$VERSION_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$VERSION_NUMBER_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SYSTEMINFO_LINK_LABEL = (New-Object -TypeName System.Windows.Forms.LinkLabel)
$CPU_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_CPU_NAME_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$BOARD_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_BOARD_BRANDNAME_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_BOARD_MODEL_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$GPU_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_GPU_MODEL_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$RAM_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_RAM_GBCOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_RAM_FREQUENCY_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$Button1 = (New-Object -TypeName System.Windows.Forms.Button)
$SIDE_PANNEL.SuspendLayout()
$MAIN_TAB_CONTROL.SuspendLayout()
$CONFIG_TAB.SuspendLayout()
$MAIN_FORM.SuspendLayout()
#
#SIDE_PANNEL
#
$SIDE_PANNEL.BackColor = [System.Drawing.Color]::Gray
$SIDE_PANNEL.Controls.Add($PC_RAM_FREQUENCY_LABEL)
$SIDE_PANNEL.Controls.Add($PC_RAM_GBCOUNT_LABEL)
$SIDE_PANNEL.Controls.Add($RAM_LABEL)
$SIDE_PANNEL.Controls.Add($PC_GPU_MODEL_LABEL)
$SIDE_PANNEL.Controls.Add($GPU_LABEL)
$SIDE_PANNEL.Controls.Add($PC_BOARD_MODEL_LABEL)
$SIDE_PANNEL.Controls.Add($PC_BOARD_BRANDNAME_LABEL)
$SIDE_PANNEL.Controls.Add($BOARD_LABEL)
$SIDE_PANNEL.Controls.Add($PC_CPU_NAME_LABEL)
$SIDE_PANNEL.Controls.Add($CPU_LABEL)
$SIDE_PANNEL.Controls.Add($SYSTEMINFO_LINK_LABEL)
$SIDE_PANNEL.Controls.Add($SETTINGS_BUTTON)
$SIDE_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
$SIDE_PANNEL.Name = [System.String]'SIDE_PANNEL'
$SIDE_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]92,[System.Int32]301))
$SIDE_PANNEL.TabIndex = [System.Int32]1
#
#SETTINGS_BUTTON
#
$SETTINGS_BUTTON.BackColor = [System.Drawing.Color]::Silver
$SETTINGS_BUTTON.FlatAppearance.BorderColor = [System.Drawing.Color]::Silver
$SETTINGS_BUTTON.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)))

$SETTINGS_BUTTON.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)))

$SETTINGS_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]271))
$SETTINGS_BUTTON.Name = [System.String]'SETTINGS_BUTTON'
$SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]26))
$SETTINGS_BUTTON.TabIndex = [System.Int32]0
$SETTINGS_BUTTON.Text = [System.String]'Settings'
$SETTINGS_BUTTON.UseVisualStyleBackColor = $false
$SETTINGS_BUTTON.add_Click($Button1_Click)
#
#MAIN_TAB_CONTROL
#
$MAIN_TAB_CONTROL.Controls.Add($CONFIG_TAB)
$MAIN_TAB_CONTROL.Controls.Add($APP_TAB)
$MAIN_TAB_CONTROL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$MAIN_TAB_CONTROL.HotTrack = $true
$MAIN_TAB_CONTROL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]12))
$MAIN_TAB_CONTROL.Name = [System.String]'MAIN_TAB_CONTROL'
$MAIN_TAB_CONTROL.SelectedIndex = [System.Int32]0
$MAIN_TAB_CONTROL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]436,[System.Int32]301))
$MAIN_TAB_CONTROL.TabIndex = [System.Int32]2
#
#CONFIG_TAB
#
$CONFIG_TAB.BackColor = [System.Drawing.Color]::Gray
$CONFIG_TAB.Controls.Add($Button1)
$CONFIG_TAB.ForeColor = [System.Drawing.SystemColors]::ControlText
$CONFIG_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$CONFIG_TAB.Name = [System.String]'CONFIG_TAB'
$CONFIG_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$CONFIG_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]428,[System.Int32]273))
$CONFIG_TAB.TabIndex = [System.Int32]0
$CONFIG_TAB.Text = [System.String]'Configuration'
#
#APP_TAB
#
$APP_TAB.BackColor = [System.Drawing.Color]::Gray
$APP_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$APP_TAB.Name = [System.String]'APP_TAB'
$APP_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$APP_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]428,[System.Int32]273))
$APP_TAB.TabIndex = [System.Int32]1
$APP_TAB.Text = [System.String]'App'
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
#SYSTEMINFO_LINK_LABEL
#
$SYSTEMINFO_LINK_LABEL.ActiveLinkColor = [System.Drawing.Color]::LightGray
$SYSTEMINFO_LINK_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$SYSTEMINFO_LINK_LABEL.LinkColor = [System.Drawing.Color]::Navy
$SYSTEMINFO_LINK_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$SYSTEMINFO_LINK_LABEL.Name = [System.String]'SYSTEMINFO_LINK_LABEL'
$SYSTEMINFO_LINK_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]24))
$SYSTEMINFO_LINK_LABEL.TabIndex = [System.Int32]1
$SYSTEMINFO_LINK_LABEL.TabStop = $true
$SYSTEMINFO_LINK_LABEL.Text = [System.String]'System Info:'
#
#CPU_LABEL
#
$CPU_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Black',[System.Single]9,[System.Drawing.FontStyle]::Bold))
$CPU_LABEL.ForeColor = [System.Drawing.Color]::Black
$CPU_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]24))
$CPU_LABEL.Name = [System.String]'CPU_LABEL'
$CPU_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]16))
$CPU_LABEL.TabIndex = [System.Int32]2
$CPU_LABEL.Text = [System.String]'CPU:'
$CPU_LABEL.add_Click($CPU_LABEL_Click)
#
#PC_CPU_NAME_LABEL
#
$PC_CPU_NAME_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PC_CPU_NAME_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]40))
$PC_CPU_NAME_LABEL.Name = [System.String]'PC_CPU_NAME_LABEL'
$PC_CPU_NAME_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]39))
$PC_CPU_NAME_LABEL.TabIndex = [System.Int32]3
$PC_CPU_NAME_LABEL.Text = [System.String]'UNKNOWN'
#
#BOARD_LABEL
#
$BOARD_LABEL.BackColor = [System.Drawing.Color]::Transparent
$BOARD_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Black',[System.Single]9,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$BOARD_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]79))
$BOARD_LABEL.Name = [System.String]'BOARD_LABEL'
$BOARD_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]16))
$BOARD_LABEL.TabIndex = [System.Int32]4
$BOARD_LABEL.Text = [System.String]'Board:'
$BOARD_LABEL.add_Click($Label1_Click)
#
#PC_BOARD_BRANDNAME_LABEL
#
$PC_BOARD_BRANDNAME_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PC_BOARD_BRANDNAME_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]95))
$PC_BOARD_BRANDNAME_LABEL.Name = [System.String]'PC_BOARD_BRANDNAME_LABEL'
$PC_BOARD_BRANDNAME_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]17))
$PC_BOARD_BRANDNAME_LABEL.TabIndex = [System.Int32]5
$PC_BOARD_BRANDNAME_LABEL.Text = [System.String]'UNKNOWN'
#
#PC_BOARD_MODEL_LABEL
#
$PC_BOARD_MODEL_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PC_BOARD_MODEL_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]112))
$PC_BOARD_MODEL_LABEL.Name = [System.String]'PC_BOARD_MODEL_LABEL'
$PC_BOARD_MODEL_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]31))
$PC_BOARD_MODEL_LABEL.TabIndex = [System.Int32]6
$PC_BOARD_MODEL_LABEL.Text = [System.String]'UNKNOWN'
$PC_BOARD_MODEL_LABEL.add_Click($PC_BOARD_MODEL_LABEL_Click)
#
#GPU_LABEL
#
$GPU_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Black',[System.Single]9,[System.Drawing.FontStyle]::Bold))
$GPU_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]143))
$GPU_LABEL.Name = [System.String]'GPU_LABEL'
$GPU_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]17))
$GPU_LABEL.TabIndex = [System.Int32]7
$GPU_LABEL.Text = [System.String]'GPU:'
$GPU_LABEL.add_Click($Label2_Click)
#
#PC_GPU_MODEL_LABEL
#
$PC_GPU_MODEL_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75))
$PC_GPU_MODEL_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]160))
$PC_GPU_MODEL_LABEL.Name = [System.String]'PC_GPU_MODEL_LABEL'
$PC_GPU_MODEL_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]28))
$PC_GPU_MODEL_LABEL.TabIndex = [System.Int32]8
$PC_GPU_MODEL_LABEL.Text = [System.String]'UNKNOWN'
#
#RAM_LABEL
#
$RAM_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Black',[System.Single]9,[System.Drawing.FontStyle]::Bold))
$RAM_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]188))
$RAM_LABEL.Name = [System.String]'RAM_LABEL'
$RAM_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]16))
$RAM_LABEL.TabIndex = [System.Int32]9
$RAM_LABEL.Text = [System.String]'RAM:'
#
#PC_RAM_GBCOUNT_LABEL
#
$PC_RAM_GBCOUNT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75))
$PC_RAM_GBCOUNT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]204))
$PC_RAM_GBCOUNT_LABEL.Name = [System.String]'PC_RAM_GBCOUNT_LABEL'
$PC_RAM_GBCOUNT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]18))
$PC_RAM_GBCOUNT_LABEL.TabIndex = [System.Int32]10
$PC_RAM_GBCOUNT_LABEL.Text = [System.String]'UNKNOWN'
#
#PC_RAM_FREQUENCY_LABEL
#
$PC_RAM_FREQUENCY_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75))
$PC_RAM_FREQUENCY_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]222))
$PC_RAM_FREQUENCY_LABEL.Name = [System.String]'PC_RAM_FREQUENCY_LABEL'
$PC_RAM_FREQUENCY_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]17))
$PC_RAM_FREQUENCY_LABEL.TabIndex = [System.Int32]11
$PC_RAM_FREQUENCY_LABEL.Text = [System.String]'UNKNOWN'
#
#Button1
#
$Button1.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$Button1.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]335,[System.Int32]244))
$Button1.Name = [System.String]'Button1'
$Button1.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]26))
$Button1.TabIndex = [System.Int32]0
$Button1.Text = [System.String]'Start'
$Button1.UseVisualStyleBackColor = $true
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
$CONFIG_TAB.ResumeLayout($false)
$MAIN_FORM.ResumeLayout($false)
Add-Member -InputObject $MAIN_FORM -Name SIDE_PANNEL -Value $SIDE_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name PC_RAM_FREQUENCY_LABEL -Value $PC_RAM_FREQUENCY_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name PC_RAM_GBCOUNT_LABEL -Value $PC_RAM_GBCOUNT_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name RAM_LABEL -Value $RAM_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name PC_GPU_MODEL_LABEL -Value $PC_GPU_MODEL_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name GPU_LABEL -Value $GPU_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name PC_BOARD_MODEL_LABEL -Value $PC_BOARD_MODEL_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name PC_BOARD_BRANDNAME_LABEL -Value $PC_BOARD_BRANDNAME_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name BOARD_LABEL -Value $BOARD_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name PC_CPU_NAME_LABEL -Value $PC_CPU_NAME_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CPU_LABEL -Value $CPU_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SYSTEMINFO_LINK_LABEL -Value $SYSTEMINFO_LINK_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_BUTTON -Value $SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MAIN_TAB_CONTROL -Value $MAIN_TAB_CONTROL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_TAB -Value $CONFIG_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name Button1 -Value $Button1 -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_TAB -Value $APP_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_LABEL -Value $VERSION_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_NUMBER_LABEL -Value $VERSION_NUMBER_LABEL -MemberType NoteProperty
}
. InitializeComponent
