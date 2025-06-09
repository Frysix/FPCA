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
[System.Windows.Forms.Label]$SETTINGS_CONFIG_TITLE_LABEL = $null
[System.Windows.Forms.LinkLabel]$CONFIGFILEPATH_LINK_LABEL = $null
[System.Windows.Forms.Button]$IMPORT_CONFIG_BUTTON = $null
[System.Windows.Forms.CheckBox]$MORE_LAUNCH_TEXTBOX = $null
[System.Windows.Forms.CheckBox]$STOFFICE_LAUNCH_CHECKBOX = $null
[System.Windows.Forms.Label]$MISCINSTALL_CONFIG_TITLE_LABEL = $null
[System.Windows.Forms.CheckBox]$VLC_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$ZOOM_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$STEAM_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$DISCORD_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$MACRIUM_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$7ZIP_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$ACROBAT_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$WINRAR_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$FIREFOX_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$GOOGLE_INSTALL_CHECKBOX = $null
[System.Windows.Forms.Label]$INSTALL_CONFIG_TITLE_LABEL = $null
[System.Windows.Forms.Button]$CONFIG_START_BUTTON = $null
[System.Windows.Forms.TabPage]$APP_TAB = $null
[System.Windows.Forms.Label]$VERSION_LABEL = $null
[System.Windows.Forms.Label]$VERSION_NUMBER_LABEL = $null
function InitializeComponent
{
$SIDE_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$PC_RAM_FREQUENCY_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_RAM_GBCOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$RAM_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_GPU_MODEL_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$GPU_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_BOARD_MODEL_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_BOARD_BRANDNAME_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$BOARD_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PC_CPU_NAME_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$CPU_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SYSTEMINFO_LINK_LABEL = (New-Object -TypeName System.Windows.Forms.LinkLabel)
$SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$MAIN_TAB_CONTROL = (New-Object -TypeName System.Windows.Forms.TabControl)
$CONFIG_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$CONFIG_START_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$APP_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$VERSION_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$VERSION_NUMBER_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$INSTALL_CONFIG_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$GOOGLE_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$FIREFOX_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$WINRAR_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$ACROBAT_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$7ZIP_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$MACRIUM_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DISCORD_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$STEAM_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$ZOOM_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$VLC_INSTALL_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$MISCINSTALL_CONFIG_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$STOFFICE_LAUNCH_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$MORE_LAUNCH_TEXTBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$IMPORT_CONFIG_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$CONFIGFILEPATH_LINK_LABEL = (New-Object -TypeName System.Windows.Forms.LinkLabel)
$SETTINGS_CONFIG_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
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
#PC_RAM_FREQUENCY_LABEL
#
$PC_RAM_FREQUENCY_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75))
$PC_RAM_FREQUENCY_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]222))
$PC_RAM_FREQUENCY_LABEL.Name = [System.String]'PC_RAM_FREQUENCY_LABEL'
$PC_RAM_FREQUENCY_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]17))
$PC_RAM_FREQUENCY_LABEL.TabIndex = [System.Int32]11
$PC_RAM_FREQUENCY_LABEL.Text = [System.String]'UNKNOWN'
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
#RAM_LABEL
#
$RAM_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Black',[System.Single]9,[System.Drawing.FontStyle]::Bold))
$RAM_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]188))
$RAM_LABEL.Name = [System.String]'RAM_LABEL'
$RAM_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]16))
$RAM_LABEL.TabIndex = [System.Int32]9
$RAM_LABEL.Text = [System.String]'RAM:'
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
#PC_BOARD_BRANDNAME_LABEL
#
$PC_BOARD_BRANDNAME_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PC_BOARD_BRANDNAME_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]95))
$PC_BOARD_BRANDNAME_LABEL.Name = [System.String]'PC_BOARD_BRANDNAME_LABEL'
$PC_BOARD_BRANDNAME_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]17))
$PC_BOARD_BRANDNAME_LABEL.TabIndex = [System.Int32]5
$PC_BOARD_BRANDNAME_LABEL.Text = [System.String]'UNKNOWN'
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
#PC_CPU_NAME_LABEL
#
$PC_CPU_NAME_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PC_CPU_NAME_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]40))
$PC_CPU_NAME_LABEL.Name = [System.String]'PC_CPU_NAME_LABEL'
$PC_CPU_NAME_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]39))
$PC_CPU_NAME_LABEL.TabIndex = [System.Int32]3
$PC_CPU_NAME_LABEL.Text = [System.String]'UNKNOWN'
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
#SETTINGS_BUTTON
#
$SETTINGS_BUTTON.BackColor = [System.Drawing.Color]::Silver
$SETTINGS_BUTTON.FlatAppearance.BorderColor = [System.Drawing.Color]::Silver
$SETTINGS_BUTTON.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)))

$SETTINGS_BUTTON.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)),([System.Int32]([System.Byte][System.Byte]224)))

$SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$SETTINGS_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]272))
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
$CONFIG_TAB.Controls.Add($SETTINGS_CONFIG_TITLE_LABEL)
$CONFIG_TAB.Controls.Add($CONFIGFILEPATH_LINK_LABEL)
$CONFIG_TAB.Controls.Add($IMPORT_CONFIG_BUTTON)
$CONFIG_TAB.Controls.Add($MORE_LAUNCH_TEXTBOX)
$CONFIG_TAB.Controls.Add($STOFFICE_LAUNCH_CHECKBOX)
$CONFIG_TAB.Controls.Add($MISCINSTALL_CONFIG_TITLE_LABEL)
$CONFIG_TAB.Controls.Add($VLC_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($ZOOM_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($STEAM_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($DISCORD_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($MACRIUM_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($7ZIP_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($ACROBAT_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($WINRAR_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($FIREFOX_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($GOOGLE_INSTALL_CHECKBOX)
$CONFIG_TAB.Controls.Add($INSTALL_CONFIG_TITLE_LABEL)
$CONFIG_TAB.Controls.Add($CONFIG_START_BUTTON)
$CONFIG_TAB.ForeColor = [System.Drawing.SystemColors]::ControlText
$CONFIG_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$CONFIG_TAB.Name = [System.String]'CONFIG_TAB'
$CONFIG_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$CONFIG_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]428,[System.Int32]273))
$CONFIG_TAB.TabIndex = [System.Int32]0
$CONFIG_TAB.Text = [System.String]'Configuration'
#
#CONFIG_START_BUTTON
#
$CONFIG_START_BUTTON.BackColor = [System.Drawing.Color]::Silver
$CONFIG_START_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$CONFIG_START_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$CONFIG_START_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]335,[System.Int32]244))
$CONFIG_START_BUTTON.Name = [System.String]'CONFIG_START_BUTTON'
$CONFIG_START_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]26))
$CONFIG_START_BUTTON.TabIndex = [System.Int32]0
$CONFIG_START_BUTTON.Text = [System.String]'Start'
$CONFIG_START_BUTTON.UseVisualStyleBackColor = $false
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
#INSTALL_CONFIG_TITLE_LABEL
#
$INSTALL_CONFIG_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Semibold',[System.Single]10,[System.Drawing.FontStyle]::Bold))
$INSTALL_CONFIG_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$INSTALL_CONFIG_TITLE_LABEL.Name = [System.String]'INSTALL_CONFIG_TITLE_LABEL'
$INSTALL_CONFIG_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]53,[System.Int32]20))
$INSTALL_CONFIG_TITLE_LABEL.TabIndex = [System.Int32]1
$INSTALL_CONFIG_TITLE_LABEL.Text = [System.String]'Install:'
#
#GOOGLE_INSTALL_CHECKBOX
#
$GOOGLE_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$GOOGLE_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]26))
$GOOGLE_INSTALL_CHECKBOX.Name = [System.String]'GOOGLE_INSTALL_CHECKBOX'
$GOOGLE_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]18))
$GOOGLE_INSTALL_CHECKBOX.TabIndex = [System.Int32]2
$GOOGLE_INSTALL_CHECKBOX.Text = [System.String]'Google Chrome'
$GOOGLE_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#FIREFOX_INSTALL_CHECKBOX
#
$FIREFOX_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$FIREFOX_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]42))
$FIREFOX_INSTALL_CHECKBOX.Name = [System.String]'FIREFOX_INSTALL_CHECKBOX'
$FIREFOX_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]21))
$FIREFOX_INSTALL_CHECKBOX.TabIndex = [System.Int32]3
$FIREFOX_INSTALL_CHECKBOX.Text = [System.String]'Firefox'
$FIREFOX_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
$FIREFOX_INSTALL_CHECKBOX.add_CheckedChanged($FIREFOX_INSTALL_CHECKBOX_CheckedChanged)
#
#WINRAR_INSTALL_CHECKBOX
#
$WINRAR_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$WINRAR_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]78))
$WINRAR_INSTALL_CHECKBOX.Name = [System.String]'WINRAR_INSTALL_CHECKBOX'
$WINRAR_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]18))
$WINRAR_INSTALL_CHECKBOX.TabIndex = [System.Int32]4
$WINRAR_INSTALL_CHECKBOX.Text = [System.String]'Winrar'
$WINRAR_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#ACROBAT_INSTALL_CHECKBOX
#
$ACROBAT_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$ACROBAT_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]61))
$ACROBAT_INSTALL_CHECKBOX.Name = [System.String]'ACROBAT_INSTALL_CHECKBOX'
$ACROBAT_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]16))
$ACROBAT_INSTALL_CHECKBOX.TabIndex = [System.Int32]5
$ACROBAT_INSTALL_CHECKBOX.Text = [System.String]'Acrobat Reader'
$ACROBAT_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
$ACROBAT_INSTALL_CHECKBOX.add_CheckedChanged($CheckBox2_CheckedChanged)
#
#7-ZIP_INSTALL_CHECKBOX
#
$7ZIP_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$7ZIP_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]97))
$7ZIP_INSTALL_CHECKBOX.Name = [System.String]'7-ZIP_INSTALL_CHECKBOX'
$7ZIP_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]16))
$7ZIP_INSTALL_CHECKBOX.TabIndex = [System.Int32]6
$7ZIP_INSTALL_CHECKBOX.Text = [System.String]'7-Zip'
$7ZIP_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#MACRIUM_INSTALL_CHECKBOX
#
$MACRIUM_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$MACRIUM_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]114))
$MACRIUM_INSTALL_CHECKBOX.Name = [System.String]'MACRIUM_INSTALL_CHECKBOX'
$MACRIUM_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]17))
$MACRIUM_INSTALL_CHECKBOX.TabIndex = [System.Int32]7
$MACRIUM_INSTALL_CHECKBOX.Text = [System.String]'Macrium Reflect'
$MACRIUM_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#DISCORD_INSTALL_CHECKBOX
#
$DISCORD_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$DISCORD_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]131))
$DISCORD_INSTALL_CHECKBOX.Name = [System.String]'DISCORD_INSTALL_CHECKBOX'
$DISCORD_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]17))
$DISCORD_INSTALL_CHECKBOX.TabIndex = [System.Int32]8
$DISCORD_INSTALL_CHECKBOX.Text = [System.String]'Discord'
$DISCORD_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#STEAM_INSTALL_CHECKBOX
#
$STEAM_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$STEAM_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]147))
$STEAM_INSTALL_CHECKBOX.Name = [System.String]'STEAM_INSTALL_CHECKBOX'
$STEAM_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]19))
$STEAM_INSTALL_CHECKBOX.TabIndex = [System.Int32]9
$STEAM_INSTALL_CHECKBOX.Text = [System.String]'Steam'
$STEAM_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#ZOOM_INSTALL_CHECKBOX
#
$ZOOM_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$ZOOM_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]164))
$ZOOM_INSTALL_CHECKBOX.Name = [System.String]'ZOOM_INSTALL_CHECKBOX'
$ZOOM_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]16))
$ZOOM_INSTALL_CHECKBOX.TabIndex = [System.Int32]10
$ZOOM_INSTALL_CHECKBOX.Text = [System.String]'Zoom'
$ZOOM_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#VLC_INSTALL_CHECKBOX
#
$VLC_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$VLC_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]180))
$VLC_INSTALL_CHECKBOX.Name = [System.String]'VLC_INSTALL_CHECKBOX'
$VLC_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]18))
$VLC_INSTALL_CHECKBOX.TabIndex = [System.Int32]11
$VLC_INSTALL_CHECKBOX.Text = [System.String]'VLC'
$VLC_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#MISCINSTALL_CONFIG_TITLE_LABEL
#
$MISCINSTALL_CONFIG_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Semibold',[System.Single]10,[System.Drawing.FontStyle]::Bold))
$MISCINSTALL_CONFIG_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]198))
$MISCINSTALL_CONFIG_TITLE_LABEL.Name = [System.String]'MISCINSTALL_CONFIG_TITLE_LABEL'
$MISCINSTALL_CONFIG_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]87,[System.Int32]17))
$MISCINSTALL_CONFIG_TITLE_LABEL.TabIndex = [System.Int32]12
$MISCINSTALL_CONFIG_TITLE_LABEL.Text = [System.String]'Misc Install:'
#
#STOFFICE_LAUNCH_CHECKBOX
#
$STOFFICE_LAUNCH_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$STOFFICE_LAUNCH_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]218))
$STOFFICE_LAUNCH_CHECKBOX.Name = [System.String]'STOFFICE_LAUNCH_CHECKBOX'
$STOFFICE_LAUNCH_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]110,[System.Int32]19))
$STOFFICE_LAUNCH_CHECKBOX.TabIndex = [System.Int32]13
$STOFFICE_LAUNCH_CHECKBOX.Text = [System.String]'Office/LibreOffice'
$STOFFICE_LAUNCH_CHECKBOX.UseVisualStyleBackColor = $true
$STOFFICE_LAUNCH_CHECKBOX.add_CheckedChanged($STOFFICE_LAUNCH_CHECKBOX_CheckedChanged)
#
#MORE_LAUNCH_TEXTBOX
#
$MORE_LAUNCH_TEXTBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$MORE_LAUNCH_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]234))
$MORE_LAUNCH_TEXTBOX.Name = [System.String]'MORE_LAUNCH_TEXTBOX'
$MORE_LAUNCH_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]104,[System.Int32]19))
$MORE_LAUNCH_TEXTBOX.TabIndex = [System.Int32]14
$MORE_LAUNCH_TEXTBOX.Text = [System.String]'More...'
$MORE_LAUNCH_TEXTBOX.UseVisualStyleBackColor = $true
#
#IMPORT_CONFIG_BUTTON
#
$IMPORT_CONFIG_BUTTON.BackColor = [System.Drawing.Color]::Silver
$IMPORT_CONFIG_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$IMPORT_CONFIG_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$IMPORT_CONFIG_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]268,[System.Int32]250))
$IMPORT_CONFIG_BUTTON.Name = [System.String]'IMPORT_CONFIG_BUTTON'
$IMPORT_CONFIG_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]20))
$IMPORT_CONFIG_BUTTON.TabIndex = [System.Int32]15
$IMPORT_CONFIG_BUTTON.Text = [System.String]'Import...'
$IMPORT_CONFIG_BUTTON.UseVisualStyleBackColor = $false
#
#CONFIGFILEPATH_LINK_LABEL
#
$CONFIGFILEPATH_LINK_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$CONFIGFILEPATH_LINK_LABEL.LinkColor = [System.Drawing.Color]::Navy
$CONFIGFILEPATH_LINK_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]254))
$CONFIGFILEPATH_LINK_LABEL.Name = [System.String]'CONFIGFILEPATH_LINK_LABEL'
$CONFIGFILEPATH_LINK_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]259,[System.Int32]15))
$CONFIGFILEPATH_LINK_LABEL.TabIndex = [System.Int32]16
$CONFIGFILEPATH_LINK_LABEL.TabStop = $true
$CONFIGFILEPATH_LINK_LABEL.Text = [System.String]'PATH TO CONFIG FILE LOCATION'
$CONFIGFILEPATH_LINK_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
#
#SETTINGS_CONFIG_TITLE_LABEL
#
$SETTINGS_CONFIG_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Semibold',[System.Single]10,[System.Drawing.FontStyle]::Bold))
$SETTINGS_CONFIG_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]129,[System.Int32]3))
$SETTINGS_CONFIG_TITLE_LABEL.Name = [System.String]'SETTINGS_CONFIG_TITLE_LABEL'
$SETTINGS_CONFIG_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]68,[System.Int32]20))
$SETTINGS_CONFIG_TITLE_LABEL.TabIndex = [System.Int32]17
$SETTINGS_CONFIG_TITLE_LABEL.Text = [System.String]'Settings:'
$SETTINGS_CONFIG_TITLE_LABEL.add_Click($Label1_Click)
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
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_CONFIG_TITLE_LABEL -Value $SETTINGS_CONFIG_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIGFILEPATH_LINK_LABEL -Value $CONFIGFILEPATH_LINK_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name IMPORT_CONFIG_BUTTON -Value $IMPORT_CONFIG_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MORE_LAUNCH_TEXTBOX -Value $MORE_LAUNCH_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name STOFFICE_LAUNCH_CHECKBOX -Value $STOFFICE_LAUNCH_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MISCINSTALL_CONFIG_TITLE_LABEL -Value $MISCINSTALL_CONFIG_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VLC_INSTALL_CHECKBOX -Value $VLC_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name ZOOM_INSTALL_CHECKBOX -Value $ZOOM_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name STEAM_INSTALL_CHECKBOX -Value $STEAM_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name DISCORD_INSTALL_CHECKBOX -Value $DISCORD_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MACRIUM_INSTALL_CHECKBOX -Value $MACRIUM_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name 7-ZIP_INSTALL_CHECKBOX -Value $7-ZIP_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name ACROBAT_INSTALL_CHECKBOX -Value $ACROBAT_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name WINRAR_INSTALL_CHECKBOX -Value $WINRAR_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name FIREFOX_INSTALL_CHECKBOX -Value $FIREFOX_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name GOOGLE_INSTALL_CHECKBOX -Value $GOOGLE_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name INSTALL_CONFIG_TITLE_LABEL -Value $INSTALL_CONFIG_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_START_BUTTON -Value $CONFIG_START_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_TAB -Value $APP_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_LABEL -Value $VERSION_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_NUMBER_LABEL -Value $VERSION_NUMBER_LABEL -MemberType NoteProperty
}
. InitializeComponent
