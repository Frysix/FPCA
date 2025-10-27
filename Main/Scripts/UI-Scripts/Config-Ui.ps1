$TASK_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$MAIN_TASK_PANEL = $null
[System.Windows.Forms.Panel]$MAIN_TASK_LABEL_PANEL = $null
[System.Windows.Forms.Label]$MAIN_TASKACTIVECOUNT_LABEL = $null
[System.Windows.Forms.Panel]$MAIN_TASK_ELAPSEDTIME_PANEL = $null
[System.Windows.Forms.Label]$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL = $null
[System.Windows.Forms.ProgressBar]$MAIN_TOTALPROGRESS_PROGRESSBAR = $null
[System.Windows.Forms.Panel]$BACKMAIN_TASK_PANEL = $null
[System.Windows.Forms.Panel]$BACKMAIN_TASK_LABEL_PANEL = $null
[System.Windows.Forms.Panel]$BACKMAIN_TASK_ELAPSEDTIME_PANEL = $null
[System.Windows.Forms.Panel]$BACKMAIN_TOTALPROGRESS_PANEL = $null
[System.Windows.Forms.Panel]$MAIN_TOTALPROGRESS_PANEL = $null
[System.Windows.Forms.Panel]$BACKMAIN_CAFFEINE_LABEL_PANEL = $null
[System.Windows.Forms.Panel]$MAIN_CAFFEINE_LABEL_PANEL = $null
[System.Windows.Forms.Label]$MAIN_CAFFEINE_STATUS_LABEL = $null
function InitializeComponent
{
$MAIN_TASK_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASK_LABEL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASKACTIVECOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_ELAPSEDTIME_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TOTALPROGRESS_PROGRESSBAR = (New-Object -TypeName System.Windows.Forms.ProgressBar)
$BACKMAIN_TASK_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$BACKMAIN_TASK_LABEL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$BACKMAIN_TASK_ELAPSEDTIME_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$BACKMAIN_TOTALPROGRESS_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TOTALPROGRESS_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$BACKMAIN_CAFFEINE_LABEL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_CAFFEINE_LABEL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_CAFFEINE_STATUS_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_LABEL_PANEL.SuspendLayout()
$MAIN_TASK_ELAPSEDTIME_PANEL.SuspendLayout()
$BACKMAIN_TASK_PANEL.SuspendLayout()
$BACKMAIN_TASK_LABEL_PANEL.SuspendLayout()
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.SuspendLayout()
$BACKMAIN_TOTALPROGRESS_PANEL.SuspendLayout()
$MAIN_TOTALPROGRESS_PANEL.SuspendLayout()
$BACKMAIN_CAFFEINE_LABEL_PANEL.SuspendLayout()
$MAIN_CAFFEINE_LABEL_PANEL.SuspendLayout()
$TASK_FORM.SuspendLayout()
#
#MAIN_TASK_PANEL
#
$MAIN_TASK_PANEL.AutoScroll = $true
$MAIN_TASK_PANEL.BackColor = [System.Drawing.Color]::LightGray
$MAIN_TASK_PANEL.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::None
$MAIN_TASK_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$MAIN_TASK_PANEL.Name = [System.String]'MAIN_TASK_PANEL'
$MAIN_TASK_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]868,[System.Int32]479))
$MAIN_TASK_PANEL.TabIndex = [System.Int32]0
#
#MAIN_TASK_LABEL_PANEL
#
$MAIN_TASK_LABEL_PANEL.BackColor = [System.Drawing.Color]::LightGray
$MAIN_TASK_LABEL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_LABEL_PANEL.Controls.Add($MAIN_TASKACTIVECOUNT_LABEL)
$MAIN_TASK_LABEL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$MAIN_TASK_LABEL_PANEL.Name = [System.String]'MAIN_TASK_LABEL_PANEL'
$MAIN_TASK_LABEL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]299,[System.Int32]39))
$MAIN_TASK_LABEL_PANEL.TabIndex = [System.Int32]1
#
#MAIN_TASKACTIVECOUNT_LABEL
#
$MAIN_TASKACTIVECOUNT_LABEL.BackColor = [System.Drawing.Color]::Transparent
$MAIN_TASKACTIVECOUNT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]15.75))
$MAIN_TASKACTIVECOUNT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-5,[System.Int32]-4))
$MAIN_TASKACTIVECOUNT_LABEL.Name = [System.String]'MAIN_TASKACTIVECOUNT_LABEL'
$MAIN_TASKACTIVECOUNT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]307,[System.Int32]45))
$MAIN_TASKACTIVECOUNT_LABEL.TabIndex = [System.Int32]1
$MAIN_TASKACTIVECOUNT_LABEL.Text = [System.String]'Tasks Running: 0 / 0'
$MAIN_TASKACTIVECOUNT_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$MAIN_TASKACTIVECOUNT_LABEL.add_Click($MAIN_TASKACTIVECOUNT_LABEL_Click)
#
#MAIN_TASK_ELAPSEDTIME_PANEL
#
$MAIN_TASK_ELAPSEDTIME_PANEL.BackColor = [System.Drawing.Color]::LightGray
$MAIN_TASK_ELAPSEDTIME_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_ELAPSEDTIME_PANEL.Controls.Add($MAIN_TASK_ELAPSEDTIMECOUNT_LABEL)
$MAIN_TASK_ELAPSEDTIME_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$MAIN_TASK_ELAPSEDTIME_PANEL.Name = [System.String]'MAIN_TASK_ELAPSEDTIME_PANEL'
$MAIN_TASK_ELAPSEDTIME_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]299,[System.Int32]39))
$MAIN_TASK_ELAPSEDTIME_PANEL.TabIndex = [System.Int32]2
#
#MAIN_TASK_ELAPSEDTIMECOUNT_LABEL
#
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-5,[System.Int32]-5))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Name = [System.String]'MAIN_TASK_ELAPSEDTIMECOUNT_LABEL'
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]307,[System.Int32]46))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.TabIndex = [System.Int32]3
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Text = [System.String]'Time Elapsed: 00:00:00'
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#
#MAIN_TOTALPROGRESS_PROGRESSBAR
#
$MAIN_TOTALPROGRESS_PROGRESSBAR.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$MAIN_TOTALPROGRESS_PROGRESSBAR.Name = [System.String]'MAIN_TOTALPROGRESS_PROGRESSBAR'
$MAIN_TOTALPROGRESS_PROGRESSBAR.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]860,[System.Int32]42))
$MAIN_TOTALPROGRESS_PROGRESSBAR.TabIndex = [System.Int32]4
#
#BACKMAIN_TASK_PANEL
#
$BACKMAIN_TASK_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$BACKMAIN_TASK_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$BACKMAIN_TASK_PANEL.Controls.Add($MAIN_TASK_PANEL)
$BACKMAIN_TASK_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]65))
$BACKMAIN_TASK_PANEL.Name = [System.String]'BACKMAIN_TASK_PANEL'
$BACKMAIN_TASK_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]876,[System.Int32]487))
$BACKMAIN_TASK_PANEL.TabIndex = [System.Int32]5
#
#BACKMAIN_TASK_LABEL_PANEL
#
$BACKMAIN_TASK_LABEL_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$BACKMAIN_TASK_LABEL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$BACKMAIN_TASK_LABEL_PANEL.Controls.Add($MAIN_TASK_LABEL_PANEL)
$BACKMAIN_TASK_LABEL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
$BACKMAIN_TASK_LABEL_PANEL.Name = [System.String]'BACKMAIN_TASK_LABEL_PANEL'
$BACKMAIN_TASK_LABEL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]307,[System.Int32]47))
$BACKMAIN_TASK_LABEL_PANEL.TabIndex = [System.Int32]6
#
#BACKMAIN_TASK_ELAPSEDTIME_PANEL
#
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.Controls.Add($MAIN_TASK_ELAPSEDTIME_PANEL)
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]581,[System.Int32]12))
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.Name = [System.String]'BACKMAIN_TASK_ELAPSEDTIME_PANEL'
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]307,[System.Int32]47))
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.TabIndex = [System.Int32]7
#
#BACKMAIN_TOTALPROGRESS_PANEL
#
$BACKMAIN_TOTALPROGRESS_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$BACKMAIN_TOTALPROGRESS_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$BACKMAIN_TOTALPROGRESS_PANEL.Controls.Add($MAIN_TOTALPROGRESS_PANEL)
$BACKMAIN_TOTALPROGRESS_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]558))
$BACKMAIN_TOTALPROGRESS_PANEL.Name = [System.String]'BACKMAIN_TOTALPROGRESS_PANEL'
$BACKMAIN_TOTALPROGRESS_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]876,[System.Int32]58))
$BACKMAIN_TOTALPROGRESS_PANEL.TabIndex = [System.Int32]8
#
#MAIN_TOTALPROGRESS_PANEL
#
$MAIN_TOTALPROGRESS_PANEL.BackColor = [System.Drawing.Color]::LightGray
$MAIN_TOTALPROGRESS_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TOTALPROGRESS_PANEL.Controls.Add($MAIN_TOTALPROGRESS_PROGRESSBAR)
$MAIN_TOTALPROGRESS_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$MAIN_TOTALPROGRESS_PANEL.Name = [System.String]'MAIN_TOTALPROGRESS_PANEL'
$MAIN_TOTALPROGRESS_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]868,[System.Int32]50))
$MAIN_TOTALPROGRESS_PANEL.TabIndex = [System.Int32]5
#
#BACKMAIN_CAFFEINE_LABEL_PANEL
#
$BACKMAIN_CAFFEINE_LABEL_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$BACKMAIN_CAFFEINE_LABEL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$BACKMAIN_CAFFEINE_LABEL_PANEL.Controls.Add($MAIN_CAFFEINE_LABEL_PANEL)
$BACKMAIN_CAFFEINE_LABEL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]325,[System.Int32]12))
$BACKMAIN_CAFFEINE_LABEL_PANEL.Name = [System.String]'BACKMAIN_CAFFEINE_LABEL_PANEL'
$BACKMAIN_CAFFEINE_LABEL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]47))
$BACKMAIN_CAFFEINE_LABEL_PANEL.TabIndex = [System.Int32]9
#
#MAIN_CAFFEINE_LABEL_PANEL
#
$MAIN_CAFFEINE_LABEL_PANEL.BackColor = [System.Drawing.Color]::LightGray
$MAIN_CAFFEINE_LABEL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_CAFFEINE_LABEL_PANEL.Controls.Add($MAIN_CAFFEINE_STATUS_LABEL)
$MAIN_CAFFEINE_LABEL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]3))
$MAIN_CAFFEINE_LABEL_PANEL.Name = [System.String]'MAIN_CAFFEINE_LABEL_PANEL'
$MAIN_CAFFEINE_LABEL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]242,[System.Int32]39))
$MAIN_CAFFEINE_LABEL_PANEL.TabIndex = [System.Int32]0
#
#MAIN_CAFFEINE_STATUS_LABEL
#
$MAIN_CAFFEINE_STATUS_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]15.75))
$MAIN_CAFFEINE_STATUS_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-5,[System.Int32]-5))
$MAIN_CAFFEINE_STATUS_LABEL.Name = [System.String]'MAIN_CAFFEINE_STATUS_LABEL'
$MAIN_CAFFEINE_STATUS_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]250,[System.Int32]46))
$MAIN_CAFFEINE_STATUS_LABEL.TabIndex = [System.Int32]0
$MAIN_CAFFEINE_STATUS_LABEL.Text = [System.String]'Caffeine: Off'
$MAIN_CAFFEINE_STATUS_LABEL.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
#
#TASK_FORM
#
$TASK_FORM.BackColor = [System.Drawing.Color]::DimGray
$TASK_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]900,[System.Int32]628))
$TASK_FORM.Controls.Add($BACKMAIN_CAFFEINE_LABEL_PANEL)
$TASK_FORM.Controls.Add($BACKMAIN_TOTALPROGRESS_PANEL)
$TASK_FORM.Controls.Add($BACKMAIN_TASK_ELAPSEDTIME_PANEL)
$TASK_FORM.Controls.Add($BACKMAIN_TASK_LABEL_PANEL)
$TASK_FORM.Controls.Add($BACKMAIN_TASK_PANEL)
$TASK_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$TASK_FORM.MaximizeBox = $false
$TASK_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$TASK_FORM.Text = [System.String]'Configuration - FPCA - (Frysix''s Powershell Configurator App)'
$TASK_FORM.TopMost = $true
$MAIN_TASK_LABEL_PANEL.ResumeLayout($false)
$MAIN_TASK_ELAPSEDTIME_PANEL.ResumeLayout($false)
$BACKMAIN_TASK_PANEL.ResumeLayout($false)
$BACKMAIN_TASK_LABEL_PANEL.ResumeLayout($false)
$BACKMAIN_TASK_ELAPSEDTIME_PANEL.ResumeLayout($false)
$BACKMAIN_TOTALPROGRESS_PANEL.ResumeLayout($false)
$MAIN_TOTALPROGRESS_PANEL.ResumeLayout($false)
$BACKMAIN_CAFFEINE_LABEL_PANEL.ResumeLayout($false)
$MAIN_CAFFEINE_LABEL_PANEL.ResumeLayout($false)
$TASK_FORM.ResumeLayout($false)
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_PANEL -Value $MAIN_TASK_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_LABEL_PANEL -Value $MAIN_TASK_LABEL_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASKACTIVECOUNT_LABEL -Value $MAIN_TASKACTIVECOUNT_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIME_PANEL -Value $MAIN_TASK_ELAPSEDTIME_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIMECOUNT_LABEL -Value $MAIN_TASK_ELAPSEDTIMECOUNT_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TOTALPROGRESS_PROGRESSBAR -Value $MAIN_TOTALPROGRESS_PROGRESSBAR -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name BACKMAIN_TASK_PANEL -Value $BACKMAIN_TASK_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name BACKMAIN_TASK_LABEL_PANEL -Value $BACKMAIN_TASK_LABEL_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name BACKMAIN_TASK_ELAPSEDTIME_PANEL -Value $BACKMAIN_TASK_ELAPSEDTIME_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name BACKMAIN_TOTALPROGRESS_PANEL -Value $BACKMAIN_TOTALPROGRESS_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TOTALPROGRESS_PANEL -Value $MAIN_TOTALPROGRESS_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name BACKMAIN_CAFFEINE_LABEL_PANEL -Value $BACKMAIN_CAFFEINE_LABEL_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_CAFFEINE_LABEL_PANEL -Value $MAIN_CAFFEINE_LABEL_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_CAFFEINE_STATUS_LABEL -Value $MAIN_CAFFEINE_STATUS_LABEL -MemberType NoteProperty
}
. InitializeComponent
