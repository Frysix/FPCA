# This is the main script that displays the main menu and handles the main functionality of the FPCA application.

# Start-Check.ps1 is used to determine if the application is launched for the first time or not, passing the info through these parameters.
Param(
    [Parameter(Mandatory=$true)]
    [string]$LaunchType
)

# Define Synchronized Hashtables for thread-safe access across the application.
# These hashtables will be used to store application settings, general objects and UI elements.
$Global:MainHash = [hashtable]::Synchronized(@{})
$Global:UiHash = [hashtable]::Synchronized(@{})

# Import the necessary modules for the application.
Import-Module -Name "$PSScriptRoot\Helper\ParsingHelper.psm1" -Force
Import-Module -Name "$PSScriptRoot\Helper\FormHelper.psm1" -Force
Import-Module -Name "$PSScriptRoot\Helper\InternetHelper.psm1" -Force
Import-Module -Name "$PSScriptRoot\Helper\InfoHelper.psm1" -Force

# Get info from the fpca.info file
$Global:MainHash.FPCAInfo = Get-FromUTF8File -FilePath "$PSScriptRoot\fpca.info"
# Get settings from the Settings.ini file
$Global:MainHash.FPCASettings = Get-FromUTF8File -FilePath "$PSScriptRoot\Settings.ini"
# Set default values in the HashTables.
$Global:UiHash.LaunchType = $LaunchType
$Global:UiHash.FPCAInfo = $Global:MainHash.FPCAInfo
$Global:UiHash.FPCASettings = $Global:MainHash.FPCASettings
$Global:UiHash.PSScriptroot = $PSScriptRoot
$Global:MainHash.PSScriptroot = $PSScriptRoot
$Global:MainHash.ImportButtonMode = "None"
$Global:MainHash.PreviousTab = $null
$Global:UiHash.UIClosedFor = ""
# Initialize bool variable to initial state.
$Global:UiHash.UIClosedByUser = $false
$Global:UiHash.StartConfigClosingRunning = $false
$Global:UiHash.MainFormLoaded = $false
$Global:UiHash.CheckBoxChanged = $false
$Global:UiHash.AppCheckBoxChanged = $false
$Global:UiHash.ConfigButtonClicked = $false
$Global:UiHash.PermanentButtonClicked = $false
$Global:UiHash.LinkLabelClicked = $false
$Global:UiHash.AppButtonClicked = $false
$Global:MainHash.AppRefreshRunning = $false
$Global:MainHash.AppRefreshFinished = $false
$Global:UiHash.RefreshUiRequested = $false
$Global:UiHash.REFRESH_APP_BUTTON_CLICKED = $false
$Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED = $false
$Global:UiHash.SETTINGS_BUTTON_CLICKED = $false
$Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED = $false
$Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $false
$Global:UiHash.CONFIG_START_BUTTON_CLICKED = $false
# Initialize hashtable to store CheckBox states.
$Global:MainHash.CheckBoxStates = @{
    GOOGLE_INSTALL_CHECKBOX = $false
    FIREFOX_INSTALL_CHECKBOX = $false
    WINRAR_INSTALL_CHECKBOX = $false
    ACROBAT_INSTALL_CHECKBOX = $false
    SEVENZIP_INSTALL_CHECKBOX = $false
    MACRIUM_INSTALL_CHECKBOX = $false
    DISCORD_INSTALL_CHECKBOX = $false
    STEAM_INSTALL_CHECKBOX = $false
    ZOOM_INSTALL_CHECKBOX = $false
    VLC_INSTALL_CHECKBOX = $false
    STOFFICE_LAUNCH_CHECKBOX = $false
    MORE_LAUNCH_CHECKBOX = $false
    UPWIN_SETTINGS_CHECKBOX = $false
    UPMSSTORE_SETTINGS_CHECKBOX = $false
    CONFEXPLORER_SETTINGS_CHECKBOX = $false
}
# Initialize settings related variables.
[int32]$MainLoopRefreshRate = Convert-StringToInt -InputString $Global:MainHash.FPCASettings.Advanced.MainLoopRefreshRate -Default 50
[int32]$ConfigLinkUpdateCounter = Convert-StringToInt -InputString $Global:MainHash.FPCASettings.Advanced.ConfigLinkUpdateCounter -Default 40
[int32]$InternetCheckUpdateCounter = Convert-StringToInt -InputString $Global:MainHash.FPCASettings.Advanced.InternetCheckUpdateCounter -Default 100
[int32]$RefreshAppLoopCounter = Convert-StringToInt -InputString $Global:MainHash.FPCASettings.Advanced.RefreshAppLoopCounter -Default 250
[int32]$ConfigLinkUpdateCounter_Max = [int32]$ConfigLinkUpdateCounter
[int32]$InternetCheckUpdateCounter_Max = [int32]$InternetCheckUpdateCounter
[int32]$RefreshAppLoopCounter_Max = [int32]$RefreshAppLoopCounter

# Create a runspace for the UI
# This runspace will be used to execute the UI script in a separate thread.
# It allows the UI to run independently of the main script execution.
# The runspace is set to Single Threaded Apartment (STA) state, which is required for Windows Forms.
$UiRunspace = [runspacefactory]::CreateRunspace()
$UiRunspace.ApartmentState = "STA"
$UiRunspace.ThreadOptions = "ReuseThread"
$UiRunspace.Open()
$UiRunspace.SessionStateProxy.SetVariable('UiHash',$Global:UiHash)
$UiPowershell = [powershell]::Create()
$UiPowershell.Runspace = $UiRunspace

# Add the script block that contains the UI code to the PowerShell instance.
# This script block will be executed in the UI runspace.
$Null = $UiPowershell.AddScript({
    # This block is executed in the UI runspace.
    # If it fails, it will catch the exception and display an error message.
    try {
        # Load necessary assemblies for Windows Forms and WPF.
        Add-Type -AssemblyName System.Windows.Forms, System.Drawing, PresentationFramework, PresentationCore
        [System.Windows.Forms.Application]::EnableVisualStyles()
        # Import the FormHelper module for form-related operations.
        Import-Module -Name "$($Global:UiHash['PSScriptroot'])\Helper\FormHelper.psm1" -Force

        # Add the main form to the runspace.
        . (Join-Path $Global:UiHash.PSScriptroot '\UI-Scripts\Main-Ui.ps1')

        # Define actions made by the buttons in the main form.
        $CONFIG_START_BUTTON.Add_Click({
            if ($Global:UiHash.CONFIG_START_BUTTON_CLICKED -eq $false) {
                $Global:UiHash.CONFIG_START_BUTTON_CLICKED = $true
                $Global:UiHash.ConfigButtonClicked = $true
            }
        })
        $SETTINGS_BUTTON.Add_Click({
            if ($Global:UiHash.SETTINGS_BUTTON_CLICKED -eq $false) {
                $Global:UiHash.SETTINGS_BUTTON_CLICKED = $true
                $Global:UiHash.PermanentButtonClicked = $true
            }
        })
        $IMPORT_CONFIG_BUTTON.Add_Click({
            if ($Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED -eq $false) {
                $Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED = $true
                $Global:UiHash.ConfigButtonClicked = $true
            }
        })
        $REFRESH_APP_BUTTON.Add_Click({
            if ($Global:UiHash.REFRESH_APP_BUTTON_CLICKED -eq $false) {
                $Global:UiHash.REFRESH_APP_BUTTON_CLICKED = $true
            }
        })
        #Add Button's control to the UiHash for later access.
        $Global:UiHash.CONFIG_START_BUTTON = $CONFIG_START_BUTTON
        $Global:UiHash.SETTINGS_BUTTON = $SETTINGS_BUTTON
        $Global:UiHash.IMPORT_CONFIG_BUTTON = $IMPORT_CONFIG_BUTTON
        $Global:UiHash.REFRESH_APP_BUTTON = $REFRESH_APP_BUTTON

        # Define config checkbox actions.
        $GOOGLE_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $FIREFOX_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $WINRAR_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $ACROBAT_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $7ZIP_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $MACRIUM_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $DISCORD_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $STEAM_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $ZOOM_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $VLC_INSTALL_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $STOFFICE_LAUNCH_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $MORE_LAUNCH_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $UPWIN_SETTINGS_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $UPMSSTORE_SETTINGS_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $CONFEXPLORER_SETTINGS_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $USECUSTOM_CUSTOMCONFIG_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        $AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.CheckBoxChanged = $true
        })
        # Add checkboxes checkedchanged event handlers for app tab settings.
        $USECUSTOM_APP_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.AppCheckBoxChanged = $true
        })
        $AUTOREFRESH_APP_CHECKBOX.Add_CheckedChanged({
            $Global:UiHash.AppCheckBoxChanged = $true
        })
        # Add CheckBoxes to the UiHash for later access.
        $Global:UiHash.GOOGLE_INSTALL_CHECKBOX = $GOOGLE_INSTALL_CHECKBOX
        $Global:UiHash.FIREFOX_INSTALL_CHECKBOX = $FIREFOX_INSTALL_CHECKBOX
        $Global:UiHash.WINRAR_INSTALL_CHECKBOX = $WINRAR_INSTALL_CHECKBOX
        $Global:UiHash.ACROBAT_INSTALL_CHECKBOX = $ACROBAT_INSTALL_CHECKBOX
        $Global:UiHash.SEVENZIP_INSTALL_CHECKBOX = $7ZIP_INSTALL_CHECKBOX
        $Global:UiHash.MACRIUM_INSTALL_CHECKBOX = $MACRIUM_INSTALL_CHECKBOX
        $Global:UiHash.DISCORD_INSTALL_CHECKBOX = $DISCORD_INSTALL_CHECKBOX
        $Global:UiHash.STEAM_INSTALL_CHECKBOX = $STEAM_INSTALL_CHECKBOX
        $Global:UiHash.ZOOM_INSTALL_CHECKBOX = $ZOOM_INSTALL_CHECKBOX
        $Global:UiHash.VLC_INSTALL_CHECKBOX = $VLC_INSTALL_CHECKBOX
        $Global:UiHash.STOFFICE_LAUNCH_CHECKBOX = $STOFFICE_LAUNCH_CHECKBOX
        $Global:UiHash.MORE_LAUNCH_CHECKBOX = $MORE_LAUNCH_CHECKBOX
        $Global:UiHash.UPWIN_SETTINGS_CHECKBOX = $UPWIN_SETTINGS_CHECKBOX
        $Global:UiHash.UPMSSTORE_SETTINGS_CHECKBOX = $UPMSSTORE_SETTINGS_CHECKBOX
        $Global:UiHash.CONFEXPLORER_SETTINGS_CHECKBOX = $CONFEXPLORER_SETTINGS_CHECKBOX
        $Global:UiHash.USECUSTOM_CUSTOMCONFIG_CHECKBOX = $USECUSTOM_CUSTOMCONFIG_CHECKBOX
        $Global:UiHash.AUTOREFRESH_CUSTOMCONFIG_CHECKBOX = $AUTOREFRESH_CUSTOMCONFIG_CHECKBOX
        # Add app checkboxes to the UiHash for later access.
        $Global:UiHash.USECUSTOM_APP_CHECKBOX = $USECUSTOM_APP_CHECKBOX
        $Global:UiHash.AUTOREFRESH_APP_CHECKBOX = $AUTOREFRESH_APP_CHECKBOX

        # Add Label link click event handlers.
        $SYSTEMINFO_LINK_LABEL.Add_Click({
            if ($Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED -eq $false) {
                $Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $true
                $Global:UiHash.PermanentButtonClicked = $true
            }
        })
        $CONFIGFILEPATH_LINK_LABEL.Add_Click({
            if ($Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED -eq $false) {
                $Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED = $true
                $Global:UiHash.ConfigButtonClicked = $true
            }
        })
        # Add Labels to the UiHash for later access.
        $Global:UiHash.SYSTEMINFO_LINK_LABEL = $SYSTEMINFO_LINK_LABEL
        $Global:UiHash.CONFIGFILEPATH_LINK_LABEL = $CONFIGFILEPATH_LINK_LABEL

        # Add label controls to the UiHash for later access.
        $Global:UiHash.CONNECTION_TITLE_LABEL = $CONNECTION_TITLE_LABEL
        $Global:UiHash.PC_CPU_NAME_LABEL = $PC_CPU_NAME_LABEL
        $Global:UiHash.PC_BOARD_BRANDNAME_LABEL = $PC_BOARD_BRANDNAME_LABEL
        $Global:UiHash.PC_BOARD_MODEL_LABEL = $PC_BOARD_MODEL_LABEL
        $Global:UiHash.PC_GPU_MODEL_LABEL = $PC_GPU_MODEL_LABEL
        $Global:UiHash.PC_RAM_GBCOUNT_LABEL = $PC_RAM_GBCOUNT_LABEL
        $Global:UiHash.PC_RAM_FREQUENCY_LABEL = $PC_RAM_FREQUENCY_LABEL

        # Add picture box controls to the UiHash for later access.
        $Global:UiHash.CONNECTION_STATUS_PICTUREBOX = $CONNECTION_STATUS_PICTUREBOX

        # Add tab controls to the UiHash for later access.
        $Global:UiHash.MAIN_TAB_CONTROL = $MAIN_TAB_CONTROL

        # Add the modular app panel to the UiHash for later access.

        $Timer = New-Object System.Windows.Forms.Timer
        $Timer.Interval = 1000 
        $Timer.Add_Tick({
            # This block is executed every second when the timer ticks.
            # Check if the REFRESH_APP_BUTTON_CLICKED flag is set to true in the UiHash.
            if ($Global:UiHash.REFRESH_APP_BUTTON_CLICKED) {
                $Global:UiHash.NewAppUiObjects = @{}
                # Clear the MODULAR_APP_PANEL controls to remove old UI elements.
                $MODULAR_APP_PANEL.Controls.Clear()
                . (Join-Path $Global:UiHash.PSScriptroot '\Scripts\Gen-App-Ui.ps1') -UiHash $Global:UiHash
                foreach ($section in $Global:UiHash.NewAppUiObjects.Keys) {
                    $Global:UiHash.NewAppUiObjects[$section].Clicked = $false
                    $Global:UiHash.ActiveSection = $section
                    $Global:UiHash.NewAppUiObjects[$section].InstallationState = "Installed"
                    $Global:UiHash.NewAppUiObjects[$section]['button'].Add_Click({
                        # Check if the button has already been clicked
                        if ($Global:UiHash.NewAppUiObjects[$Global:UiHash.ActiveSection].Clicked -eq $false) {
                            # Set the button clicked state to true
                            $Global:UiHash.NewAppUiObjects[$Global:UiHash.ActiveSection].Clicked = $true
                            $Global:UiHash.AppButtonClicked = $true
                        }
                    })
                    $MODULAR_APP_PANEL.Controls.Add($Global:UiHash.NewAppUiObjects[$section].label)
                    $MODULAR_APP_PANEL.Controls.Add($Global:UiHash.NewAppUiObjects[$section].progressbar)
                    $MODULAR_APP_PANEL.Controls.Add($Global:UiHash.NewAppUiObjects[$section].button)
                }
                $Global:UiHash.REFRESH_APP_BUTTON_CLICKED = $false
            }
        })
        $Timer.Start()  # Start the timer to trigger the tick event every second.

        # Add the main form load event handler.
        $MAIN_FORM.Add_Load({
            # This block is executed when the main form is loaded.
            # Set the version number label text to the version from the FPCAInfo.
            $VERSION_NUMBER_LABEL.Text = $Global:UiHash.FPCAInfo.General.Version
            $VERSION_LABEL.ForeColor = [System.Drawing.Color]::Green
            $VERSION_NUMBER_LABEL.ForeColor = [System.Drawing.Color]::Green
            # Check the launch type and display a welcome or update message accordingly.
            if ($Global:UiHash.LaunchType -eq 'FirstLaunch') {
                Show-TopMostMessageBox -Message "Welcome to FPCA!`nVersion: $($Global:UiHash['FPCAInfo']['General']['Version'])`nIf you encounter any bugs, please report them!" -Title "FPCA - Welcome!" -Owner $MAIN_FORM -Icon "Information"
            } elseif ($Global:UiHash.LaunchType -eq 'UpdateLaunch') {
                Show-TopMostMessageBox -Message "FPCA has been updated to Version: $($Global:UiHash['FPCAInfo']['General']['Version'])!`nPlease check the changelog for more information." -Title "FPCA - Update" -Owner $MAIN_FORM -Icon "Information"
            } elseif ($Global:UiHash.LaunchType -eq 'OutdatedLaunch') {
                # If the launch type is OutdatedLaunch, it means the version is outdated.
                # Change color of the version label to red to indicate an outdated version.
                $VERSION_LABEL.ForeColor = [System.Drawing.Color]::Red
                $VERSION_NUMBER_LABEL.ForeColor = [System.Drawing.Color]::Red
            }
            # Set the MainFormLoaded variable to true to indicate that the main form has been loaded.
            # This is used to control the main loop in the script.
            $Global:UiHash.MainFormLoaded = $true
        })
        # Add main form controls to the UiHash for later access.
        $Global:UiHash.MainForm = $MAIN_FORM
        # Display the main form of the application.
        # This is the main entry point for the UI, where the user can interact with the application.
        $MAIN_FORM.ShowDialog()
        # After the dialog is closed, the script will continue executing.

        # Handle for conditional closing of the UI.
        if ($Global:UiHash.UIClosedFor -eq "StartConfig") {
            # Check for last actions before closing the UI and runspace before launching the configuration script.
            While ($Global:UiHash.StartConfigClosingRunning) {
                # Sleep for a short duration to prevent high CPU usage while waiting for the UI to close.
                Start-Sleep -Milliseconds 100
            }
        } else {
            # This variable is changed to indicate that the UI has been closed.
            $Global:UiHash.UIClosedByUser = $true
        }
        
    } catch {
        # If an error occurs during the execution of the UI script, it will be caught here.
        # Display an error message to the user.
        [System.Windows.Forms.MessageBox]::Show("UI failed: $($_.Exception.Message)")
        # Trigger Flags to indicate the loop to close
        $Global:UiHash.MainFormLoaded = $true
        $Global:UiHash.UIClosed = $true
    }
})

# Register an event handler for the InvocationStateChanged event.
# This event is triggered when the state of the PowerShell invocation changes and automatically handles the closing of the runspace when the UI is closed.
$Null = Register-ObjectEvent -InputObject $UiPowershell -EventName InvocationStateChanged -Action {
    $State = $EventArgs.InvocationStateInfo.State
    if ($State -in 'Completed', 'Failed') {
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
    }
}

# Begin invoking the PowerShell instance to run the UI script.
# This starts the execution of the UI script in the runspace.
$UiHandle = $UiPowershell.BeginInvoke()

# This section gathers system information such as CPU, RAM, GPU, and motherboard details.
$CPUinfo = Get-CPUName
$MBinfo = Get-MotherboardInfo
$GPUinfo = Get-GPUName
$Raminfo = Get-RAMInfo

# Initialize the MainLoopCounter to 0 and set the MainListener to true.
# Loading these variables before the MainForm is loaded ensures that the main loop can start immediately after the form is ready.

# Wait for the main form to be loaded before proceeding with the main loop.
# This loop will check if the main form is loaded by checking the MainFormLoaded variable in the UiHash.
# If the main form is not loaded after a certain number of iterations, it will display an error message and exit.
$MainFormLoadLoopCounter = 0
$Global:MainHash.MainListener = $true
While ($Global:UiHash.MainFormLoaded -eq $false) {
    if ($MainFormLoadLoopCounter -gt 500) {
        # If the main form is not loaded after 500 iterations, display an error message and exit.
        [System.Windows.Forms.MessageBox]::Show("Main form failed to load. Please try again or contact support.", "FPCA - Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $Global:MainHash.MainListener = $false
        # Clean up the runspace and PowerShell instance to prevent memory leaks.
        $UiPowershell.EndInvoke($UiHandle)
        $UiPowershell.Runspace.Dispose()
        Break
    }
    # Sleep for a short duration to prevent high CPU usage while waiting for the main form to load.
    Start-Sleep -Milliseconds 100
    # Increment the loop counter to track how many times we've checked for the main form load.
    $MainFormLoadLoopCounter++
}
# Set the MainListener to true to indicate that the main loop should start.

###########################################################################################################################
#                                                                                                                         #
#                                               MAIN APP LOOP STARTS HERE                                                 #
#                                                                                                                         #
###########################################################################################################################

# Assing system information to the UiHash for display in the UI.
$Global:UiHash.PC_CPU_NAME_LABEL.Text = $CPUinfo
$Global:UiHash.PC_BOARD_BRANDNAME_LABEL.Text = $MBinfo.BrandName
$Global:UiHash.PC_BOARD_MODEL_LABEL.Text = $MBinfo.Model
$Global:UiHash.PC_GPU_MODEL_LABEL.Text = $GPUinfo
$Global:UiHash.PC_RAM_GBCOUNT_LABEL.Text = $Raminfo.Amount
$Global:UiHash.PC_RAM_FREQUENCY_LABEL.Text = $Raminfo.Frequency


# Main loop to keep the application running.
# This loop will run until the UI is closed, allowing the application to remain responsive.
While ($Global:MainHash.MainListener) {
    # Increment counters to track the number of iterations in the main loop.
    $ConfigLinkUpdateCounter++
    $InternetCheckUpdateCounter++

    # Check if the UI is closed by checking the UIClosed variable in the UiHash.
    # If the UI is closed, set the MainListener to false to exit the loop.
    if ($Global:UiHash.UIClosedByUser) {
        # If the UI is closed, break the loop and exit the script.
        Break
    }

    # If the UI is minimized, wait until it is restored to continue processing.
    While ($Global:UiHash.MainForm.WindowState -eq [System.Windows.Forms.FormWindowState]::Minimized) {
        # Sleep for a short duration to prevent high CPU usage while waiting for the UI to be restored.
        Start-Sleep -Milliseconds 250
    }

    # Checks to trigger the UI refresh. On tab opening.
    $Global:MainHash.CurrentTab = $Global:UiHash.MAIN_TAB_CONTROL.SelectedTab.Name
    if ($Global:MainHash.CurrentTab -eq "APP_TAB" -and $Global:MainHash.PreviousTab -ne "APP_TAB") {
        if ($Global:UiHash.REFRESH_APP_BUTTON_CLICKED -eq $false) {
            $Global:UiHash.REFRESH_APP_BUTTON_CLICKED = $true
        }
    }
    # Update previous tab for next iteration
    $Global:MainHash.PreviousTab = $Global:MainHash.CurrentTab


    # Check if the InternetCheckUpdateCounter has reached the max defined counter of iterations.
    if ($InternetCheckUpdateCounter -gt $InternetCheckUpdateCounter_Max) {
        # Reset the InternetCheckUpdateCounter to 0.
        [int32]$InternetCheckUpdateCounter = 0
        # Check if the internet connection is available.
        # If it is, update the InternetConnection property in the MainHash to true.
        # If it is not, update the InternetConnection property in the MainHash to false.
        if (Get-InternetStatus) {
            $Global:MainHash.InternetConnection = $true
            $Global:UiHash.CONNECTION_TITLE_LABEL.Text = "Connected"
            $Global:UiHash.CONNECTION_TITLE_LABEL.ForeColor = [System.Drawing.Color]::Green
            #$Global:UiHash.CONNECTION_STATUS_PICTUREBOX.Image = [System.Drawing.Image]::FromFile("$PSScriptRoot\Assets\img\Internet-Connected.jpg")
        } else {
            $Global:MainHash.InternetConnection = $false
            $Global:UiHash.CONNECTION_TITLE_LABEL.Text = "Disconnected"
            $Global:UiHash.CONNECTION_TITLE_LABEL.ForeColor = [System.Drawing.Color]::Red
            #$Global:UiHash.CONNECTION_STATUS_PICTUREBOX.Image = [System.Drawing.Image]::FromFile("$PSScriptRoot\Assets\img\Internet-Disconnected.jpg")
        }
    }

    ###########################################################################################################################
    #                                                                                                                         #
    #                                           PERMANENT BUTTONS HANDLING                                                    #
    #                                                                                                                         #
    ###########################################################################################################################

    if ($Global:UiHash.PermanentButtonClicked) {
        # Reset the PermanentButtonClicked flag to false.
        $Global:UiHash.PermanentButtonClicked = $false
        # Check if the SYSTEMINFO_LINK_LABEL_CLICKED flag is set to true in the UiHash.
        if ($Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED) {
            # If it is set, open the System Information window.
            Start-Process -FilePath "msinfo32.exe"
            # Reset the SYSTEMINFO_LINK_LABEL_CLICKED flag to false after processing the link label click.
            $Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $false
        }

        # Check if the SETTINGS_BUTTON_CLICKED flag is set to true in the UiHash.
        # If it is set, it means that the user has clicked the settings button.
        if ($Global:UiHash.SETTINGS_BUTTON_CLICKED) {
            # Close the main form to prevent further interaction.
            $Global:UiHash.MainForm.Close()

            # CHANGE THIS TO OPEN THE SETTINGS UI WHEN IMPLEMENTED.
            Show-TopMostMessageBox -Message "CODE NOT IMPLEMENTED YET: SETTINGS UI" -Title "FPCA - Error" -Icon "Error"

            # Break the loop to prevent further processing in this iteration.
            Break
        }

    }

    ###########################################################################################################################
    #                                                                                                                         #
    #                                           Config Tab Ui Handles                                                         #
    #                                                                                                                         #
    ###########################################################################################################################


    # Checks only if the user is on the Config tab.
    # This is done to avoid unnecessary processing when the user is on other tabs.
    if ($Global:UiHash.MAIN_TAB_CONTROL.SelectedTab.Name -eq "CONFIG_TAB") {
        # Check if the ConfigLinkUpdateCounter has reached 40 iterations.
        # This counter is used to periodically check for updates in the config files.
        if ($ConfigLinkUpdateCounter -gt $ConfigLinkUpdateCounter_Max) {
            # Reset the ConfigLinkUpdateCounter to 0.
            [int32]$ConfigLinkUpdateCounter = 0
            # Check if the config files exist in the Config folder.
            # If they do, update the ConfigFiles property in the MainHash with the list of config files.
            # Change the ImportButtonMode based on the number of config files found.
            # Asynchronously update the UI label with the path to the config files.
            if (Test-Path -Path "$PSScriptRoot\Assets\config\*.config") {
                $Global:MainHash.ConfigFiles = @(Get-ChildItem -Path "$PSScriptRoot\Assets\config\*.config" | ForEach-Object { $_.Name })
                if ($Global:MainHash.ConfigFiles.Count -eq 1) {
                    $Global:MainHash.ImportButtonMode = "Single"
                    $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.LinkColor = [System.Drawing.Color]::Green
                    $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.Text = "$PSScriptroot\Assets\config\$($Global:MainHash.ConfigFiles[0])"
                } else {
                    $Global:MainHash.ImportButtonMode = "Multiple"
                    $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.LinkColor = [System.Drawing.Color]::Yellow
                    $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.Text = "Multiple config files found! Click to open folder."
                }
            } else {
                $Global:MainHash.ImportButtonMode = "None"
                $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.LinkColor = [System.Drawing.Color]::Red
                $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.Text = "No config files found! Click to open folder."
            }
        }

        # UI interaction and event handling.
        # Check if the ButtonClicked flag is set to true in the UiHash.
        if ($Global:UiHash.ConfigButtonClicked) {
            # Reset the ButtonClicked flag to false.
            $Global:UiHash.ConfigButtonClicked = $false

            # Check if the CONFIGFILEPATH_LINK_LABEL_CLICKED flag is set to true in the UiHash.
            if ($Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED) {
                # If it is set, open the Config folder in File Explorer.
                Start-Process -FilePath "explorer.exe" -ArgumentList "$PSScriptRoot\Assets\config"
                # Reset the CONFIGFILEPATH_LINK_LABEL_CLICKED flag to false after processing the link label click.
                $Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED = $false
            }

            # Check if the CONFIG_START_BUTTON_CLICKED flag is set to true in the UiHash.
            # If it is set, it means that the user has clicked the Start Config button.
            if ($Global:UiHash.CONFIG_START_BUTTON_CLICKED) {
                if (-not ($Global:MainHash.CheckBoxStates.Values -contains $true)) {
                    # If no checkboxes are checked, display a message to the user.
                    Start-Job -ScriptBlock {
                        Param(
                            [string]$ScriptRoot
                        )
                        Import-Module -Name "$ScriptRoot\Helper\FormHelper.psm1" -Force
                        Show-TopMostMessageBox -Message "Please select at least one checkbox to proceed." -Title "FPCA - No Selection" -Icon "Warning"
                    } -ArgumentList $PSScriptroot | Out-Null
                    $Global:UiHash.CONFIG_START_BUTTON_CLICKED = $false
                } else {
                    $Global:UiHash.UIClosedFor = "StartConfig"
                    $Global:UiHash.StartConfigClosingRunning = $true
                    $Global:UiHash.MainForm.Close()
                    $DefaultInfo = Get-FromUTF8File -FilePath "$PSScriptRoot\Assets\defaultconfig\Default.info"
                    $Tasks = @{}
                    foreach ($cb in $Global:MainHash.CheckBoxStates.GetEnumerator()) {
                        if ($cb.Value -eq $true) {
                            foreach ($section in $DefaultInfo.Keys) {
                                if ($DefaultInfo[$section]['Checkbox'] -eq $cb.Key) {
                                    $Tasks[$section] = $DefaultInfo[$section]
                                }
                            }
                        }
                    }
                    foreach ($task in $Tasks.GetEnumerator()) {
                        if ($task.Value['SpecialScript'] -ne "false") {
                            & "$PSScriptRoot\Scripts\$($task.Value['SpecialScript'])"
                        }
                    }
                    $TaskInfoJson = $Tasks | ConvertTo-Json -Compress
                    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\FPCA-Config.ps1`" -TaskInfo `"$TaskInfoJson`""
                    Exit
                }
            }

            # Check if the IMPORT_CONFIG_BUTTON_CLICKED flag is set to true in the UiHash.
            if ($Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED) {

                if ($Global:MainHash.ImportButtonMode -eq "Single") {

                    # CHANGE THIS TO EXECUTE THE SINGLE CONFIG IMPORT CODE.
                    Start-Job -ScriptBlock {
                        Param(
                            [string]$ScriptRoot
                        )
                        Import-Module -Name "$ScriptRoot\Helper\FormHelper.psm1" -Force
                        Show-TopMostMessageBox -Message "CODE NOT IMPLEMENTED YET: SINGLE FILE IMPORT" -Title "FPCA - Error" -Icon "Error"
                    } -ArgumentList $PSScriptroot | Out-Null

                } elseif ($Global:MainHash.ImportButtonMode -eq "Multiple") {

                    # CHANGE THIS TO OPEN THE MULTIPLE FILE IMPORT UI WHEN IMPLEMENTED.
                    Start-Job -ScriptBlock {
                        Param(
                            [string]$ScriptRoot
                        )
                        Import-Module -Name "$ScriptRoot\Helper\FormHelper.psm1" -Force
                        Show-TopMostMessageBox -Message "CODE NOT IMPLEMENTED YET: MULTIPLE FILE IMPORT" -Title "FPCA - Error" -Icon "Error"
                    } -ArgumentList $PSScriptroot | Out-Null

                } elseif ($Global:MainHash.ImportButtonMode -eq "None") {

                    # If the ImportButtonMode is set to None, display a message to the user.
                    Start-Job -ScriptBlock {
                        Param(
                            [string]$ScriptRoot
                        )
                        Import-Module -Name "$ScriptRoot\Helper\FormHelper.psm1" -Force
                        Show-TopMostMessageBox -Message "No config files found! Please add a config file to the Config folder." -Title "FPCA - No Config Files" -Icon "Information" -Owner $Global:UiHash.MainForm
                    } -ArgumentList $PSScriptroot | Out-Null

                } else {
                    # If the ImportButtonMode is not set to Single, Multiple or None, display an error message.
                    # This is a fallback error handling mechanism.
                    # Close the main form to prevent further interaction.
                    $Global:UiHash.MainForm.Close()
                    Show-TopMostMessageBox -Message "Import button broke... Something went terribly wrong..." -Title "FPCA - Error" -Icon "Error"
                    Break
                }
                # Reset the IMPORT_CONFIG_BUTTON_CLICKED flag to false after processing the import button click.
                $Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED = $false
            }

        }

        # Check if the CheckBoxChanged flag is set to true in the UiHash.
        # If it is set, it means that one or more checkboxes have been changed by the user.
        if ($Global:UiHash.CheckBoxChanged) {
            # Reset the CheckBoxChanged flag to false.
            $Global:UiHash.CheckBoxChanged = $false
            if ($Global:UiHash.GOOGLE_INSTALL_CHECKBOX.Checked) {
                # If the Google Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.GOOGLE_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green 
                $Global:MainHash.CheckBoxStates.GOOGLE_INSTALL_CHECKBOX = $true
            } else {
                # If the Google Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.GOOGLE_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.GOOGLE_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.FIREFOX_INSTALL_CHECKBOX.Checked) {
                # If the Firefox Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.FIREFOX_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.FIREFOX_INSTALL_CHECKBOX = $true
            } else {
                # If the Firefox Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.FIREFOX_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.FIREFOX_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.WINRAR_INSTALL_CHECKBOX.Checked) {
                # If the WinRAR Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.WINRAR_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.WINRAR_INSTALL_CHECKBOX = $true
            } else {
                # If the WinRAR Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.WINRAR_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.WINRAR_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.ACROBAT_INSTALL_CHECKBOX.Checked) {
                # If the Acrobat Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.ACROBAT_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.ACROBAT_INSTALL_CHECKBOX = $true
            } else {
                # If the Acrobat Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.ACROBAT_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.ACROBAT_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.SEVENZIP_INSTALL_CHECKBOX.Checked) {
                # If the 7-Zip Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.SEVENZIP_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.SEVENZIP_INSTALL_CHECKBOX = $true
            } else {
                # If the 7-Zip Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.SEVENZIP_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.SEVENZIP_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.MACRIUM_INSTALL_CHECKBOX.Checked) {
                # If the Macrium Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.MACRIUM_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.MACRIUM_INSTALL_CHECKBOX = $true
            } else {
                # If the Macrium Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.MACRIUM_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.MACRIUM_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.DISCORD_INSTALL_CHECKBOX.Checked) {
                # If the Discord Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.DISCORD_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.DISCORD_INSTALL_CHECKBOX = $true
            } else {
                # If the Discord Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.DISCORD_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.DISCORD_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.STEAM_INSTALL_CHECKBOX.Checked) {
                # If the Steam Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.STEAM_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.STEAM_INSTALL_CHECKBOX = $true
            } else {
                # If the Steam Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.STEAM_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.STEAM_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.ZOOM_INSTALL_CHECKBOX.Checked) {
                # If the Zoom Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.ZOOM_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.ZOOM_INSTALL_CHECKBOX = $true
            } else {
                # If the Zoom Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.ZOOM_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.ZOOM_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.VLC_INSTALL_CHECKBOX.Checked) {
                # If the VLC Install checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.VLC_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.VLC_INSTALL_CHECKBOX = $true
            } else {
                # If the VLC Install checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.VLC_INSTALL_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.VLC_INSTALL_CHECKBOX = $false
            }
            if ($Global:UiHash.STOFFICE_LAUNCH_CHECKBOX.Checked) {
                # If the SoftOffice Launch checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.STOFFICE_LAUNCH_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.STOFFICE_LAUNCH_CHECKBOX = $true
            } else {
                # If the SoftOffice Launch checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.STOFFICE_LAUNCH_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.STOFFICE_LAUNCH_CHECKBOX = $false
            }
            if ($Global:UiHash.MORE_LAUNCH_CHECKBOX.Checked) {
                # If the More Launch checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.MORE_LAUNCH_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.MORE_LAUNCH_CHECKBOX = $true
            } else {
                # If the More Launch checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.MORE_LAUNCH_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.MORE_LAUNCH_CHECKBOX = $false
            }
            if ($Global:UiHash.UPWIN_SETTINGS_CHECKBOX.Checked) {
                # If the UPWIN Settings checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.UPWIN_SETTINGS_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.UPWIN_SETTINGS_CHECKBOX = $true
            } else {
                # If the UPWIN Settings checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.UPWIN_SETTINGS_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.UPWIN_SETTINGS_CHECKBOX = $false
            }
            if ($Global:UiHash.UPMSSTORE_SETTINGS_CHECKBOX.Checked) {
                # If the UPMSSTORE Settings checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.UPMSSTORE_SETTINGS_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.UPMSSTORE_SETTINGS_CHECKBOX = $true
            } else {
                # If the UPMSSTORE Settings checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.UPMSSTORE_SETTINGS_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.UPMSSTORE_SETTINGS_CHECKBOX = $false
            }
            if ($Global:UiHash.CONFEXPLORER_SETTINGS_CHECKBOX.Checked) {
                # If the Config Explorer Settings checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.CONFEXPLORER_SETTINGS_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.CheckBoxStates.CONFEXPLORER_SETTINGS_CHECKBOX = $true
            } else {
                # If the Config Explorer Settings checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.CONFEXPLORER_SETTINGS_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.CheckBoxStates.CONFEXPLORER_SETTINGS_CHECKBOX = $false
            }
            if ($Global:UiHash.USECUSTOM_CUSTOMCONFIG_CHECKBOX.Checked) {
                # If the Use Custom Config checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.USECUSTOM_CUSTOMCONFIG_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.UseCustomConfig = $true
            } else {
                # If the Use Custom Config checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.USECUSTOM_CUSTOMCONFIG_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.UseCustomConfig = $false
            }
            if ($Global:UiHash.AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.Checked) {
                # If the Auto Refresh Config checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.AutoRefreshConfig = $true
            } else {
                # If the Auto Refresh Config checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.AUTOREFRESH_CUSTOMCONFIG_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.AutoRefreshConfig = $false
            }

        }

        # INSERT MORE CONFIG TAB HANDLING HERE

    }

    ###########################################################################################################################
    #                                                                                                                         #
    #                                           Application Tab Ui Handles                                                    #
    #                                                                                                                         #
    ###########################################################################################################################
    

    # Check if the user is on the Application tab.
    if ($Global:UiHash.MAIN_TAB_CONTROL.SelectedTab.Name -eq "APP_TAB") {


        if ($Global:MainHash.AutoRefreshApp){
            $RefreshAppLoopCounter++
            if ($RefreshAppLoopCounter -gt $RefreshAppLoopCounter_Max) {
                # Reset the RefreshAppLoopCounter to 0.
                [int32]$RefreshAppLoopCounter = 0
                # Request a refresh of the application UI.
                if ($Global:UiHash.REFRESH_APP_BUTTON_CLICKED -eq $false) {
                    $Global:UiHash.REFRESH_APP_BUTTON_CLICKED = $true
                }
            }
        }

        # Check if the AppCheckBoxChanged flag is set to true in the UiHash.
        if ($Global:UiHash.AppCheckBoxChanged) {
            # Reset the AppCheckBoxChanged flag to false.
            $Global:UiHash.AppCheckBoxChanged = $false

            # Check the state of each checkbox and update the MainHash accordingly.
            if ($Global:UiHash.USECUSTOM_APP_CHECKBOX.Checked) {
                # If the Use Custom App checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.USECUSTOM_APP_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:UiHash.UseCustomApp = $true
            } else {
                # If the Use Custom App checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.USECUSTOM_APP_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:UiHash.UseCustomApp = $false
            }
            if ($Global:UiHash.AUTOREFRESH_APP_CHECKBOX.Checked) {
                # If the Auto Refresh App checkbox is checked, set the state to true in the MainHash.
                $Global:UiHash.AUTOREFRESH_APP_CHECKBOX.ForeColor = [System.Drawing.Color]::Green
                $Global:MainHash.AutoRefreshApp = $true
            } else {
                # If the Auto Refresh App checkbox is unchecked, set the state to false in the MainHash.
                $Global:UiHash.AUTOREFRESH_APP_CHECKBOX.ForeColor = [System.Drawing.Color]::Black
                $Global:MainHash.AutoRefreshApp = $false
            }
        }

        if ($Global:UiHash.AppButtonClicked) {
            # Reset the AppButtonClicked flag to false.
            $Global:UiHash.AppButtonClicked = $false

            foreach ($section in $Global:UiHash.NewAppUiObjects) {
                if ($Global:UiHash.NewAppUiObjects[$section].ButtonClicked) {
                    if ($Global:UiHash.NewAppUiObjects[$section].InstallationState -eq "Installed") {
                        Start-Job -Name "${section}_Download" -ScriptBlock {
                            Param(
                                $Global:UiHash,
                                $section
                            )
                            Start-Process -FilePath "$($Global:UiHash['PSScriptroot'])\Apps-Data\PortableApps$($Global:UiHash.DLinfo[$section].Folder)\$($Global:UiHash.DLinfo[$section].Executable)" -Verb Runas
                        }.AddArgument($Global:UiHash).AddArgument($section) | Out-Null
                    } elseif ($Global:UiHash.NewAppUiObjects[$section].InstallationState -eq "NotInstalled") {

                    }
                }
            }

        }

        # INSERT APPLICATION TAB HANDLING HERE

    }


    ###########################################################################################################################

    # Sleep for a short duration to prevent high CPU usage.
    Start-Sleep -Milliseconds $MainLoopRefreshRate
}

# End of script.
# Trigger on loop exit.
Exit