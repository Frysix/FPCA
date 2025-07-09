$TASK_FORM = New-Object -TypeName System.Windows.Forms.Form
[System.Windows.Forms.Panel]$MAIN_TASK_PANNEL = $null
[System.Windows.Forms.Panel]$MAIN_TASK_LABEL_PANNEL = $null
[System.Windows.Forms.Label]$MAIN_TASKACTIVECOUNT_LABEL = $null
[System.Windows.Forms.Label]$MAIN_TASK_LABEL = $null
[System.Windows.Forms.Panel]$MAIN_TASK_ELAPSEDTIME_PANNEL = $null
[System.Windows.Forms.Label]$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL = $null
[System.Windows.Forms.Label]$MAIN_TASK_ELAPSEDTIMETITLE_LABEL = $null
[System.Windows.Forms.Panel]$MAIN_OVERVIEWTASK_PANNEL = $null
[System.Windows.Forms.ProgressBar]$MAIN_TOTALPROGRESS_PROGRESSBAR = $null
[System.Windows.Forms.Panel]$MAIN_TASKOVERVIEWLABEL_PANNEL = $null
[System.Windows.Forms.Label]$MAIN_OVERVIEW_LABEL = $null
function InitializeComponent
{
$MAIN_TASK_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASK_LABEL_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASK_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASKACTIVECOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_ELAPSEDTIME_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TASK_ELAPSEDTIMETITLE_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_OVERVIEWTASK_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_TOTALPROGRESS_PROGRESSBAR = (New-Object -TypeName System.Windows.Forms.ProgressBar)
$MAIN_TASKOVERVIEWLABEL_PANNEL = (New-Object -TypeName System.Windows.Forms.Panel)
$MAIN_OVERVIEW_LABEL = (New-Object -TypeName System.Windows.Forms.Label)
$MAIN_TASK_LABEL_PANNEL.SuspendLayout()
$MAIN_TASK_ELAPSEDTIME_PANNEL.SuspendLayout()
$MAIN_TASKOVERVIEWLABEL_PANNEL.SuspendLayout()
$TASK_FORM.SuspendLayout()
#
#MAIN_TASK_PANNEL
#
$MAIN_TASK_PANNEL.AutoScroll = $true
$MAIN_TASK_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_TASK_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]51))
$MAIN_TASK_PANNEL.Name = [System.String]'MAIN_TASK_PANNEL'
$MAIN_TASK_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]487,[System.Int32]334))
$MAIN_TASK_PANNEL.TabIndex = [System.Int32]0
#
#MAIN_TASK_LABEL_PANNEL
#
$MAIN_TASK_LABEL_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_TASK_LABEL_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_LABEL_PANNEL.Controls.Add($MAIN_TASKACTIVECOUNT_LABEL)
$MAIN_TASK_LABEL_PANNEL.Controls.Add($MAIN_TASK_LABEL)
$MAIN_TASK_LABEL_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]12))
$MAIN_TASK_LABEL_PANNEL.Name = [System.String]'MAIN_TASK_LABEL_PANNEL'
$MAIN_TASK_LABEL_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]330,[System.Int32]34))
$MAIN_TASK_LABEL_PANNEL.TabIndex = [System.Int32]1
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
#MAIN_TASK_ELAPSEDTIME_PANNEL
#
$MAIN_TASK_ELAPSEDTIME_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_TASK_ELAPSEDTIME_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASK_ELAPSEDTIME_PANNEL.Controls.Add($MAIN_TASK_ELAPSEDTIMECOUNT_LABEL)
$MAIN_TASK_ELAPSEDTIME_PANNEL.Controls.Add($MAIN_TASK_ELAPSEDTIMETITLE_LABEL)
$MAIN_TASK_ELAPSEDTIME_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]348,[System.Int32]12))
$MAIN_TASK_ELAPSEDTIME_PANNEL.Name = [System.String]'MAIN_TASK_ELAPSEDTIME_PANNEL'
$MAIN_TASK_ELAPSEDTIME_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]151,[System.Int32]34))
$MAIN_TASK_ELAPSEDTIME_PANNEL.TabIndex = [System.Int32]2
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
#MAIN_TASK_ELAPSEDTIMECOUNT_LABEL
#
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]8))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]73,[System.Int32]10))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Name = [System.String]'MAIN_TASK_ELAPSEDTIMECOUNT_LABEL'
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]73,[System.Int32]17))
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.TabIndex = [System.Int32]3
$MAIN_TASK_ELAPSEDTIMECOUNT_LABEL.Text = [System.String]'0:00'
#
#MAIN_OVERVIEWTASK_PANNEL
#
$MAIN_OVERVIEWTASK_PANNEL.AutoScroll = $true
$MAIN_OVERVIEWTASK_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_OVERVIEWTASK_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_OVERVIEWTASK_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]505,[System.Int32]51))
$MAIN_OVERVIEWTASK_PANNEL.Name = [System.String]'MAIN_OVERVIEWTASK_PANNEL'
$MAIN_OVERVIEWTASK_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]135,[System.Int32]334))
$MAIN_OVERVIEWTASK_PANNEL.TabIndex = [System.Int32]3
#
#MAIN_TOTALPROGRESS_PROGRESSBAR
#
$MAIN_TOTALPROGRESS_PROGRESSBAR.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]12,[System.Int32]391))
$MAIN_TOTALPROGRESS_PROGRESSBAR.Name = [System.String]'MAIN_TOTALPROGRESS_PROGRESSBAR'
$MAIN_TOTALPROGRESS_PROGRESSBAR.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]628,[System.Int32]35))
$MAIN_TOTALPROGRESS_PROGRESSBAR.TabIndex = [System.Int32]4
#
#MAIN_TASKOVERVIEWLABEL_PANNEL
#
$MAIN_TASKOVERVIEWLABEL_PANNEL.BackColor = [System.Drawing.Color]::DarkGray
$MAIN_TASKOVERVIEWLABEL_PANNEL.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$MAIN_TASKOVERVIEWLABEL_PANNEL.Controls.Add($MAIN_OVERVIEW_LABEL)
$MAIN_TASKOVERVIEWLABEL_PANNEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]505,[System.Int32]12))
$MAIN_TASKOVERVIEWLABEL_PANNEL.Name = [System.String]'MAIN_TASKOVERVIEWLABEL_PANNEL'
$MAIN_TASKOVERVIEWLABEL_PANNEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]135,[System.Int32]34))
$MAIN_TASKOVERVIEWLABEL_PANNEL.TabIndex = [System.Int32]5
#
#MAIN_OVERVIEW_LABEL
#
$MAIN_OVERVIEW_LABEL.BackColor = [System.Drawing.Color]::Transparent
$MAIN_OVERVIEW_LABEL.Font = (New-Object -TypeName System.Drawing.Font -ArgumentList @([System.String]'Segoe UI',[System.Single]15.75))
$MAIN_OVERVIEW_LABEL.Location = (New-Object -TypeName System.Drawing.Point -ArgumentList @([System.Int32]-1,[System.Int32]0))
$MAIN_OVERVIEW_LABEL.Name = [System.String]'MAIN_OVERVIEW_LABEL'
$MAIN_OVERVIEW_LABEL.Size = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]135,[System.Int32]31))
$MAIN_OVERVIEW_LABEL.TabIndex = [System.Int32]0
$MAIN_OVERVIEW_LABEL.Text = [System.String]'Overview'
#
#TASK_FORM
#
$TASK_FORM.BackColor = [System.Drawing.Color]::DimGray
$TASK_FORM.ClientSize = (New-Object -TypeName System.Drawing.Size -ArgumentList @([System.Int32]652,[System.Int32]438))
$TASK_FORM.Controls.Add($MAIN_TASKOVERVIEWLABEL_PANNEL)
$TASK_FORM.Controls.Add($MAIN_TOTALPROGRESS_PROGRESSBAR)
$TASK_FORM.Controls.Add($MAIN_OVERVIEWTASK_PANNEL)
$TASK_FORM.Controls.Add($MAIN_TASK_ELAPSEDTIME_PANNEL)
$TASK_FORM.Controls.Add($MAIN_TASK_LABEL_PANNEL)
$TASK_FORM.Controls.Add($MAIN_TASK_PANNEL)
$TASK_FORM.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$TASK_FORM.MaximizeBox = $false
$TASK_FORM.Name = [System.String]'TASK_FORM'
$TASK_FORM.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$TASK_FORM.Text = [System.String]'Configuration - FPCA - (Frysix''s Powershell Configurator App)'
$TASK_FORM.TopMost = $true
$MAIN_TASK_LABEL_PANNEL.ResumeLayout($false)
$MAIN_TASK_ELAPSEDTIME_PANNEL.ResumeLayout($false)
$MAIN_TASKOVERVIEWLABEL_PANNEL.ResumeLayout($false)
$TASK_FORM.ResumeLayout($false)
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_PANNEL -Value $MAIN_TASK_PANNEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_LABEL_PANNEL -Value $MAIN_TASK_LABEL_PANNEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASKACTIVECOUNT_LABEL -Value $MAIN_TASKACTIVECOUNT_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_LABEL -Value $MAIN_TASK_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIME_PANNEL -Value $MAIN_TASK_ELAPSEDTIME_PANNEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIMECOUNT_LABEL -Value $MAIN_TASK_ELAPSEDTIMECOUNT_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASK_ELAPSEDTIMETITLE_LABEL -Value $MAIN_TASK_ELAPSEDTIMETITLE_LABEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_OVERVIEWTASK_PANNEL -Value $MAIN_OVERVIEWTASK_PANNEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TOTALPROGRESS_PROGRESSBAR -Value $MAIN_TOTALPROGRESS_PROGRESSBAR -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_TASKOVERVIEWLABEL_PANNEL -Value $MAIN_TASKOVERVIEWLABEL_PANNEL -MemberType NoteProperty
Add-Member -InputObject $TASK_FORM -Name MAIN_OVERVIEW_LABEL -Value $MAIN_OVERVIEW_LABEL -MemberType NoteProperty
}
. InitializeComponent
