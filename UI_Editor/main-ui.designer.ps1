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
[System.Windows.Forms.TabControl]$MAIN_TAB_CONTROL = $null
[System.Windows.Forms.TabPage]$CONFIG_TAB = $null
[System.Windows.Forms.Panel]$CONFIG_START_BUTTON_PANEL = $null
[System.Windows.Forms.Button]$CONFIG_START_BUTTON = $null
[System.Windows.Forms.Panel]$MAIN_CONFIGMOD_PANEL = $null
[System.Windows.Forms.Panel]$SCROLL_CONFIGMOD_PANEL = $null
[System.Windows.Forms.Panel]$TITLE_CONFIGMOD_PANEL = $null
[System.Windows.Forms.Label]$TITLE_AVAILCONFIGSMOD_LABEL = $null
[System.Windows.Forms.Panel]$MAIN_CONFIG_PANEL = $null
[System.Windows.Forms.Panel]$TITLE_CONFIGTAB_PANEL = $null
[System.Windows.Forms.Label]$TITLE_AVAILCONFIGS_LABEL = $null
[System.Windows.Forms.Panel]$SCROLL_CONFIG_PANEL = $null
[System.Windows.Forms.TabPage]$APP_TAB = $null
[System.Windows.Forms.Panel]$MAIN_APP_PANEL = $null
[System.Windows.Forms.Panel]$SCROLL_APP_PANEL = $null
[System.Windows.Forms.Panel]$TITLE_APPTAB_PANEL = $null
[System.Windows.Forms.Label]$TITLE_AVAILAPPS_LABEL = $null
[System.Windows.Forms.Panel]$MAIN_APPMOD_PANEL = $null
[System.Windows.Forms.Panel]$SCROLL_APPMOD_PANEL = $null
[System.Windows.Forms.Panel]$TITLE_APPMOD_PANEL = $null
[System.Windows.Forms.Label]$TITLE_AVAILAPPSMOD_LABEL = $null
[System.Windows.Forms.TabPage]$TOOLS_TAB = $null
[System.Windows.Forms.Label]$TEMP_COMINGSOON_TOOLS_LABEL = $null
[System.Windows.Forms.TabPage]$MODS_TAB = $null
[System.Windows.Forms.Label]$TEMP_COMINGSOON_MODS_LABEL = $null
[System.Windows.Forms.TabPage]$SETTINGS_TAB = $null
[System.Windows.Forms.Panel]$SETTINGS_PERMABUTTON_BACKPANEL = $null
[System.Windows.Forms.Panel]$SETTINGS_RESULTMESSAGE_BACKPANEL = $null
[System.Windows.Forms.Label]$SETTINGS_OPERATIONRESULT_LABEL = $null
[System.Windows.Forms.Button]$SAVE_SETTINGS_BUTTON = $null
[System.Windows.Forms.Button]$RESET_SETTINGS_BUTTON = $null
[System.Windows.Forms.TabControl]$SETTINGS_TAB_CONTROL = $null
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
$MAIN_TAB_CONTROL = (New-Object -TypeName System.Windows.Forms.TabControl)
$CONFIG_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$CONFIG_START_BUTTON_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$CONFIG_START_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$MAIN_CONFIGMOD_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SCROLL_CONFIGMOD_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_CONFIGMOD_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_AVAILCONFIGSMOD_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_CONFIG_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_CONFIGTAB_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_AVAILCONFIGS_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SCROLL_CONFIG_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$APP_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$MAIN_APP_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SCROLL_APP_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_APPTAB_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_AVAILAPPS_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_APPMOD_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SCROLL_APPMOD_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_APPMOD_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$TITLE_AVAILAPPSMOD_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$TOOLS_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$TEMP_COMINGSOON_TOOLS_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MODS_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$TEMP_COMINGSOON_MODS_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SETTINGS_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$SETTINGS_PERMABUTTON_BACKPANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SAVE_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$RESET_SETTINGS_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$SETTINGS_TAB_CONTROL = (New-Object -TypeName System.Windows.Forms.TabControl)
$VERSION_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$VERSION_NUMBER_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SETTINGS_RESULTMESSAGE_BACKPANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SETTINGS_OPERATIONRESULT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SIDE_PANNEL.SuspendLayout()
$MAIN_TAB_CONTROL.SuspendLayout()
$CONFIG_TAB.SuspendLayout()
$CONFIG_START_BUTTON_PANEL.SuspendLayout()
$MAIN_CONFIGMOD_PANEL.SuspendLayout()
$TITLE_CONFIGMOD_PANEL.SuspendLayout()
$MAIN_CONFIG_PANEL.SuspendLayout()
$TITLE_CONFIGTAB_PANEL.SuspendLayout()
$APP_TAB.SuspendLayout()
$MAIN_APP_PANEL.SuspendLayout()
$TITLE_APPTAB_PANEL.SuspendLayout()
$MAIN_APPMOD_PANEL.SuspendLayout()
$TITLE_APPMOD_PANEL.SuspendLayout()
$TOOLS_TAB.SuspendLayout()
$MODS_TAB.SuspendLayout()
$SETTINGS_TAB.SuspendLayout()
$SETTINGS_PERMABUTTON_BACKPANEL.SuspendLayout()
$SETTINGS_RESULTMESSAGE_BACKPANEL.SuspendLayout()
$MAIN_FORM.SuspendLayout()
#
#SIDE_PANNEL
#
$SIDE_PANNEL.BackColor = [System.Drawing.Color]::Gray
$SIDE_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
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
#MAIN_TAB_CONTROL
#
$MAIN_TAB_CONTROL.Controls.Add($CONFIG_TAB)
$MAIN_TAB_CONTROL.Controls.Add($APP_TAB)
$MAIN_TAB_CONTROL.Controls.Add($TOOLS_TAB)
$MAIN_TAB_CONTROL.Controls.Add($MODS_TAB)
$MAIN_TAB_CONTROL.Controls.Add($SETTINGS_TAB)
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
$CONFIG_TAB.Controls.Add($CONFIG_START_BUTTON_PANEL)
$CONFIG_TAB.Controls.Add($MAIN_CONFIGMOD_PANEL)
$CONFIG_TAB.Controls.Add($MAIN_CONFIG_PANEL)
$CONFIG_TAB.ForeColor = [System.Drawing.SystemColors]::ControlText
$CONFIG_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$CONFIG_TAB.Name = [System.String]'CONFIG_TAB'
$CONFIG_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$CONFIG_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$CONFIG_TAB.TabIndex = [System.Int32]0
$CONFIG_TAB.Text = [System.String]'Configuration'
#
#CONFIG_START_BUTTON_PANEL
#
$CONFIG_START_BUTTON_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$CONFIG_START_BUTTON_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CONFIG_START_BUTTON_PANEL.Controls.Add($CONFIG_START_BUTTON)
$CONFIG_START_BUTTON_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]497,[System.Int32]390))
$CONFIG_START_BUTTON_PANEL.Name = [System.String]'CONFIG_START_BUTTON_PANEL'
$CONFIG_START_BUTTON_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]132,[System.Int32]43))
$CONFIG_START_BUTTON_PANEL.TabIndex = [System.Int32]31
#
#CONFIG_START_BUTTON
#
$CONFIG_START_BUTTON.BackColor = [System.Drawing.Color]::Silver
$CONFIG_START_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$CONFIG_START_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CONFIG_START_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]6))
$CONFIG_START_BUTTON.Name = [System.String]'CONFIG_START_BUTTON'
$CONFIG_START_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]119,[System.Int32]30))
$CONFIG_START_BUTTON.TabIndex = [System.Int32]0
$CONFIG_START_BUTTON.Text = [System.String]'Start'
$CONFIG_START_BUTTON.UseVisualStyleBackColor = $false
$CONFIG_START_BUTTON.add_Click($CONFIG_START_BUTTON_Click)
#
#MAIN_CONFIGMOD_PANEL
#
$MAIN_CONFIGMOD_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_CONFIGMOD_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_CONFIGMOD_PANEL.Controls.Add($SCROLL_CONFIGMOD_PANEL)
$MAIN_CONFIGMOD_PANEL.Controls.Add($TITLE_CONFIGMOD_PANEL)
$MAIN_CONFIGMOD_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]497,[System.Int32]6))
$MAIN_CONFIGMOD_PANEL.Name = [System.String]'MAIN_CONFIGMOD_PANEL'
$MAIN_CONFIGMOD_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]132,[System.Int32]378))
$MAIN_CONFIGMOD_PANEL.TabIndex = [System.Int32]30
#
#SCROLL_CONFIGMOD_PANEL
#
$SCROLL_CONFIGMOD_PANEL.AutoScroll = $true
$SCROLL_CONFIGMOD_PANEL.BackColor = [System.Drawing.Color]::LightGray
$SCROLL_CONFIGMOD_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$SCROLL_CONFIGMOD_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]36))
$SCROLL_CONFIGMOD_PANEL.Name = [System.String]'SCROLL_CONFIGMOD_PANEL'
$SCROLL_CONFIGMOD_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]119,[System.Int32]331))
$SCROLL_CONFIGMOD_PANEL.TabIndex = [System.Int32]1
#
#TITLE_CONFIGMOD_PANEL
#
$TITLE_CONFIGMOD_PANEL.BackColor = [System.Drawing.Color]::LightGray
$TITLE_CONFIGMOD_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$TITLE_CONFIGMOD_PANEL.Controls.Add($TITLE_AVAILCONFIGSMOD_LABEL)
$TITLE_CONFIGMOD_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]4))
$TITLE_CONFIGMOD_PANEL.Name = [System.String]'TITLE_CONFIGMOD_PANEL'
$TITLE_CONFIGMOD_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]119,[System.Int32]27))
$TITLE_CONFIGMOD_PANEL.TabIndex = [System.Int32]0
#
#TITLE_AVAILCONFIGSMOD_LABEL
#
$TITLE_AVAILCONFIGSMOD_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]1))
$TITLE_AVAILCONFIGSMOD_LABEL.Name = [System.String]'TITLE_AVAILCONFIGSMOD_LABEL'
$TITLE_AVAILCONFIGSMOD_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]111,[System.Int32]23))
$TITLE_AVAILCONFIGSMOD_LABEL.TabIndex = [System.Int32]0
$TITLE_AVAILCONFIGSMOD_LABEL.Text = [System.String]'Available Mods:'
$TITLE_AVAILCONFIGSMOD_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#
#MAIN_CONFIG_PANEL
#
$MAIN_CONFIG_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_CONFIG_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_CONFIG_PANEL.Controls.Add($TITLE_CONFIGTAB_PANEL)
$MAIN_CONFIG_PANEL.Controls.Add($SCROLL_CONFIG_PANEL)
$MAIN_CONFIG_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]6))
$MAIN_CONFIG_PANEL.Name = [System.String]'MAIN_CONFIG_PANEL'
$MAIN_CONFIG_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]488,[System.Int32]427))
$MAIN_CONFIG_PANEL.TabIndex = [System.Int32]28
$MAIN_CONFIG_PANEL.add_Paint($MAIN_CONFIG_PANEL_Paint)
#
#TITLE_CONFIGTAB_PANEL
#
$TITLE_CONFIGTAB_PANEL.BackColor = [System.Drawing.Color]::LightGray
$TITLE_CONFIGTAB_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$TITLE_CONFIGTAB_PANEL.Controls.Add($TITLE_AVAILCONFIGS_LABEL)
$TITLE_CONFIGTAB_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]4))
$TITLE_CONFIGTAB_PANEL.Name = [System.String]'TITLE_CONFIGTAB_PANEL'
$TITLE_CONFIGTAB_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]473,[System.Int32]26))
$TITLE_CONFIGTAB_PANEL.TabIndex = [System.Int32]1
#
#TITLE_AVAILCONFIGS_LABEL
#
$TITLE_AVAILCONFIGS_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]11.25))
$TITLE_AVAILCONFIGS_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$TITLE_AVAILCONFIGS_LABEL.Name = [System.String]'TITLE_AVAILCONFIGS_LABEL'
$TITLE_AVAILCONFIGS_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]469,[System.Int32]24))
$TITLE_AVAILCONFIGS_LABEL.TabIndex = [System.Int32]0
$TITLE_AVAILCONFIGS_LABEL.Text = [System.String]'Available Configurations:'
$TITLE_AVAILCONFIGS_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#SCROLL_CONFIG_PANEL
#
$SCROLL_CONFIG_PANEL.AutoScroll = $true
$SCROLL_CONFIG_PANEL.BackColor = [System.Drawing.Color]::LightGray
$SCROLL_CONFIG_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$SCROLL_CONFIG_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]36))
$SCROLL_CONFIG_PANEL.Name = [System.String]'SCROLL_CONFIG_PANEL'
$SCROLL_CONFIG_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]473,[System.Int32]384))
$SCROLL_CONFIG_PANEL.TabIndex = [System.Int32]0
#
#APP_TAB
#
$APP_TAB.BackColor = [System.Drawing.Color]::Gray
$APP_TAB.Controls.Add($MAIN_APP_PANEL)
$APP_TAB.Controls.Add($MAIN_APPMOD_PANEL)
$APP_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$APP_TAB.Name = [System.String]'APP_TAB'
$APP_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$APP_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$APP_TAB.TabIndex = [System.Int32]1
$APP_TAB.Text = [System.String]'Apps'
$APP_TAB.add_Click($APP_TAB_Click)
#
#MAIN_APP_PANEL
#
$MAIN_APP_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_APP_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_APP_PANEL.Controls.Add($SCROLL_APP_PANEL)
$MAIN_APP_PANEL.Controls.Add($TITLE_APPTAB_PANEL)
$MAIN_APP_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]6))
$MAIN_APP_PANEL.Name = [System.String]'MAIN_APP_PANEL'
$MAIN_APP_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]488,[System.Int32]427))
$MAIN_APP_PANEL.TabIndex = [System.Int32]2
#
#SCROLL_APP_PANEL
#
$SCROLL_APP_PANEL.AutoScroll = $true
$SCROLL_APP_PANEL.BackColor = [System.Drawing.Color]::LightGray
$SCROLL_APP_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$SCROLL_APP_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]36))
$SCROLL_APP_PANEL.Name = [System.String]'SCROLL_APP_PANEL'
$SCROLL_APP_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]473,[System.Int32]384))
$SCROLL_APP_PANEL.TabIndex = [System.Int32]1
#
#TITLE_APPTAB_PANEL
#
$TITLE_APPTAB_PANEL.BackColor = [System.Drawing.Color]::LightGray
$TITLE_APPTAB_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$TITLE_APPTAB_PANEL.Controls.Add($TITLE_AVAILAPPS_LABEL)
$TITLE_APPTAB_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]4))
$TITLE_APPTAB_PANEL.Name = [System.String]'TITLE_APPTAB_PANEL'
$TITLE_APPTAB_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]473,[System.Int32]26))
$TITLE_APPTAB_PANEL.TabIndex = [System.Int32]0
#
#TITLE_AVAILAPPS_LABEL
#
$TITLE_AVAILAPPS_LABEL.BackColor = [System.Drawing.Color]::Transparent
$TITLE_AVAILAPPS_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]11.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$TITLE_AVAILAPPS_LABEL.ForeColor = [System.Drawing.Color]::Black
$TITLE_AVAILAPPS_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$TITLE_AVAILAPPS_LABEL.Name = [System.String]'TITLE_AVAILAPPS_LABEL'
$TITLE_AVAILAPPS_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]469,[System.Int32]24))
$TITLE_AVAILAPPS_LABEL.TabIndex = [System.Int32]0
$TITLE_AVAILAPPS_LABEL.Text = [System.String]'Available Applications:'
$TITLE_AVAILAPPS_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#MAIN_APPMOD_PANEL
#
$MAIN_APPMOD_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_APPMOD_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_APPMOD_PANEL.Controls.Add($SCROLL_APPMOD_PANEL)
$MAIN_APPMOD_PANEL.Controls.Add($TITLE_APPMOD_PANEL)
$MAIN_APPMOD_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]497,[System.Int32]6))
$MAIN_APPMOD_PANEL.Name = [System.String]'MAIN_APPMOD_PANEL'
$MAIN_APPMOD_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]132,[System.Int32]427))
$MAIN_APPMOD_PANEL.TabIndex = [System.Int32]1
#
#SCROLL_APPMOD_PANEL
#
$SCROLL_APPMOD_PANEL.AutoScroll = $true
$SCROLL_APPMOD_PANEL.BackColor = [System.Drawing.Color]::LightGray
$SCROLL_APPMOD_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$SCROLL_APPMOD_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]36))
$SCROLL_APPMOD_PANEL.Name = [System.String]'SCROLL_APPMOD_PANEL'
$SCROLL_APPMOD_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]119,[System.Int32]384))
$SCROLL_APPMOD_PANEL.TabIndex = [System.Int32]1
#
#TITLE_APPMOD_PANEL
#
$TITLE_APPMOD_PANEL.BackColor = [System.Drawing.Color]::LightGray
$TITLE_APPMOD_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$TITLE_APPMOD_PANEL.Controls.Add($TITLE_AVAILAPPSMOD_LABEL)
$TITLE_APPMOD_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]4))
$TITLE_APPMOD_PANEL.Name = [System.String]'TITLE_APPMOD_PANEL'
$TITLE_APPMOD_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]119,[System.Int32]27))
$TITLE_APPMOD_PANEL.TabIndex = [System.Int32]0
#
#TITLE_AVAILAPPSMOD_LABEL
#
$TITLE_AVAILAPPSMOD_LABEL.ForeColor = [System.Drawing.Color]::Black
$TITLE_AVAILAPPSMOD_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$TITLE_AVAILAPPSMOD_LABEL.Name = [System.String]'TITLE_AVAILAPPSMOD_LABEL'
$TITLE_AVAILAPPSMOD_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]111,[System.Int32]25))
$TITLE_AVAILAPPSMOD_LABEL.TabIndex = [System.Int32]0
$TITLE_AVAILAPPSMOD_LABEL.Text = [System.String]'Available Mods:'
$TITLE_AVAILAPPSMOD_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$TITLE_AVAILAPPSMOD_LABEL.add_Click($TITLE_AVAILMOD_LABEL_Click)
#
#TOOLS_TAB
#
$TOOLS_TAB.BackColor = [System.Drawing.Color]::Gray
$TOOLS_TAB.Controls.Add($TEMP_COMINGSOON_TOOLS_LABEL)
$TOOLS_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$TOOLS_TAB.Name = [System.String]'TOOLS_TAB'
$TOOLS_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$TOOLS_TAB.TabIndex = [System.Int32]2
$TOOLS_TAB.Text = [System.String]'Tools'
#
#TEMP_COMINGSOON_TOOLS_LABEL
#
$TEMP_COMINGSOON_TOOLS_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]14.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$TEMP_COMINGSOON_TOOLS_LABEL.ForeColor = [System.Drawing.Color]::White
$TEMP_COMINGSOON_TOOLS_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]120))
$TEMP_COMINGSOON_TOOLS_LABEL.Name = [System.String]'TEMP_COMINGSOON_TOOLS_LABEL'
$TEMP_COMINGSOON_TOOLS_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]413,[System.Int32]177))
$TEMP_COMINGSOON_TOOLS_LABEL.TabIndex = [System.Int32]0
$TEMP_COMINGSOON_TOOLS_LABEL.Text = [System.String]'Tools Tab Coming Soon...'
$TEMP_COMINGSOON_TOOLS_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#
#MODS_TAB
#
$MODS_TAB.BackColor = [System.Drawing.Color]::Gray
$MODS_TAB.Controls.Add($TEMP_COMINGSOON_MODS_LABEL)
$MODS_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$MODS_TAB.Name = [System.String]'MODS_TAB'
$MODS_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$MODS_TAB.TabIndex = [System.Int32]4
$MODS_TAB.Text = [System.String]'Mods'
#
#TEMP_COMINGSOON_MODS_LABEL
#
$TEMP_COMINGSOON_MODS_LABEL.BackColor = [System.Drawing.Color]::Transparent
$TEMP_COMINGSOON_MODS_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]14.25))
$TEMP_COMINGSOON_MODS_LABEL.ForeColor = [System.Drawing.Color]::White
$TEMP_COMINGSOON_MODS_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]110,[System.Int32]120))
$TEMP_COMINGSOON_MODS_LABEL.Name = [System.String]'TEMP_COMINGSOON_MODS_LABEL'
$TEMP_COMINGSOON_MODS_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]413,[System.Int32]177))
$TEMP_COMINGSOON_MODS_LABEL.TabIndex = [System.Int32]0
$TEMP_COMINGSOON_MODS_LABEL.Text = [System.String]'Mods Tab Coming Soon...'
$TEMP_COMINGSOON_MODS_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$TEMP_COMINGSOON_MODS_LABEL.add_Click($Label1_Click)
#
#SETTINGS_TAB
#
$SETTINGS_TAB.BackColor = [System.Drawing.Color]::Gray
$SETTINGS_TAB.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$SETTINGS_TAB.Controls.Add($SETTINGS_PERMABUTTON_BACKPANEL)
$SETTINGS_TAB.Controls.Add($SETTINGS_TAB_CONTROL)
$SETTINGS_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$SETTINGS_TAB.Name = [System.String]'SETTINGS_TAB'
$SETTINGS_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]633,[System.Int32]439))
$SETTINGS_TAB.TabIndex = [System.Int32]3
$SETTINGS_TAB.Text = [System.String]'Settings'
#
#SETTINGS_PERMABUTTON_BACKPANEL
#
$SETTINGS_PERMABUTTON_BACKPANEL.BackColor = [System.Drawing.Color]::DarkGray
$SETTINGS_PERMABUTTON_BACKPANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$SETTINGS_PERMABUTTON_BACKPANEL.Controls.Add($SETTINGS_RESULTMESSAGE_BACKPANEL)
$SETTINGS_PERMABUTTON_BACKPANEL.Controls.Add($SAVE_SETTINGS_BUTTON)
$SETTINGS_PERMABUTTON_BACKPANEL.Controls.Add($RESET_SETTINGS_BUTTON)
$SETTINGS_PERMABUTTON_BACKPANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]400))
$SETTINGS_PERMABUTTON_BACKPANEL.Name = [System.String]'SETTINGS_PERMABUTTON_BACKPANEL'
$SETTINGS_PERMABUTTON_BACKPANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]621,[System.Int32]31))
$SETTINGS_PERMABUTTON_BACKPANEL.TabIndex = [System.Int32]1
#
#SAVE_SETTINGS_BUTTON
#
$SAVE_SETTINGS_BUTTON.BackColor = [System.Drawing.Color]::Silver
$SAVE_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$SAVE_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]527,[System.Int32]3))
$SAVE_SETTINGS_BUTTON.Name = [System.String]'SAVE_SETTINGS_BUTTON'
$SAVE_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]89,[System.Int32]23))
$SAVE_SETTINGS_BUTTON.TabIndex = [System.Int32]1
$SAVE_SETTINGS_BUTTON.Text = [System.String]'Save'
$SAVE_SETTINGS_BUTTON.UseVisualStyleBackColor = $false
#
#RESET_SETTINGS_BUTTON
#
$RESET_SETTINGS_BUTTON.BackColor = [System.Drawing.Color]::Silver
$RESET_SETTINGS_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$RESET_SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$RESET_SETTINGS_BUTTON.Name = [System.String]'RESET_SETTINGS_BUTTON'
$RESET_SETTINGS_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]89,[System.Int32]23))
$RESET_SETTINGS_BUTTON.TabIndex = [System.Int32]2
$RESET_SETTINGS_BUTTON.Text = [System.String]'Reset'
$RESET_SETTINGS_BUTTON.UseVisualStyleBackColor = $false
#
#SETTINGS_TAB_CONTROL
#
$SETTINGS_TAB_CONTROL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]7))
$SETTINGS_TAB_CONTROL.Name = [System.String]'SETTINGS_TAB_CONTROL'
$SETTINGS_TAB_CONTROL.SelectedIndex = [System.Int32]0
$SETTINGS_TAB_CONTROL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]621,[System.Int32]388))
$SETTINGS_TAB_CONTROL.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
$SETTINGS_TAB_CONTROL.TabIndex = [System.Int32]0
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
$VERSION_NUMBER_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]25))
$VERSION_NUMBER_LABEL.TabIndex = [System.Int32]0
$VERSION_NUMBER_LABEL.Text = [System.String]'0.0.0'
$VERSION_NUMBER_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#SETTINGS_RESULTMESSAGE_BACKPANEL
#
$SETTINGS_RESULTMESSAGE_BACKPANEL.BackColor = [System.Drawing.Color]::LightGray
$SETTINGS_RESULTMESSAGE_BACKPANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$SETTINGS_RESULTMESSAGE_BACKPANEL.Controls.Add($SETTINGS_OPERATIONRESULT_LABEL)
$SETTINGS_RESULTMESSAGE_BACKPANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]98,[System.Int32]3))
$SETTINGS_RESULTMESSAGE_BACKPANEL.Name = [System.String]'SETTINGS_RESULTMESSAGE_BACKPANEL'
$SETTINGS_RESULTMESSAGE_BACKPANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]423,[System.Int32]23))
$SETTINGS_RESULTMESSAGE_BACKPANEL.TabIndex = [System.Int32]3
#
#SETTINGS_OPERATIONRESULT_LABEL
#
$SETTINGS_OPERATIONRESULT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-1,[System.Int32]0))
$SETTINGS_OPERATIONRESULT_LABEL.Name = [System.String]'SETTINGS_OPERATIONRESULT_LABEL'
$SETTINGS_OPERATIONRESULT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]423,[System.Int32]21))
$SETTINGS_OPERATIONRESULT_LABEL.TabIndex = [System.Int32]13
$SETTINGS_OPERATIONRESULT_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
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
$MAIN_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$MAIN_FORM.MaximizeBox = $false
$MAIN_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$MAIN_FORM.Text = [System.String]'Main - FPCA - (Frysix''s Powershell Configurator App)'
$MAIN_FORM.TopMost = $true
$SIDE_PANNEL.ResumeLayout($false)
$MAIN_TAB_CONTROL.ResumeLayout($false)
$CONFIG_TAB.ResumeLayout($false)
$CONFIG_START_BUTTON_PANEL.ResumeLayout($false)
$MAIN_CONFIGMOD_PANEL.ResumeLayout($false)
$TITLE_CONFIGMOD_PANEL.ResumeLayout($false)
$MAIN_CONFIG_PANEL.ResumeLayout($false)
$TITLE_CONFIGTAB_PANEL.ResumeLayout($false)
$APP_TAB.ResumeLayout($false)
$MAIN_APP_PANEL.ResumeLayout($false)
$TITLE_APPTAB_PANEL.ResumeLayout($false)
$MAIN_APPMOD_PANEL.ResumeLayout($false)
$TITLE_APPMOD_PANEL.ResumeLayout($false)
$TOOLS_TAB.ResumeLayout($false)
$MODS_TAB.ResumeLayout($false)
$SETTINGS_TAB.ResumeLayout($false)
$SETTINGS_PERMABUTTON_BACKPANEL.ResumeLayout($false)
$SETTINGS_RESULTMESSAGE_BACKPANEL.ResumeLayout($false)
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
Add-Member -InputObject $MAIN_FORM -Name MAIN_TAB_CONTROL -Value $MAIN_TAB_CONTROL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_TAB -Value $CONFIG_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_START_BUTTON_PANEL -Value $CONFIG_START_BUTTON_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_START_BUTTON -Value $CONFIG_START_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MAIN_CONFIGMOD_PANEL -Value $MAIN_CONFIGMOD_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SCROLL_CONFIGMOD_PANEL -Value $SCROLL_CONFIGMOD_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_CONFIGMOD_PANEL -Value $TITLE_CONFIGMOD_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_AVAILCONFIGSMOD_LABEL -Value $TITLE_AVAILCONFIGSMOD_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MAIN_CONFIG_PANEL -Value $MAIN_CONFIG_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_CONFIGTAB_PANEL -Value $TITLE_CONFIGTAB_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_AVAILCONFIGS_LABEL -Value $TITLE_AVAILCONFIGS_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SCROLL_CONFIG_PANEL -Value $SCROLL_CONFIG_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_TAB -Value $APP_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MAIN_APP_PANEL -Value $MAIN_APP_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SCROLL_APP_PANEL -Value $SCROLL_APP_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_APPTAB_PANEL -Value $TITLE_APPTAB_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_AVAILAPPS_LABEL -Value $TITLE_AVAILAPPS_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MAIN_APPMOD_PANEL -Value $MAIN_APPMOD_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SCROLL_APPMOD_PANEL -Value $SCROLL_APPMOD_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_APPMOD_PANEL -Value $TITLE_APPMOD_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TITLE_AVAILAPPSMOD_LABEL -Value $TITLE_AVAILAPPSMOD_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TOOLS_TAB -Value $TOOLS_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TEMP_COMINGSOON_TOOLS_LABEL -Value $TEMP_COMINGSOON_TOOLS_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MODS_TAB -Value $MODS_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name TEMP_COMINGSOON_MODS_LABEL -Value $TEMP_COMINGSOON_MODS_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_TAB -Value $SETTINGS_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_PERMABUTTON_BACKPANEL -Value $SETTINGS_PERMABUTTON_BACKPANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_RESULTMESSAGE_BACKPANEL -Value $SETTINGS_RESULTMESSAGE_BACKPANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_OPERATIONRESULT_LABEL -Value $SETTINGS_OPERATIONRESULT_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SAVE_SETTINGS_BUTTON -Value $SAVE_SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name RESET_SETTINGS_BUTTON -Value $RESET_SETTINGS_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_TAB_CONTROL -Value $SETTINGS_TAB_CONTROL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_LABEL -Value $VERSION_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_NUMBER_LABEL -Value $VERSION_NUMBER_LABEL -MemberType NoteProperty
}
. InitializeComponent
