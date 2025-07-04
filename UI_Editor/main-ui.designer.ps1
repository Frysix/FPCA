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
[System.Windows.Forms.RichTextBox]$TOTAL_CONFIG_SELECTED_TEXTBOX = $null
[System.Windows.Forms.CheckBox]$USECUSTOM_CUSTOMCONFIG_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX = $null
[System.Windows.Forms.Panel]$CONFIG_DEFAULT_CUSTOM_PANNEL = $null
[System.Windows.Forms.Panel]$CONFIGFILEPATH_LINK_SCROLL_PANEL = $null
[System.Windows.Forms.LinkLabel]$CONFIGFILEPATH_LINK_LABEL = $null
[System.Windows.Forms.Button]$IMPORT_CONFIG_BUTTON = $null
[System.Windows.Forms.Panel]$CONFIG_DEFAULT_SETTINGS_PANNEL = $null
[System.Windows.Forms.Label]$SETTINGS_CONFIG_TITLE_LABEL = $null
[System.Windows.Forms.CheckBox]$UPWIN_SETTINGS_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$UPMSSTORE_SETTINGS_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$CONFEXPLORER_SETTINGS_CHECKBOX = $null
[System.Windows.Forms.Panel]$CONFIG_DEFAULT_MISCINSTALL_PANNEL = $null
[System.Windows.Forms.Label]$MISCINSTALL_CONFIG_TITLE_LABEL = $null
[System.Windows.Forms.CheckBox]$STOFFICE_LAUNCH_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$MORE_LAUNCH_CHECKBOX = $null
[System.Windows.Forms.Panel]$CONFIG_DEFAULT_INSTALL_PANNEL = $null
[System.Windows.Forms.Label]$INSTALL_CONFIG_TITLE_LABEL = $null
[System.Windows.Forms.CheckBox]$GOOGLE_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$FIREFOX_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$WINRAR_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$ACROBAT_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$7ZIP_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$MACRIUM_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$DISCORD_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$STEAM_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$ZOOM_INSTALL_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$VLC_INSTALL_CHECKBOX = $null
[System.Windows.Forms.Button]$CONFIG_START_BUTTON = $null
[System.Windows.Forms.TabPage]$APP_TAB = $null
[System.Windows.Forms.RichTextBox]$APP_LOG_TEXTBOX = $null
[System.Windows.Forms.CheckBox]$AUTOREFRESH_APP_CHECKBOX = $null
[System.Windows.Forms.CheckBox]$USECUSTOM_APP_CHECKBOX = $null
[System.Windows.Forms.Button]$REFRESH_APP_BUTTON = $null
[System.Windows.Forms.Panel]$MODULAR_APP_PANEL = $null
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
$TOTAL_CONFIG_SELECTED_TEXTBOX = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$USECUSTOM_CUSTOMCONFIG_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$CONFIG_DEFAULT_CUSTOM_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$CONFIGFILEPATH_LINK_SCROLL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$CONFIGFILEPATH_LINK_LABEL = (New-Object -TypeName System.Windows.Forms.LinkLabel)
$IMPORT_CONFIG_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$CONFIG_DEFAULT_SETTINGS_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$SETTINGS_CONFIG_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$UPWIN_SETTINGS_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$UPMSSTORE_SETTINGS_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$CONFEXPLORER_SETTINGS_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$CONFIG_DEFAULT_MISCINSTALL_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MISCINSTALL_CONFIG_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$STOFFICE_LAUNCH_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$MORE_LAUNCH_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$CONFIG_DEFAULT_INSTALL_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
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
$CONFIG_START_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$APP_TAB = (New-Object -TypeName System.Windows.Forms.TabPage)
$APP_LOG_TEXTBOX = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$AUTOREFRESH_APP_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$USECUSTOM_APP_CHECKBOX = (New-Object -TypeName System.Windows.Forms.CheckBox)
$REFRESH_APP_BUTTON = (New-Object -TypeName System.Windows.Forms.Button)
$MODULAR_APP_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$VERSION_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$VERSION_NUMBER_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$SIDE_PANNEL.SuspendLayout()
$MAIN_TAB_CONTROL.SuspendLayout()
$CONFIG_TAB.SuspendLayout()
$CONFIGFILEPATH_LINK_SCROLL_PANEL.SuspendLayout()
$CONFIG_DEFAULT_SETTINGS_PANNEL.SuspendLayout()
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.SuspendLayout()
$CONFIG_DEFAULT_INSTALL_PANNEL.SuspendLayout()
$APP_TAB.SuspendLayout()
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
$SIDE_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]92,[System.Int32]341))
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
$SETTINGS_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]312))
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
$MAIN_TAB_CONTROL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]544,[System.Int32]341))
$MAIN_TAB_CONTROL.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
$MAIN_TAB_CONTROL.TabIndex = [System.Int32]3
#
#CONFIG_TAB
#
$CONFIG_TAB.BackColor = [System.Drawing.Color]::Gray
$CONFIG_TAB.Controls.Add($TOTAL_CONFIG_SELECTED_TEXTBOX)
$CONFIG_TAB.Controls.Add($USECUSTOM_CUSTOMCONFIG_CHECKBOX)
$CONFIG_TAB.Controls.Add($AUTOREFRESH_CUSTOMCONFIG_CHECKBOX)
$CONFIG_TAB.Controls.Add($CONFIG_DEFAULT_CUSTOM_PANNEL)
$CONFIG_TAB.Controls.Add($CONFIGFILEPATH_LINK_SCROLL_PANEL)
$CONFIG_TAB.Controls.Add($CONFIG_DEFAULT_SETTINGS_PANNEL)
$CONFIG_TAB.Controls.Add($CONFIG_DEFAULT_MISCINSTALL_PANNEL)
$CONFIG_TAB.Controls.Add($CONFIG_DEFAULT_INSTALL_PANNEL)
$CONFIG_TAB.Controls.Add($CONFIG_START_BUTTON)
$CONFIG_TAB.ForeColor = [System.Drawing.SystemColors]::ControlText
$CONFIG_TAB.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]4,[System.Int32]24))
$CONFIG_TAB.Name = [System.String]'CONFIG_TAB'
$CONFIG_TAB.Padding = (New-Object -TypeName System.Windows.Forms.Padding -ArgumentList @([System.Int32]3))
$CONFIG_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]536,[System.Int32]313))
$CONFIG_TAB.TabIndex = [System.Int32]0
$CONFIG_TAB.Text = [System.String]'Configuration'
#
#TOTAL_CONFIG_SELECTED_TEXTBOX
#
$TOTAL_CONFIG_SELECTED_TEXTBOX.BackColor = [System.Drawing.Color]::DarkGray
$TOTAL_CONFIG_SELECTED_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]416,[System.Int32]3))
$TOTAL_CONFIG_SELECTED_TEXTBOX.Name = [System.String]'TOTAL_CONFIG_SELECTED_TEXTBOX'
$TOTAL_CONFIG_SELECTED_TEXTBOX.ReadOnly = $true
$TOTAL_CONFIG_SELECTED_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]117,[System.Int32]218))
$TOTAL_CONFIG_SELECTED_TEXTBOX.TabIndex = [System.Int32]28
$TOTAL_CONFIG_SELECTED_TEXTBOX.Text = [System.String]''
#
#USECUSTOM_CUSTOMCONFIG_CHECKBOX
#
$USECUSTOM_CUSTOMCONFIG_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$USECUSTOM_CUSTOMCONFIG_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]416,[System.Int32]231))
$USECUSTOM_CUSTOMCONFIG_CHECKBOX.Name = [System.String]'USECUSTOM_CUSTOMCONFIG_CHECKBOX'
$USECUSTOM_CUSTOMCONFIG_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]114,[System.Int32]19))
$USECUSTOM_CUSTOMCONFIG_CHECKBOX.TabIndex = [System.Int32]27
$USECUSTOM_CUSTOMCONFIG_CHECKBOX.Text = [System.String]'Use Custom'
$USECUSTOM_CUSTOMCONFIG_CHECKBOX.UseVisualStyleBackColor = $true
#
#AUTOREFRESH_CUSTOMCONFIG_CHECKBOX
#
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]416,[System.Int32]249))
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Name = [System.String]'AUTOREFRESH_CUSTOMCONFIG_CHECKBOX'
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]114,[System.Int32]21))
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.TabIndex = [System.Int32]26
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Text = [System.String]'Auto Refresh'
$AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.UseVisualStyleBackColor = $true
#
#CONFIG_DEFAULT_CUSTOM_PANNEL
#
$CONFIG_DEFAULT_CUSTOM_PANNEL.AutoScroll = $true
$CONFIG_DEFAULT_CUSTOM_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$CONFIG_DEFAULT_CUSTOM_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CONFIG_DEFAULT_CUSTOM_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]277,[System.Int32]3))
$CONFIG_DEFAULT_CUSTOM_PANNEL.Name = [System.String]'CONFIG_DEFAULT_CUSTOM_PANNEL'
$CONFIG_DEFAULT_CUSTOM_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]133,[System.Int32]266))
$CONFIG_DEFAULT_CUSTOM_PANNEL.TabIndex = [System.Int32]25
#
#CONFIGFILEPATH_LINK_SCROLL_PANEL
#
$CONFIGFILEPATH_LINK_SCROLL_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$CONFIGFILEPATH_LINK_SCROLL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CONFIGFILEPATH_LINK_SCROLL_PANEL.Controls.Add($CONFIGFILEPATH_LINK_LABEL)
$CONFIGFILEPATH_LINK_SCROLL_PANEL.Controls.Add($IMPORT_CONFIG_BUTTON)
$CONFIGFILEPATH_LINK_SCROLL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]140,[System.Int32]275))
$CONFIGFILEPATH_LINK_SCROLL_PANEL.Name = [System.String]'CONFIGFILEPATH_LINK_SCROLL_PANEL'
$CONFIGFILEPATH_LINK_SCROLL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]297,[System.Int32]35))
$CONFIGFILEPATH_LINK_SCROLL_PANEL.TabIndex = [System.Int32]24
#
#CONFIGFILEPATH_LINK_LABEL
#
$CONFIGFILEPATH_LINK_LABEL.ActiveLinkColor = [System.Drawing.Color]::White
$CONFIGFILEPATH_LINK_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8))
$CONFIGFILEPATH_LINK_LABEL.LinkColor = [System.Drawing.Color]::Red
$CONFIGFILEPATH_LINK_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]10))
$CONFIGFILEPATH_LINK_LABEL.Name = [System.String]'CONFIGFILEPATH_LINK_LABEL'
$CONFIGFILEPATH_LINK_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]222,[System.Int32]15))
$CONFIGFILEPATH_LINK_LABEL.TabIndex = [System.Int32]16
$CONFIGFILEPATH_LINK_LABEL.TabStop = $true
$CONFIGFILEPATH_LINK_LABEL.Text = [System.String]'PATH TO CONFIG FILE LOCATION'
$CONFIGFILEPATH_LINK_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleRight
#
#IMPORT_CONFIG_BUTTON
#
$IMPORT_CONFIG_BUTTON.BackColor = [System.Drawing.Color]::Silver
$IMPORT_CONFIG_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$IMPORT_CONFIG_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8))
$IMPORT_CONFIG_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]231,[System.Int32]7))
$IMPORT_CONFIG_BUTTON.Name = [System.String]'IMPORT_CONFIG_BUTTON'
$IMPORT_CONFIG_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]61,[System.Int32]21))
$IMPORT_CONFIG_BUTTON.TabIndex = [System.Int32]15
$IMPORT_CONFIG_BUTTON.Text = [System.String]'Import...'
$IMPORT_CONFIG_BUTTON.UseVisualStyleBackColor = $false
#
#CONFIG_DEFAULT_SETTINGS_PANNEL
#
$CONFIG_DEFAULT_SETTINGS_PANNEL.AutoScroll = $true
$CONFIG_DEFAULT_SETTINGS_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$CONFIG_DEFAULT_SETTINGS_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CONFIG_DEFAULT_SETTINGS_PANNEL.Controls.Add($SETTINGS_CONFIG_TITLE_LABEL)
$CONFIG_DEFAULT_SETTINGS_PANNEL.Controls.Add($UPWIN_SETTINGS_CHECKBOX)
$CONFIG_DEFAULT_SETTINGS_PANNEL.Controls.Add($UPMSSTORE_SETTINGS_CHECKBOX)
$CONFIG_DEFAULT_SETTINGS_PANNEL.Controls.Add($CONFEXPLORER_SETTINGS_CHECKBOX)
$CONFIG_DEFAULT_SETTINGS_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]140,[System.Int32]3))
$CONFIG_DEFAULT_SETTINGS_PANNEL.Name = [System.String]'CONFIG_DEFAULT_SETTINGS_PANNEL'
$CONFIG_DEFAULT_SETTINGS_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]131,[System.Int32]266))
$CONFIG_DEFAULT_SETTINGS_PANNEL.TabIndex = [System.Int32]23
#
#SETTINGS_CONFIG_TITLE_LABEL
#
$SETTINGS_CONFIG_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Semibold',[System.Single]10,[System.Drawing.FontStyle]::Bold))
$SETTINGS_CONFIG_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]8))
$SETTINGS_CONFIG_TITLE_LABEL.Name = [System.String]'SETTINGS_CONFIG_TITLE_LABEL'
$SETTINGS_CONFIG_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]68,[System.Int32]20))
$SETTINGS_CONFIG_TITLE_LABEL.TabIndex = [System.Int32]17
$SETTINGS_CONFIG_TITLE_LABEL.Text = [System.String]'Settings:'
$SETTINGS_CONFIG_TITLE_LABEL.add_Click($Label1_Click)
#
#UPWIN_SETTINGS_CHECKBOX
#
$UPWIN_SETTINGS_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$UPWIN_SETTINGS_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]7,[System.Int32]32))
$UPWIN_SETTINGS_CHECKBOX.Name = [System.String]'UPWIN_SETTINGS_CHECKBOX'
$UPWIN_SETTINGS_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]104,[System.Int32]17))
$UPWIN_SETTINGS_CHECKBOX.TabIndex = [System.Int32]18
$UPWIN_SETTINGS_CHECKBOX.Text = [System.String]'Update Windows'
$UPWIN_SETTINGS_CHECKBOX.UseVisualStyleBackColor = $true
#
#UPMSSTORE_SETTINGS_CHECKBOX
#
$UPMSSTORE_SETTINGS_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$UPMSSTORE_SETTINGS_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]7,[System.Int32]49))
$UPMSSTORE_SETTINGS_CHECKBOX.Name = [System.String]'UPMSSTORE_SETTINGS_CHECKBOX'
$UPMSSTORE_SETTINGS_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]104,[System.Int32]17))
$UPMSSTORE_SETTINGS_CHECKBOX.TabIndex = [System.Int32]19
$UPMSSTORE_SETTINGS_CHECKBOX.Text = [System.String]'Update MS Store'
$UPMSSTORE_SETTINGS_CHECKBOX.UseVisualStyleBackColor = $true
$UPMSSTORE_SETTINGS_CHECKBOX.add_CheckedChanged($CheckBox2_CheckedChanged)
#
#CONFEXPLORER_SETTINGS_CHECKBOX
#
$CONFEXPLORER_SETTINGS_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$CONFEXPLORER_SETTINGS_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]7,[System.Int32]66))
$CONFEXPLORER_SETTINGS_CHECKBOX.Name = [System.String]'CONFEXPLORER_SETTINGS_CHECKBOX'
$CONFEXPLORER_SETTINGS_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]104,[System.Int32]17))
$CONFEXPLORER_SETTINGS_CHECKBOX.TabIndex = [System.Int32]20
$CONFEXPLORER_SETTINGS_CHECKBOX.Text = [System.String]'Config Explorer'
$CONFEXPLORER_SETTINGS_CHECKBOX.UseVisualStyleBackColor = $true
#
#CONFIG_DEFAULT_MISCINSTALL_PANNEL
#
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.AutoScroll = $true
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.Controls.Add($MISCINSTALL_CONFIG_TITLE_LABEL)
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.Controls.Add($STOFFICE_LAUNCH_CHECKBOX)
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.Controls.Add($MORE_LAUNCH_CHECKBOX)
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]227))
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.Name = [System.String]'CONFIG_DEFAULT_MISCINSTALL_PANNEL'
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]131,[System.Int32]83))
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.TabIndex = [System.Int32]22
#
#MISCINSTALL_CONFIG_TITLE_LABEL
#
$MISCINSTALL_CONFIG_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Semibold',[System.Single]10,[System.Drawing.FontStyle]::Bold))
$MISCINSTALL_CONFIG_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]8))
$MISCINSTALL_CONFIG_TITLE_LABEL.Name = [System.String]'MISCINSTALL_CONFIG_TITLE_LABEL'
$MISCINSTALL_CONFIG_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]87,[System.Int32]17))
$MISCINSTALL_CONFIG_TITLE_LABEL.TabIndex = [System.Int32]12
$MISCINSTALL_CONFIG_TITLE_LABEL.Text = [System.String]'Misc Install:'
#
#STOFFICE_LAUNCH_CHECKBOX
#
$STOFFICE_LAUNCH_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$STOFFICE_LAUNCH_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]28))
$STOFFICE_LAUNCH_CHECKBOX.Name = [System.String]'STOFFICE_LAUNCH_CHECKBOX'
$STOFFICE_LAUNCH_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]110,[System.Int32]19))
$STOFFICE_LAUNCH_CHECKBOX.TabIndex = [System.Int32]13
$STOFFICE_LAUNCH_CHECKBOX.Text = [System.String]'Office/LibreOffice'
$STOFFICE_LAUNCH_CHECKBOX.UseVisualStyleBackColor = $true
$STOFFICE_LAUNCH_CHECKBOX.add_CheckedChanged($STOFFICE_LAUNCH_CHECKBOX_CheckedChanged)
#
#MORE_LAUNCH_CHECKBOX
#
$MORE_LAUNCH_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$MORE_LAUNCH_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]44))
$MORE_LAUNCH_CHECKBOX.Name = [System.String]'MORE_LAUNCH_CHECKBOX'
$MORE_LAUNCH_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]104,[System.Int32]19))
$MORE_LAUNCH_CHECKBOX.TabIndex = [System.Int32]14
$MORE_LAUNCH_CHECKBOX.Text = [System.String]'More...'
$MORE_LAUNCH_CHECKBOX.UseVisualStyleBackColor = $true
#
#CONFIG_DEFAULT_INSTALL_PANNEL
#
$CONFIG_DEFAULT_INSTALL_PANNEL.AutoScroll = $true
$CONFIG_DEFAULT_INSTALL_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$CONFIG_DEFAULT_INSTALL_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($INSTALL_CONFIG_TITLE_LABEL)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($GOOGLE_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($FIREFOX_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($WINRAR_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($ACROBAT_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($7ZIP_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($MACRIUM_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($DISCORD_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($STEAM_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($ZOOM_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Controls.Add($VLC_INSTALL_CHECKBOX)
$CONFIG_DEFAULT_INSTALL_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$CONFIG_DEFAULT_INSTALL_PANNEL.Name = [System.String]'CONFIG_DEFAULT_INSTALL_PANNEL'
$CONFIG_DEFAULT_INSTALL_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]131,[System.Int32]218))
$CONFIG_DEFAULT_INSTALL_PANNEL.TabIndex = [System.Int32]21
#
#INSTALL_CONFIG_TITLE_LABEL
#
$INSTALL_CONFIG_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI Semibold',[System.Single]10,[System.Drawing.FontStyle]::Bold))
$INSTALL_CONFIG_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]8))
$INSTALL_CONFIG_TITLE_LABEL.Name = [System.String]'INSTALL_CONFIG_TITLE_LABEL'
$INSTALL_CONFIG_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]53,[System.Int32]20))
$INSTALL_CONFIG_TITLE_LABEL.TabIndex = [System.Int32]1
$INSTALL_CONFIG_TITLE_LABEL.Text = [System.String]'Install:'
#
#GOOGLE_INSTALL_CHECKBOX
#
$GOOGLE_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$GOOGLE_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]31))
$GOOGLE_INSTALL_CHECKBOX.Name = [System.String]'GOOGLE_INSTALL_CHECKBOX'
$GOOGLE_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]18))
$GOOGLE_INSTALL_CHECKBOX.TabIndex = [System.Int32]2
$GOOGLE_INSTALL_CHECKBOX.Text = [System.String]'Google Chrome'
$GOOGLE_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#FIREFOX_INSTALL_CHECKBOX
#
$FIREFOX_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$FIREFOX_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]47))
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
$WINRAR_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]83))
$WINRAR_INSTALL_CHECKBOX.Name = [System.String]'WINRAR_INSTALL_CHECKBOX'
$WINRAR_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]18))
$WINRAR_INSTALL_CHECKBOX.TabIndex = [System.Int32]4
$WINRAR_INSTALL_CHECKBOX.Text = [System.String]'Winrar'
$WINRAR_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#ACROBAT_INSTALL_CHECKBOX
#
$ACROBAT_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$ACROBAT_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]66))
$ACROBAT_INSTALL_CHECKBOX.Name = [System.String]'ACROBAT_INSTALL_CHECKBOX'
$ACROBAT_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]16))
$ACROBAT_INSTALL_CHECKBOX.TabIndex = [System.Int32]5
$ACROBAT_INSTALL_CHECKBOX.Text = [System.String]'Acrobat Reader'
$ACROBAT_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
$ACROBAT_INSTALL_CHECKBOX.add_CheckedChanged($CheckBox2_CheckedChanged)
#
#7ZIP_INSTALL_CHECKBOX
#
$7ZIP_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$7ZIP_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]102))
$7ZIP_INSTALL_CHECKBOX.Name = [System.String]'7ZIP_INSTALL_CHECKBOX'
$7ZIP_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]16))
$7ZIP_INSTALL_CHECKBOX.TabIndex = [System.Int32]6
$7ZIP_INSTALL_CHECKBOX.Text = [System.String]'7-Zip'
$7ZIP_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#MACRIUM_INSTALL_CHECKBOX
#
$MACRIUM_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$MACRIUM_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]119))
$MACRIUM_INSTALL_CHECKBOX.Name = [System.String]'MACRIUM_INSTALL_CHECKBOX'
$MACRIUM_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]104,[System.Int32]17))
$MACRIUM_INSTALL_CHECKBOX.TabIndex = [System.Int32]7
$MACRIUM_INSTALL_CHECKBOX.Text = [System.String]'Macrium Reflect'
$MACRIUM_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#DISCORD_INSTALL_CHECKBOX
#
$DISCORD_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$DISCORD_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]136))
$DISCORD_INSTALL_CHECKBOX.Name = [System.String]'DISCORD_INSTALL_CHECKBOX'
$DISCORD_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]17))
$DISCORD_INSTALL_CHECKBOX.TabIndex = [System.Int32]8
$DISCORD_INSTALL_CHECKBOX.Text = [System.String]'Discord'
$DISCORD_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#STEAM_INSTALL_CHECKBOX
#
$STEAM_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$STEAM_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]152))
$STEAM_INSTALL_CHECKBOX.Name = [System.String]'STEAM_INSTALL_CHECKBOX'
$STEAM_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]19))
$STEAM_INSTALL_CHECKBOX.TabIndex = [System.Int32]9
$STEAM_INSTALL_CHECKBOX.Text = [System.String]'Steam'
$STEAM_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#ZOOM_INSTALL_CHECKBOX
#
$ZOOM_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$ZOOM_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]169))
$ZOOM_INSTALL_CHECKBOX.Name = [System.String]'ZOOM_INSTALL_CHECKBOX'
$ZOOM_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]16))
$ZOOM_INSTALL_CHECKBOX.TabIndex = [System.Int32]10
$ZOOM_INSTALL_CHECKBOX.Text = [System.String]'Zoom'
$ZOOM_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#VLC_INSTALL_CHECKBOX
#
$VLC_INSTALL_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$VLC_INSTALL_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]6,[System.Int32]185))
$VLC_INSTALL_CHECKBOX.Name = [System.String]'VLC_INSTALL_CHECKBOX'
$VLC_INSTALL_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]95,[System.Int32]18))
$VLC_INSTALL_CHECKBOX.TabIndex = [System.Int32]11
$VLC_INSTALL_CHECKBOX.Text = [System.String]'VLC'
$VLC_INSTALL_CHECKBOX.UseVisualStyleBackColor = $true
#
#CONFIG_START_BUTTON
#
$CONFIG_START_BUTTON.BackColor = [System.Drawing.Color]::Silver
$CONFIG_START_BUTTON.FlatStyle = [System.Windows.Forms.FlatStyle]::Popup
$CONFIG_START_BUTTON.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$CONFIG_START_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]443,[System.Int32]275))
$CONFIG_START_BUTTON.Name = [System.String]'CONFIG_START_BUTTON'
$CONFIG_START_BUTTON.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]35))
$CONFIG_START_BUTTON.TabIndex = [System.Int32]0
$CONFIG_START_BUTTON.Text = [System.String]'Start'
$CONFIG_START_BUTTON.UseVisualStyleBackColor = $false
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
$APP_TAB.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]536,[System.Int32]313))
$APP_TAB.TabIndex = [System.Int32]1
$APP_TAB.Text = [System.String]'App'
#
#APP_LOG_TEXTBOX
#
$APP_LOG_TEXTBOX.BackColor = [System.Drawing.Color]::DarkGray
$APP_LOG_TEXTBOX.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$APP_LOG_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]354,[System.Int32]3))
$APP_LOG_TEXTBOX.Name = [System.String]'APP_LOG_TEXTBOX'
$APP_LOG_TEXTBOX.ReadOnly = $true
$APP_LOG_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]179,[System.Int32]231))
$APP_LOG_TEXTBOX.TabIndex = [System.Int32]4
$APP_LOG_TEXTBOX.Text = [System.String]''
#
#AUTOREFRESH_APP_CHECKBOX
#
$AUTOREFRESH_APP_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$AUTOREFRESH_APP_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]446,[System.Int32]265))
$AUTOREFRESH_APP_CHECKBOX.Name = [System.String]'AUTOREFRESH_APP_CHECKBOX'
$AUTOREFRESH_APP_CHECKBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]90,[System.Int32]16))
$AUTOREFRESH_APP_CHECKBOX.TabIndex = [System.Int32]3
$AUTOREFRESH_APP_CHECKBOX.Text = [System.String]'Auto Refresh'
$AUTOREFRESH_APP_CHECKBOX.UseVisualStyleBackColor = $true
#
#USECUSTOM_APP_CHECKBOX
#
$USECUSTOM_APP_CHECKBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]7.5))
$USECUSTOM_APP_CHECKBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]446,[System.Int32]243))
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
$REFRESH_APP_BUTTON.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]443,[System.Int32]284))
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
$MODULAR_APP_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]345,[System.Int32]307))
$MODULAR_APP_PANEL.TabIndex = [System.Int32]0
#
#VERSION_LABEL
#
$VERSION_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$VERSION_LABEL.ForeColor = [System.Drawing.Color]::White
$VERSION_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]576,[System.Int32]5))
$VERSION_LABEL.Name = [System.String]'VERSION_LABEL'
$VERSION_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]57,[System.Int32]17))
$VERSION_LABEL.TabIndex = [System.Int32]3
$VERSION_LABEL.Text = [System.String]'Version:'
$VERSION_LABEL.add_Click($VERSION_LABEL_Click)
#
#VERSION_NUMBER_LABEL
#
$VERSION_NUMBER_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9.75))
$VERSION_NUMBER_LABEL.ForeColor = [System.Drawing.Color]::White
$VERSION_NUMBER_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]625,[System.Int32]5))
$VERSION_NUMBER_LABEL.Name = [System.String]'VERSION_NUMBER_LABEL'
$VERSION_NUMBER_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]29,[System.Int32]17))
$VERSION_NUMBER_LABEL.TabIndex = [System.Int32]0
$VERSION_NUMBER_LABEL.Text = [System.String]'0.0'
#
#MAIN_FORM
#
$MAIN_FORM.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None
$MAIN_FORM.AutoValidate = [System.Windows.Forms.AutoValidate]::EnablePreventFocusChange
$MAIN_FORM.BackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)))

$MAIN_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]666,[System.Int32]365))
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
$CONFIGFILEPATH_LINK_SCROLL_PANEL.ResumeLayout($false)
$CONFIG_DEFAULT_SETTINGS_PANNEL.ResumeLayout($false)
$CONFIG_DEFAULT_MISCINSTALL_PANNEL.ResumeLayout($false)
$CONFIG_DEFAULT_INSTALL_PANNEL.ResumeLayout($false)
$APP_TAB.ResumeLayout($false)
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
Add-Member -InputObject $MAIN_FORM -Name TOTAL_CONFIG_SELECTED_TEXTBOX -Value $TOTAL_CONFIG_SELECTED_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name USECUSTOM_CUSTOMCONFIG_CHECKBOX -Value $USECUSTOM_CUSTOMCONFIG_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name AUTOREFRESH_CUSTOMCONFIG_CHECKBOX -Value $AUTOREFRESH_CUSTOMCONFIG_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_DEFAULT_CUSTOM_PANNEL -Value $CONFIG_DEFAULT_CUSTOM_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIGFILEPATH_LINK_SCROLL_PANEL -Value $CONFIGFILEPATH_LINK_SCROLL_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIGFILEPATH_LINK_LABEL -Value $CONFIGFILEPATH_LINK_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name IMPORT_CONFIG_BUTTON -Value $IMPORT_CONFIG_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_DEFAULT_SETTINGS_PANNEL -Value $CONFIG_DEFAULT_SETTINGS_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name SETTINGS_CONFIG_TITLE_LABEL -Value $SETTINGS_CONFIG_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name UPWIN_SETTINGS_CHECKBOX -Value $UPWIN_SETTINGS_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name UPMSSTORE_SETTINGS_CHECKBOX -Value $UPMSSTORE_SETTINGS_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFEXPLORER_SETTINGS_CHECKBOX -Value $CONFEXPLORER_SETTINGS_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_DEFAULT_MISCINSTALL_PANNEL -Value $CONFIG_DEFAULT_MISCINSTALL_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MISCINSTALL_CONFIG_TITLE_LABEL -Value $MISCINSTALL_CONFIG_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name STOFFICE_LAUNCH_CHECKBOX -Value $STOFFICE_LAUNCH_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MORE_LAUNCH_CHECKBOX -Value $MORE_LAUNCH_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_DEFAULT_INSTALL_PANNEL -Value $CONFIG_DEFAULT_INSTALL_PANNEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name INSTALL_CONFIG_TITLE_LABEL -Value $INSTALL_CONFIG_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name GOOGLE_INSTALL_CHECKBOX -Value $GOOGLE_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name FIREFOX_INSTALL_CHECKBOX -Value $FIREFOX_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name WINRAR_INSTALL_CHECKBOX -Value $WINRAR_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name ACROBAT_INSTALL_CHECKBOX -Value $ACROBAT_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name 7ZIP_INSTALL_CHECKBOX -Value $7ZIP_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MACRIUM_INSTALL_CHECKBOX -Value $MACRIUM_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name DISCORD_INSTALL_CHECKBOX -Value $DISCORD_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name STEAM_INSTALL_CHECKBOX -Value $STEAM_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name ZOOM_INSTALL_CHECKBOX -Value $ZOOM_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VLC_INSTALL_CHECKBOX -Value $VLC_INSTALL_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name CONFIG_START_BUTTON -Value $CONFIG_START_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_TAB -Value $APP_TAB -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name APP_LOG_TEXTBOX -Value $APP_LOG_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name AUTOREFRESH_APP_CHECKBOX -Value $AUTOREFRESH_APP_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name USECUSTOM_APP_CHECKBOX -Value $USECUSTOM_APP_CHECKBOX -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name REFRESH_APP_BUTTON -Value $REFRESH_APP_BUTTON -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name MODULAR_APP_PANEL -Value $MODULAR_APP_PANEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_LABEL -Value $VERSION_LABEL -MemberType NoteProperty
Add-Member -InputObject $MAIN_FORM -Name VERSION_NUMBER_LABEL -Value $VERSION_NUMBER_LABEL -MemberType NoteProperty
}
. InitializeComponent
