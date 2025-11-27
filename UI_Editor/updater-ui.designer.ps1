$UPDATER_MAIN_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$MAIN_UPDATER_PANEL = $null
[System.Windows.Forms.Label]$PROGRESS_TEXT_LABEL = $null
[System.Windows.Forms.Label]$PROGRESS_NUM_LABEL = $null
[System.Windows.Forms.RichTextBox]$LIVEINFO_TEXTBOX = $null
[System.Windows.Forms.Label]$LIVESTATUS_TEXT_LABEL = $null
[System.Windows.Forms.Label]$UPDATINGTO_NUM_LABEL = $null
[System.Windows.Forms.Label]$CURRENTVERSION_NUM_LABEL = $null
[System.Windows.Forms.Label]$CURRENTVERSION_TITLE_LABEL = $null
[System.Windows.Forms.Label]$UPDATINGTO_TITLE_LABEL = $null
[System.Windows.Forms.ProgressBar]$MAIN_UPDATE_PROGRESSBAR = $null
function InitializeComponent
{
$MAIN_UPDATER_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$PROGRESS_TEXT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$PROGRESS_NUM_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$LIVEINFO_TEXTBOX = (New-Object -TypeName System.Windows.Forms.RichTextBox)
$LIVESTATUS_TEXT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$UPDATINGTO_NUM_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$CURRENTVERSION_NUM_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$CURRENTVERSION_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$UPDATINGTO_TITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_UPDATE_PROGRESSBAR = (New-Object -TypeName System.Windows.Forms.ProgressBar)
$MAIN_UPDATER_PANEL.SuspendLayout()
$UPDATER_MAIN_FORM.SuspendLayout()
#
#MAIN_UPDATER_PANEL
#
$MAIN_UPDATER_PANEL.BackColor = [System.Drawing.Color]::DimGray
$MAIN_UPDATER_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_UPDATER_PANEL.Controls.Add($PROGRESS_TEXT_LABEL)
$MAIN_UPDATER_PANEL.Controls.Add($PROGRESS_NUM_LABEL)
$MAIN_UPDATER_PANEL.Controls.Add($LIVEINFO_TEXTBOX)
$MAIN_UPDATER_PANEL.Controls.Add($LIVESTATUS_TEXT_LABEL)
$MAIN_UPDATER_PANEL.Controls.Add($UPDATINGTO_NUM_LABEL)
$MAIN_UPDATER_PANEL.Controls.Add($CURRENTVERSION_NUM_LABEL)
$MAIN_UPDATER_PANEL.Controls.Add($CURRENTVERSION_TITLE_LABEL)
$MAIN_UPDATER_PANEL.Controls.Add($UPDATINGTO_TITLE_LABEL)
$MAIN_UPDATER_PANEL.Controls.Add($MAIN_UPDATE_PROGRESSBAR)
$MAIN_UPDATER_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
$MAIN_UPDATER_PANEL.Name = [System.String]'MAIN_UPDATER_PANEL'
$MAIN_UPDATER_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]473,[System.Int32]263))
$MAIN_UPDATER_PANEL.TabIndex = [System.Int32]0
#
#PROGRESS_TEXT_LABEL
#
$PROGRESS_TEXT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9))
$PROGRESS_TEXT_LABEL.ForeColor = [System.Drawing.Color]::White
$PROGRESS_TEXT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]354,[System.Int32]111))
$PROGRESS_TEXT_LABEL.Name = [System.String]'PROGRESS_TEXT_LABEL'
$PROGRESS_TEXT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]63,[System.Int32]23))
$PROGRESS_TEXT_LABEL.TabIndex = [System.Int32]9
$PROGRESS_TEXT_LABEL.Text = [System.String]'Progress  - '
$PROGRESS_TEXT_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$PROGRESS_TEXT_LABEL.add_Click($Label1_Click)
#
#PROGRESS_NUM_LABEL
#
$PROGRESS_NUM_LABEL.BackColor = [System.Drawing.Color]::DimGray
$PROGRESS_NUM_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$PROGRESS_NUM_LABEL.ForeColor = [System.Drawing.Color]::White
$PROGRESS_NUM_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]412,[System.Int32]111))
$PROGRESS_NUM_LABEL.Name = [System.String]'PROGRESS_NUM_LABEL'
$PROGRESS_NUM_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]38,[System.Int32]23))
$PROGRESS_NUM_LABEL.TabIndex = [System.Int32]8
$PROGRESS_NUM_LABEL.Text = [System.String]'0%'
$PROGRESS_NUM_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#
#LIVEINFO_TEXTBOX
#
$LIVEINFO_TEXTBOX.BackColor = [System.Drawing.Color]::Gray
$LIVEINFO_TEXTBOX.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$LIVEINFO_TEXTBOX.Cursor = [System.Windows.Forms.Cursors]::Default
$LIVEINFO_TEXTBOX.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LIVEINFO_TEXTBOX.ForeColor = [System.Drawing.Color]::White
$LIVEINFO_TEXTBOX.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]137))
$LIVEINFO_TEXTBOX.Name = [System.String]'LIVEINFO_TEXTBOX'
$LIVEINFO_TEXTBOX.ReadOnly = $true
$LIVEINFO_TEXTBOX.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]430,[System.Int32]57))
$LIVEINFO_TEXTBOX.TabIndex = [System.Int32]7
$LIVEINFO_TEXTBOX.Text = [System.String]''
#
#LIVESTATUS_TEXT_LABEL
#
$LIVESTATUS_TEXT_LABEL.BackColor = [System.Drawing.Color]::DimGray
$LIVESTATUS_TEXT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]9,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$LIVESTATUS_TEXT_LABEL.ForeColor = [System.Drawing.Color]::White
$LIVESTATUS_TEXT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]111))
$LIVESTATUS_TEXT_LABEL.Name = [System.String]'LIVESTATUS_TEXT_LABEL'
$LIVESTATUS_TEXT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]297,[System.Int32]23))
$LIVESTATUS_TEXT_LABEL.TabIndex = [System.Int32]6
$LIVESTATUS_TEXT_LABEL.Text = [System.String]'LIVESTATUS:'
$LIVESTATUS_TEXT_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#UPDATINGTO_NUM_LABEL
#
$UPDATINGTO_NUM_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25))
$UPDATINGTO_NUM_LABEL.ForeColor = [System.Drawing.Color]::White
$UPDATINGTO_NUM_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]76,[System.Int32]23))
$UPDATINGTO_NUM_LABEL.Name = [System.String]'UPDATINGTO_NUM_LABEL'
$UPDATINGTO_NUM_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]139,[System.Int32]23))
$UPDATINGTO_NUM_LABEL.TabIndex = [System.Int32]4
$UPDATINGTO_NUM_LABEL.Text = [System.String]'0.0'
$UPDATINGTO_NUM_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#CURRENTVERSION_NUM_LABEL
#
$CURRENTVERSION_NUM_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25))
$CURRENTVERSION_NUM_LABEL.ForeColor = [System.Drawing.Color]::White
$CURRENTVERSION_NUM_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]94,[System.Int32]0))
$CURRENTVERSION_NUM_LABEL.Name = [System.String]'CURRENTVERSION_NUM_LABEL'
$CURRENTVERSION_NUM_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]121,[System.Int32]23))
$CURRENTVERSION_NUM_LABEL.TabIndex = [System.Int32]3
$CURRENTVERSION_NUM_LABEL.Text = [System.String]'0.0'
$CURRENTVERSION_NUM_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#CURRENTVERSION_TITLE_LABEL
#
$CURRENTVERSION_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25))
$CURRENTVERSION_TITLE_LABEL.ForeColor = [System.Drawing.Color]::White
$CURRENTVERSION_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$CURRENTVERSION_TITLE_LABEL.Name = [System.String]'CURRENTVERSION_TITLE_LABEL'
$CURRENTVERSION_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]94,[System.Int32]23))
$CURRENTVERSION_TITLE_LABEL.TabIndex = [System.Int32]2
$CURRENTVERSION_TITLE_LABEL.Text = [System.String]'Current Version:'
$CURRENTVERSION_TITLE_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#UPDATINGTO_TITLE_LABEL
#
$UPDATINGTO_TITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$UPDATINGTO_TITLE_LABEL.ForeColor = [System.Drawing.Color]::White
$UPDATINGTO_TITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]22))
$UPDATINGTO_TITLE_LABEL.Name = [System.String]'UPDATINGTO_TITLE_LABEL'
$UPDATINGTO_TITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]76,[System.Int32]25))
$UPDATINGTO_TITLE_LABEL.TabIndex = [System.Int32]1
$UPDATINGTO_TITLE_LABEL.Text = [System.String]'Updating To:'
$UPDATINGTO_TITLE_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
#
#MAIN_UPDATE_PROGRESSBAR
#
$MAIN_UPDATE_PROGRESSBAR.ForeColor = [System.Drawing.Color]::Green
$MAIN_UPDATE_PROGRESSBAR.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]20,[System.Int32]200))
$MAIN_UPDATE_PROGRESSBAR.Name = [System.String]'MAIN_UPDATE_PROGRESSBAR'
$MAIN_UPDATE_PROGRESSBAR.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]430,[System.Int32]44))
$MAIN_UPDATE_PROGRESSBAR.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$MAIN_UPDATE_PROGRESSBAR.TabIndex = [System.Int32]0
#
#UPDATER_MAIN_FORM
#
$UPDATER_MAIN_FORM.BackColor = [System.Drawing.Color]::FromArgb(([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)),([System.Int32]([System.Byte][System.Byte]64)))

$UPDATER_MAIN_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]497,[System.Int32]287))
$UPDATER_MAIN_FORM.Controls.Add($MAIN_UPDATER_PANEL)
$UPDATER_MAIN_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$UPDATER_MAIN_FORM.MaximizeBox = $false
$UPDATER_MAIN_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$UPDATER_MAIN_FORM.Text = [System.String]'Updater - FPCA - (Frysix''s Powershell Configurator App)'
$MAIN_UPDATER_PANEL.ResumeLayout($false)
$UPDATER_MAIN_FORM.ResumeLayout($false)
Add-Member -InputObject $UPDATER_MAIN_FORM -Name MAIN_UPDATER_PANEL -Value $MAIN_UPDATER_PANEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name PROGRESS_TEXT_LABEL -Value $PROGRESS_TEXT_LABEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name PROGRESS_NUM_LABEL -Value $PROGRESS_NUM_LABEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name LIVEINFO_TEXTBOX -Value $LIVEINFO_TEXTBOX -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name LIVESTATUS_TEXT_LABEL -Value $LIVESTATUS_TEXT_LABEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name UPDATINGTO_NUM_LABEL -Value $UPDATINGTO_NUM_LABEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name CURRENTVERSION_NUM_LABEL -Value $CURRENTVERSION_NUM_LABEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name CURRENTVERSION_TITLE_LABEL -Value $CURRENTVERSION_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name UPDATINGTO_TITLE_LABEL -Value $UPDATINGTO_TITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $UPDATER_MAIN_FORM -Name MAIN_UPDATE_PROGRESSBAR -Value $MAIN_UPDATE_PROGRESSBAR -MemberType NoteProperty
}
. InitializeComponent
