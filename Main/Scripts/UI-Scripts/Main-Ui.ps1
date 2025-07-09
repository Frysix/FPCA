$MAIN_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$SIDE_PANNEL = $null
[System.Windows.Forms.Label]$INTERNET_TITLE_LABEL = $null
[System.Windows.Forms.Label]$CONNECTION_TITLE_LABEL = $null
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
[System.Windows.Forms.Panel]$CUSTOMCONFIG_CONTROL_PANEL = $null
[System.Windows.Forms.CheckBox]$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX = $null
[System.Windows.Forms.Panel]$PROFILECONFIG_PANEL = $null
[System.Windows.Forms.Panel]$CUSTOM_CONFIG_PANEL = $null
[System.Windows.Forms.Panel]$DEFAULT_CONFIG_PANEL = $null
[System.Windows.Forms.Panel]$DEFAULTCONFIG_CONTROL_PANEL = $null
[System.Windows.Forms.Button]$CONFIG_START_BUTTON = $null
[System.Windows.Forms.TabPage]$APP_TAB = $null
[System.Windows.Forms.RichTextBox]$APP_LOG_TEXTBOX = $null
[System.Windows.Forms.CheckBox]$AUTOREFRESH_APP_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$USECUSTOM_APP_CHECKBOX = $null
[System.Windows.Forms.Button]$REFRESH_APP_BUTTON = $null
[System.Windows.Forms.Panel]$MODULAR_APP_PANEL = $null
[System.Windows.Forms.TabPage]$TOOLS_TAB = $null
[System.Windows.Forms.TabPage]$INFO_TAB = $null
[System.Windows.Forms.Label]$VERSION_LABEL = $null
[System.Windows.Forms.Label]$VERSION_NUMBER_LABEL = $null
function InitializeComponent
{
$SIDE_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$INTERNET_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$CONNECTION_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
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
$CUSTOM_CONFIG_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$DEFAULT_CONFIG_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$DEFAULTCONFIG_CONTROL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$CONFIG_START_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$APP_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$APP_LOG_TEXTBOX = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$AUTOREFRESH_APP_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$USECUSTOM_APP_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$REFRESH_APP_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$MODULAR_APP_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TOOLS_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$INFO_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$VERSION_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$VERSION_NUMBER_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PROFILECONFIG_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$CUSTOMCONFIG_CONTROL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SIDE_PANNEL.SuspendLayout()
$MAIN_TAB_CONTROL.SuspendLayout()
$CONFIG_TAB.SuspendLayout()
$APP_TAB.SuspendLayout()
$CUSTOMCONFIG_CONTROL_PANEL.SuspendLayout()
$MAIN_FORM.SuspendLayout()
#
#SIDE_PANNEL
#
$SIDE_PANNEL.BackColor = [System.Drawing.Color]::Gray
$SIDE_PANNEL.Controls.Add($INTERNET_TITLE_LABEL)
$SIDE_PANNEL.Controls.Add($CONNECTION_TITLE_LABEL)
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
$SIDE_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]92,[System.Int32]467))
$SIDE_PANNEL.TabIndex = [System.Int32]1
#
#INTERNET_TITLE_LABEL
#
$INTERNET_TITLE_LABEL.BackColor = [System.Drawing.Color]::Transparent
$INTERNET_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Black',[System.Single]9,[System.Drawing.FontStyle]::Bold))
$INTERNET_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]242))
$INTERNET_TITLE_LABEL.Name = [System.String]'INTERNET_TITLE_LABEL'
$INTERNET_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]78,[System.Int32]16))
$INTERNET_TITLE_LABEL.TabIndex = [System.Int32]12
$INTERNET_TITLE_LABEL.Text = [System.String]'Internet:'
#
#CONNECTION_TITLE_LABEL
#
$CONNECTION_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9))
$CONNECTION_TITLE_LABEL.ForeColor = [System.Drawing.Color]::Red
$CONNECTION_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]258))
$CONNECTION_TITLE_LABEL.Name = [System.String]'CONNECTION_TITLE_LABEL'
$CONNECTION_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]19))
$CONNECTION_TITLE_LABEL.TabIndex = [System.Int32]4
$CONNECTION_TITLE_LABEL.Text = [System.String]'Disconnected'
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
$PC_BOARD_MODEL_LABEL.BackColor = [System.Drawing.Color]::Transparent
$PC_BOARD_MODEL_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PC_BOARD_MODEL_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]117))
$PC_BOARD_MODEL_LABEL.Name = [System.String]'PC_BOARD_MODEL_LABEL'
$PC_BOARD_MODEL_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]26))
$PC_BOARD_MODEL_LABEL.TabIndex = [System.Int32]6
$PC_BOARD_MODEL_LABEL.Text = [System.String]'UNKNOWN'
$PC_BOARD_MODEL_LABEL.add_Click($PC_BOARD_MODEL_LABEL_Click)
#
#PC_BOARD_BRANDNAME_LABEL
#
$PC_BOARD_BRANDNAME_LABEL.BackColor = [System.Drawing.Color]::Transparent
$PC_BOARD_BRANDNAME_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]6.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PC_BOARD_BRANDNAME_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]95))
$PC_BOARD_BRANDNAME_LABEL.Name = [System.String]'PC_BOARD_BRANDNAME_LABEL'
$PC_BOARD_BRANDNAME_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]86,[System.Int32]25))
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
$SYSTEMINFO_LINK_LABEL.ActiveLinkColor = [System.Drawing.Color]::White
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
$SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]437))
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
$MAIN_TAB_CONTROL.Controls.Add($TOOLS_TAB)
$MAIN_TAB_CONTROL.Controls.Add($INFO_TAB)
$MAIN_TAB_CONTROL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$MAIN_TAB_CONTROL.HotTrack = $true
$MAIN_TAB_CONTROL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]12))
$MAIN_TAB_CONTROL.Name = [System.String]'MAIN_TAB_CONTROL'
$MAIN_TAB_CONTROL.SelectedIndex = [System.Int32]0
$MAIN_TAB_CONTROL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]641,[System.Int32]467))
$MAIN_TAB_CONTROL.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
$MAIN_TAB_CONTROL.TabIndex = [System.Int32]3
#
#CONFIG_TAB
#
$CONFIG_TAB.BackColor = [System.Drawing.Color]::Gray
$CONFIG_TAB.Controls.Add($CUSTOMCONFIG_CONTROL_PANEL)
$CONFIG_TAB.Controls.Add($PROFILECONFIG_PANEL)
$CONFIG_TAB.Controls.Add($CUSTOM_CONFIG_PANEL)
$CONFIG_TAB.Controls.Add($DEFAULT_CONFIG_PANEL)
$CONFIG_TAB.Controls.Add($DEFAULTCONFIG_CONTROL_PANEL)
$CONFIG_TAB.Controls.Add($CONFIG_START_BUTTON)
$CONFIG_TAB.ForeColor = [System.Drawing.SystemColors]::ControlText
$CONFIG_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$CONFIG_TAB.Name = [System.String]'CONFIG_TAB'
$CONFIG_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$CONFIG_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$CONFIG_TAB.TabIndex = [System.Int32]0
$CONFIG_TAB.Text = [System.String]'Configuration'
#
#CUSTOM_CONFIG_PANEL
#
$CUSTOM_CONFIG_PANEL.AutoScroll = $true
$CUSTOM_CONFIG_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$CUSTOM_CONFIG_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CUSTOM_CONFIG_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]262,[System.Int32]6))
$CUSTOM_CONFIG_PANEL.Name = [System.String]'CUSTOM_CONFIG_PANEL'
$CUSTOM_CONFIG_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]394))
$CUSTOM_CONFIG_PANEL.TabIndex = [System.Int32]29
#
#DEFAULT_CONFIG_PANEL
#
$DEFAULT_CONFIG_PANEL.AutoScroll = $true
$DEFAULT_CONFIG_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$DEFAULT_CONFIG_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$DEFAULT_CONFIG_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]6))
$DEFAULT_CONFIG_PANEL.Name = [System.String]'DEFAULT_CONFIG_PANEL'
$DEFAULT_CONFIG_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]394))
$DEFAULT_CONFIG_PANEL.TabIndex = [System.Int32]28
#
#AUTOREFRESH_CUSTOMCONFIG_CHECKBOX
#
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]165,[System.Int32]3))
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Name = [System.String]'AUTOREFRESH_CUSTOMCONFIG_CHECKBOX'
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]80,[System.Int32]21))
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.TabIndex = [System.Int32]26
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Text = [System.String]'Auto Refresh'
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.UseVisualStyleBackColor = $true
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.add_CheckedChanged($AUTOREFRESH_CUSTOMCONFIG_CHECKBOX_CheckedChanged)
#
#DEFAULTCONFIG_CONTROL_PANEL
#
$DEFAULTCONFIG_CONTROL_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$DEFAULTCONFIG_CONTROL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$DEFAULTCONFIG_CONTROL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]406))
$DEFAULTCONFIG_CONTROL_PANEL.Name = [System.String]'DEFAULTCONFIG_CONTROL_PANEL'
$DEFAULTCONFIG_CONTROL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]27))
$DEFAULTCONFIG_CONTROL_PANEL.TabIndex = [System.Int32]24
#
#CONFIG_START_BUTTON
#
$CONFIG_START_BUTTON.BackColor = [System.Drawing.Color]::Silver
$CONFIG_START_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$CONFIG_START_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CONFIG_START_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]518,[System.Int32]406))
$CONFIG_START_BUTTON.Name = [System.String]'CONFIG_START_BUTTON'
$CONFIG_START_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]109,[System.Int32]27))
$CONFIG_START_BUTTON.TabIndex = [System.Int32]0
$CONFIG_START_BUTTON.Text = [System.String]'Start'
$CONFIG_START_BUTTON.UseVisualStyleBackColor = $false
$CONFIG_START_BUTTON.add_Click($CONFIG_START_BUTTON_Click)
#
#APP_TAB
#
$APP_TAB.BackColor = [System.Drawing.Color]::Gray
$APP_TAB.Controls.Add($APP_LOG_TEXTBOX)
$APP_TAB.Controls.Add($AUTOREFRESH_APP_CHECKBOX)
$APP_TAB.Controls.Add($USECUSTOM_APP_CHECKBOX)
$APP_TAB.Controls.Add($REFRESH_APP_BUTTON)
$APP_TAB.Controls.Add($MODULAR_APP_PANEL)
$APP_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$APP_TAB.Name = [System.String]'APP_TAB'
$APP_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$APP_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$APP_TAB.TabIndex = [System.Int32]1
$APP_TAB.Text = [System.String]'App'
#
#APP_LOG_TEXTBOX
#
$APP_LOG_TEXTBOX.BackColor = [System.Drawing.Color]::DarkGray
$APP_LOG_TEXTBOX.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$APP_LOG_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]448,[System.Int32]6))
$APP_LOG_TEXTBOX.Name = [System.String]'APP_LOG_TEXTBOX'
$APP_LOG_TEXTBOX.ReadOnly = $true
$APP_LOG_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]179,[System.Int32]231))
$APP_LOG_TEXTBOX.TabIndex = [System.Int32]4
$APP_LOG_TEXTBOX.Text = [System.String]''
#
#AUTOREFRESH_APP_CHECKBOX
#
$AUTOREFRESH_APP_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$AUTOREFRESH_APP_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]537,[System.Int32]385))
$AUTOREFRESH_APP_CHECKBOX.Name = [System.String]'AUTOREFRESH_APP_CHECKBOX'
$AUTOREFRESH_APP_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]16))
$AUTOREFRESH_APP_CHECKBOX.TabIndex = [System.Int32]3
$AUTOREFRESH_APP_CHECKBOX.Text = [System.String]'Auto Refresh'
$AUTOREFRESH_APP_CHECKBOX.UseVisualStyleBackColor = $true
#
#USECUSTOM_APP_CHECKBOX
#
$USECUSTOM_APP_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$USECUSTOM_APP_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]537,[System.Int32]363))
$USECUSTOM_APP_CHECKBOX.Name = [System.String]'USECUSTOM_APP_CHECKBOX'
$USECUSTOM_APP_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]16))
$USECUSTOM_APP_CHECKBOX.TabIndex = [System.Int32]2
$USECUSTOM_APP_CHECKBOX.Text = [System.String]'Use Custom'
$USECUSTOM_APP_CHECKBOX.UseVisualStyleBackColor = $true
$USECUSTOM_APP_CHECKBOX.add_CheckedChanged($USECUSTOM_APP_CHECKBOX_CheckedChanged)
#
#REFRESH_APP_BUTTON
#
$REFRESH_APP_BUTTON.BackColor = [System.Drawing.Color]::Silver
$REFRESH_APP_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$REFRESH_APP_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$REFRESH_APP_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]537,[System.Int32]407))
$REFRESH_APP_BUTTON.Name = [System.String]'REFRESH_APP_BUTTON'
$REFRESH_APP_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]26))
$REFRESH_APP_BUTTON.TabIndex = [System.Int32]1
$REFRESH_APP_BUTTON.Text = [System.String]'Refresh'
$REFRESH_APP_BUTTON.UseVisualStyleBackColor = $false
$REFRESH_APP_BUTTON.add_Click($REFRESH_APP_BUTTON_Click)
#
#MODULAR_APP_PANEL
#
$MODULAR_APP_PANEL.AutoScroll = $true
$MODULAR_APP_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MODULAR_APP_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MODULAR_APP_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$MODULAR_APP_PANEL.Name = [System.String]'MODULAR_APP_PANEL'
$MODULAR_APP_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]345,[System.Int32]433))
$MODULAR_APP_PANEL.TabIndex = [System.Int32]0
#
#TOOLS_TAB
#
$TOOLS_TAB.BackColor = [System.Drawing.Color]::Gray
$TOOLS_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$TOOLS_TAB.Name = [System.String]'TOOLS_TAB'
$TOOLS_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$TOOLS_TAB.TabIndex = [System.Int32]2
$TOOLS_TAB.Text = [System.String]'Tools'
#
#INFO_TAB
#
$INFO_TAB.BackColor = [System.Drawing.Color]::Gray
$INFO_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$INFO_TAB.Name = [System.String]'INFO_TAB'
$INFO_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]536,[System.Int32]313))
$INFO_TAB.TabIndex = [System.Int32]3
$INFO_TAB.Text = [System.String]'Info'
#
#VERSION_LABEL
#
$VERSION_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$VERSION_LABEL.ForeColor = [System.Drawing.Color]::White
$VERSION_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]673,[System.Int32]8))
$VERSION_LABEL.Name = [System.String]'VERSION_LABEL'
$VERSION_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]57,[System.Int32]25))
$VERSION_LABEL.TabIndex = [System.Int32]3
$VERSION_LABEL.Text = [System.String]'Version:'
$VERSION_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$VERSION_LABEL.add_Click($VERSION_LABEL_Click)
#
#VERSION_NUMBER_LABEL
#
$VERSION_NUMBER_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$VERSION_NUMBER_LABEL.ForeColor = [System.Drawing.Color]::White
$VERSION_NUMBER_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]722,[System.Int32]8))
$VERSION_NUMBER_LABEL.Name = [System.String]'VERSION_NUMBER_LABEL'
$VERSION_NUMBER_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]29,[System.Int32]25))
$VERSION_NUMBER_LABEL.TabIndex = [System.Int32]0
$VERSION_NUMBER_LABEL.Text = [System.String]'0.0'
$VERSION_NUMBER_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#PROFILECONFIG_PANEL
#
$PROFILECONFIG_PANEL.AutoScroll = $true
$PROFILECONFIG_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$PROFILECONFIG_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$PROFILECONFIG_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]518,[System.Int32]6))
$PROFILECONFIG_PANEL.Name = [System.String]'PROFILECONFIG_PANEL'
$PROFILECONFIG_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]109,[System.Int32]394))
$PROFILECONFIG_PANEL.TabIndex = [System.Int32]30
#
#CUSTOMCONFIG_CONTROL_PANEL
#
$CUSTOMCONFIG_CONTROL_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$CUSTOMCONFIG_CONTROL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CUSTOMCONFIG_CONTROL_PANEL.Controls.Add($AUTOREFRESH_CUSTOMCONFIG_CHECKBOX)
$CUSTOMCONFIG_CONTROL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]262,[System.Int32]406))
$CUSTOMCONFIG_CONTROL_PANEL.Name = [System.String]'CUSTOMCONFIG_CONTROL_PANEL'
$CUSTOMCONFIG_CONTROL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]27))
$CUSTOMCONFIG_CONTROL_PANEL.TabIndex = [System.Int32]31
$CUSTOMCONFIG_CONTROL_PANEL.add_Paint($CUSTOMCONFIG_CONTROL_PANEL_Paint)
#
#MAIN_FORM
#
$MAIN_FORM.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None
$MAIN_FORM.AutoValidate = [System.Windows.Forms.AutoValidate]::EnablePreventFocusChange
$MAIN_FORM.BackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)))

$MAIN_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]763,[System.Int32]491))
$MAIN_FORM.Controls.Add($VERSION_NUMBER_LABEL)
$MAIN_FORM.Controls.Add($VERSION_LABEL)
$MAIN_FORM.Controls.Add($MAIN_TAB_CONTROL)
$MAIN_FORM.Controls.Add($SIDE_PANNEL)
$MAIN_FORM.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$MAIN_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$MAIN_FORM.MaximizeBox = $false
$MAIN_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MAIN_FORM.Text = [System.String]'Main - FPCA - (Frysix''s Powershell Configurator App)'
$MAIN_FORM.TopMost = $true
$SIDE_PANNEL.ResumeLayout($false)
$MAIN_TAB_CONTROL.ResumeLayout($false)
$CONFIG_TAB.ResumeLayout($false)
$APP_TAB.ResumeLayout($false)
$CUSTOMCONFIG_CONTROL_PANEL.ResumeLayout($false)
$MAIN_FORM.ResumeLayout($false)
Add-Member -InputObject $MAIN_FORM -Name SIDE_PANNEL -Value $SIDE_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name INTERNET_TITLE_LABEL -Value $INTERNET_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONNECTION_TITLE_LABEL -Value $CONNECTION_TITLE_LABEL -MemberType NoteProperty
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
Add-Member -InputObject $MAIN_FORM -Name CUSTOMCONFIG_CONTROL_PANEL -Value $CUSTOMCONFIG_CONTROL_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name AUTOREFRESH_CUSTOMCONFIG_CHECKBOX -Value $AUTOREFRESH_CUSTOMCONFIG_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name PROFILECONFIG_PANEL -Value $PROFILECONFIG_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CUSTOM_CONFIG_PANEL -Value $CUSTOM_CONFIG_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name DEFAULT_CONFIG_PANEL -Value $DEFAULT_CONFIG_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name DEFAULTCONFIG_CONTROL_PANEL -Value $DEFAULTCONFIG_CONTROL_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_START_BUTTON -Value $CONFIG_START_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_TAB -Value $APP_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_LOG_TEXTBOX -Value $APP_LOG_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name AUTOREFRESH_APP_CHECKBOX -Value $AUTOREFRESH_APP_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name USECUSTOM_APP_CHECKBOX -Value $USECUSTOM_APP_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name REFRESH_APP_BUTTON -Value $REFRESH_APP_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MODULAR_APP_PANEL -Value $MODULAR_APP_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TOOLS_TAB -Value $TOOLS_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name INFO_TAB -Value $INFO_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_LABEL -Value $VERSION_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_NUMBER_LABEL -Value $VERSION_NUMBER_LABEL -MemberType NoteProperty
}
. InitializeComponent
