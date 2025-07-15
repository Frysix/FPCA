$TASK_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$MAIN_TASK_PANEL = $null
[System.Windows.Forms.Panel]$MAIN_TASK_LABEL_PANEL = $null
[System.Windows.Forms.Label]$MAIN_TASKACTIVECOUNT_LABEL = $null
[System.Windows.Forms.Label]$MAIN_TASK_LABEL = $null
[System.Windows.Forms.Panel]$MAIN_TASK_ELAPSEDTIME_PANEL = $null
[System.Windows.Forms.Label]$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL = $null
[System.Windows.Forms.Label]$MAIN_TASK_ELAPSEDTIMETITLE_LABEL = $null
[System.Windows.Forms.ProgressBar]$MAIN_TOTALPROGRESS_PROGRESSBAR = $null
function InitializeComponent
{
$MAIN_TASK_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASK_LABEL_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASKACTIVECOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_ELAPSEDTIME_PANEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TOTALPROGRESS_PROGRESSBAR = (New-Object -TypeName System.Windows.Forms.ProgressBar)
$MAIN_TASK_LABEL_PANEL.SuspendLayout()
$MAIN_TASK_ELAPSEDTIME_PANEL.SuspendLayout()
$TASK_FORM.SuspendLayout()
#
#MAIN_TASK_PANEL
#
$MAIN_TASK_PANEL.AutoScroll = $true
$MAIN_TASK_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_TASK_PANEL.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::None
$MAIN_TASK_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]51))
$MAIN_TASK_PANEL.Name = [System.String]'MAIN_TASK_PANEL'
$MAIN_TASK_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]487,[System.Int32]334))
$MAIN_TASK_PANEL.TabIndex = [System.Int32]0
#
#MAIN_TASK_LABEL_PANEL
#
$MAIN_TASK_LABEL_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_TASK_LABEL_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_LABEL_PANEL.Controls.Add($MAIN_TASKACTIVECOUNT_LABEL)
$MAIN_TASK_LABEL_PANEL.Controls.Add($MAIN_TASK_LABEL)
$MAIN_TASK_LABEL_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
$MAIN_TASK_LABEL_PANEL.Name = [System.String]'MAIN_TASK_LABEL_PANEL'
$MAIN_TASK_LABEL_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]330,[System.Int32]34))
$MAIN_TASK_LABEL_PANEL.TabIndex = [System.Int32]1
#
#MAIN_TASKACTIVECOUNT_LABEL
#
$MAIN_TASKACTIVECOUNT_LABEL.BackColor = [System.Drawing.Color]::Transparent
$MAIN_TASKACTIVECOUNT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]15.75))
$MAIN_TASKACTIVECOUNT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]147,[System.Int32]0))
$MAIN_TASKACTIVECOUNT_LABEL.Name = [System.String]'MAIN_TASKACTIVECOUNT_LABEL'
$MAIN_TASKACTIVECOUNT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]157,[System.Int32]33))
$MAIN_TASKACTIVECOUNT_LABEL.TabIndex = [System.Int32]1
$MAIN_TASKACTIVECOUNT_LABEL.Text = [System.String]'0'
#
#MAIN_TASK_LABEL
#
$MAIN_TASK_LABEL.BackColor = [System.Drawing.Color]::Transparent
$MAIN_TASK_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]15.75,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([System.Byte][System.Byte]0)))
$MAIN_TASK_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]3,[System.Int32]0))
$MAIN_TASK_LABEL.Name = [System.String]'MAIN_TASK_LABEL'
$MAIN_TASK_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]154,[System.Int32]31))
$MAIN_TASK_LABEL.TabIndex = [System.Int32]0
$MAIN_TASK_LABEL.Text = [System.String]'Tasks Running:'
#
#MAIN_TASK_ELAPSEDTIME_PANEL
#
$MAIN_TASK_ELAPSEDTIME_PANEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_TASK_ELAPSEDTIME_PANEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_ELAPSEDTIME_PANEL.Controls.Add($MAIN_TASK_ELAPSEDTIMECOUNT_LABEL)
$MAIN_TASK_ELAPSEDTIME_PANEL.Controls.Add($MAIN_TASK_ELAPSEDTIMETITLE_LABEL)
$MAIN_TASK_ELAPSEDTIME_PANEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]348,[System.Int32]12))
$MAIN_TASK_ELAPSEDTIME_PANEL.Name = [System.String]'MAIN_TASK_ELAPSEDTIME_PANEL'
$MAIN_TASK_ELAPSEDTIME_PANEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]151,[System.Int32]34))
$MAIN_TASK_ELAPSEDTIME_PANEL.TabIndex = [System.Int32]2
#
#MAIN_TASK_ELAPSEDTIMECOUNT_LABEL
#
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]73,[System.Int32]10))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Name = [System.String]'MAIN_TASK_ELAPSEDTIMECOUNT_LABEL'
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]73,[System.Int32]17))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.TabIndex = [System.Int32]3
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Text = [System.String]'0:00'
#
#MAIN_TASK_ELAPSEDTIMETITLE_LABEL
#
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL.BackColor = [System.Drawing.Color]::Transparent
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8))
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-1,[System.Int32]10))
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL.Name = [System.String]'MAIN_TASK_ELAPSEDTIMETITLE_LABEL'
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]77,[System.Int32]17))
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL.TabIndex = [System.Int32]0
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL.Text = [System.String]'Time Elapsed:'
#
#MAIN_TOTALPROGRESS_PROGRESSBAR
#
$MAIN_TOTALPROGRESS_PROGRESSBAR.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]391))
$MAIN_TOTALPROGRESS_PROGRESSBAR.Name = [System.String]'MAIN_TOTALPROGRESS_PROGRESSBAR'
$MAIN_TOTALPROGRESS_PROGRESSBAR.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]487,[System.Int32]35))
$MAIN_TOTALPROGRESS_PROGRESSBAR.TabIndex = [System.Int32]4
#
#TASK_FORM
#
$TASK_FORM.BackColor = [System.Drawing.Color]::DimGray
$TASK_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]511,[System.Int32]438))
$TASK_FORM.Controls.Add($MAIN_TOTALPROGRESS_PROGRESSBAR)
$TASK_FORM.Controls.Add($MAIN_TASK_ELAPSEDTIME_PANEL)
$TASK_FORM.Controls.Add($MAIN_TASK_LABEL_PANEL)
$TASK_FORM.Controls.Add($MAIN_TASK_PANEL)
$TASK_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$TASK_FORM.MaximizeBox = $false
$TASK_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$TASK_FORM.Text = [System.String]'Configuration - FPCA - (Frysix''s Powershell Configurator App)'
$TASK_FORM.TopMost = $true
$MAIN_TASK_LABEL_PANEL.ResumeLayout($false)
$MAIN_TASK_ELAPSEDTIME_PANEL.ResumeLayout($false)
$TASK_FORM.ResumeLayout($false)
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_PANEL -Value $MAIN_TASK_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_LABEL_PANEL -Value $MAIN_TASK_LABEL_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASKACTIVECOUNT_LABEL -Value $MAIN_TASKACTIVECOUNT_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_LABEL -Value $MAIN_TASK_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIME_PANEL -Value $MAIN_TASK_ELAPSEDTIME_PANEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIMECOUNT_LABEL -Value $MAIN_TASK_ELAPSEDTIMECOUNT_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIMETITLE_LABEL -Value $MAIN_TASK_ELAPSEDTIMETITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TOTALPROGRESS_PROGRESSBAR -Value $MAIN_TOTALPROGRESS_PROGRESSBAR -MemberType NoteProperty
}
. InitializeComponent
