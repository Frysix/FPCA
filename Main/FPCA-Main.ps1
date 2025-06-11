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

# Get info from the fpca.info file
$Global:MainHash.FPCAInfo = Get-FromUTF8File -FilePath "$PSScriptRoot\fpca.info"
# Get settings from the Settings.ini file
$Global:MainHash.FPCASettings = Get-FromUTF8File -FilePath "$PSScriptRoot\Settings.ini"
# Set default values in the HashTables.
$Global:UiHash.LaunchType = $LaunchType
$Global:UiHash.FPCAInfo = $Global:MainHash.FPCAInfo
$Global:UiHash.FPCASettings = $Global:MainHash.FPCASettings
$Global:UiHash.PSScriptroot = $PSScriptRoot
$Global:MainHash.ImportButtonMode = "None"
# Initialize bool variable to initial state.
$Global:UiHash.UIClosed = $false
$Global:UiHash.MainFormLoaded = $false
$Global:UiHash.CheckBoxChanged = $false
$Global:UiHash.ButtonClicked = $false
$Global:UiHash.LinkLabelClicked = $false
$Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED = $false
$Global:UiHash.SETTINGS_BUTTON_CLICKED = $false
$Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED = $false
$Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $false
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
}
# Initialize settings related variables.
[int32]$MainLoopRefreshRate = Convert-StringToInt -InputString $Global:MainHash.FPCASettings.General.MainLoopRefreshRate -Default 50
[int32]$ConfigLinkUpdateCounter = Convert-StringToInt -InputString $Global:MainHash.FPCASettings.General.ConfigLinkUpdateCounter -Default 40
[int32]$InternetCheckUpdateCounter = Convert-StringToInt -InputString $Global:MainHash.FPCASettings.General.InternetCheckUpdateCounter -Default 100

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
        . (Join-Path $Global:UiHash.PSScriptroot '\UI-Script\Main-Ui.ps1')

        # Define actions made by the buttons in the main form.
        $SETTINGS_BUTTON.Add_Click({
            if ($Global:UiHash.SETTINGS_BUTTON_CLICKED -eq $false) {
                $Global:UiHash.SETTINGS_BUTTON_CLICKED = $true
                $Global:UiHash.ButtonClicked = $true
            }
        })
        $IMPORT_CONFIG_BUTTON.Add_Click({
            if ($Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED -eq $false) {
                $Global:UiHash.IMPORT_CONFIG_BUTTON_CLICKED = $true
                $Global:UiHash.ButtonClicked = $true
            }
        })
        #Add Button's control to the UiHash for later access.
        $Global:UiHash.SETTINGS_BUTTON = $SETTINGS_BUTTON
        $Global:UiHash.IMPORT_CONFIG_BUTTON = $IMPORT_CONFIG_BUTTON

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

        # Add Label link click event handlers.
        $SYSTEMINFO_LINK_LABEL.Add_Click({
            if ($Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED -eq $false) {
                $Global:UiHash.LinkLabelClicked = $true
                $Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $true
            }
        })
        $CONFIGFILEPATH_LINK_LABEL.Add_Click({
            if ($Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED -eq $false) {
                $Global:UiHash.LinkLabelClicked = $true
                $Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED = $true
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
        # This variable is changed to indicate that the UI has been closed.
        $Global:UiHash.UIClosed = $true
        
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

# Define function to handle task distribution.
function Invoke-Task {
    Param(
        [Parameter(Mandatory=$true)]
        [scriptblock]$TaskScriptBlock
    )
    # INSERT CODE TO HANDLE TASK DISTRIBUTION HERE
}

# Fetching none changing data from the pc for the UI.
# This section gathers system information such as CPU, RAM, GPU, and motherboard details.



# Initialize the MainLoopCounter to 0 and set the MainListener to true.
# Loading these variables before the MainForm is loaded ensures that the main loop can start immediately after the form is ready.

# Wait for the main form to be loaded before proceeding with the main loop.
# This loop will check if the main form is loaded by checking the MainFormLoaded variable in the UiHash.
# If the main form is not loaded after a certain number of iterations, it will display an error message and exit.
$MainFormLoadLoopCounter = 0
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
$Global:MainHash.MainListener = $true

###########################################################################################################################
#                                                                                                                         #
#                                               MAIN APP LOOP STARTS HERE                                                 #
#                                                                                                                         #
###########################################################################################################################


# Main loop to keep the application running.
# This loop will run until the UI is closed, allowing the application to remain responsive.
While ($Global:MainHash.MainListener) {
    # Increment counters to track the number of iterations in the main loop.
    $ConfigLinkUpdateCounter++
    $InternetCheckUpdateCounter++

    # Check if the UI is closed by checking the UIClosed variable in the UiHash.
    # If the UI is closed, set the MainListener to false to exit the loop.
    if ($Global:UiHash.UIClosed) {
        # If the UI is closed, break the loop and exit the script.
        Break
    }

    # Check if the ConfigLinkUpdateCounter has reached 40 iterations.
    # This counter is used to periodically check for updates in the config files.
    if ($ConfigLinkUpdateCounter -gt 40) {
        # Reset the ConfigLinkUpdateCounter to 0.
        $ConfigLinkUpdateCounter = 0
        # Check if the config files exist in the Config folder.
        # If they do, update the ConfigFiles property in the MainHash with the list of config files.
        # Change the ImportButtonMode based on the number of config files found.
        # Asynchronously update the UI label with the path to the config files.
        if (Test-Path -Path "$PSScriptRoot\Config\*.config") {
            $Global:MainHash.ConfigFiles = @(Get-ChildItem -Path "$PSScriptRoot\Config\*.config" | ForEach-Object { $_.Name })
            if ($Global:MainHash.ConfigFiles.Count -eq 1) {
                $Global:MainHash.ImportButtonMode = "Single"
                $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.LinkColor = [System.Drawing.Color]::Green
                $Global:UiHash.CONFIGFILEPATH_LINK_LABEL.Text = "$PSScriptroot\Config\$($Global:MainHash.ConfigFiles[0])"
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

    # Check if the InternetCheckUpdateCounter has reached 100 iterations.
    if ($InternetCheckUpdateCounter -gt 100) {
        # Reset the InternetCheckUpdateCounter to 0.
        $InternetCheckUpdateCounter = 0
        # Check if the internet connection is available.
        # If it is, update the InternetConnection property in the MainHash to true.
        # If it is not, update the InternetConnection property in the MainHash to false.
        if (Get-InternetStatus) {
            $Global:MainHash.InternetConnection = $true
            $Global:UiHash.CONNECTION_TITLE_LABEL.ForeColor = [System.Drawing.Color]::Green
            #$Global:UiHash.CONNECTION_STATUS_PICTUREBOX.Image = [System.Drawing.Image]::FromFile("$PSScriptRoot\Assets\img\Internet-Connected.jpg")
        } else {
            $Global:MainHash.InternetConnection = $false
            $Global:UiHash.CONNECTION_TITLE_LABEL.ForeColor = [System.Drawing.Color]::Red
            #$Global:UiHash.CONNECTION_STATUS_PICTUREBOX.Image = [System.Drawing.Image]::FromFile("$PSScriptRoot\Assets\img\Internet-Disconnected.jpg")
        }
    }

    # UI interaction and event handling.
    # Check if the ButtonClicked flag is set to true in the UiHash.
    if ($Global:UiHash.ButtonClicked) {
        # Reset the ButtonClicked flag to false.
        $Global:UiHash.ButtonClicked = $false

        # Check if the SETTINGS_BUTTON_CLICKED flag is set to true in the UiHash.
        # If it is set, it means that the user has clicked the settings button.
        if ($Global:UiHash.SETTINGS_BUTTON_CLICKED) {
            # Close the main form to prevent further interaction.
            $Global:UiHash.MainForm.Close()

            # CHANGE THIS TO OPEN THE SETTINGS UI WHEN IMPLEMENTED.
            Show-TopMostMessageBox -Message "CODE NOT IMPLEMENTED YET: SETTINGS UI" -Title "FPCA - Error" -Icon "Error" -Owner $Global:UiHash.MainForm

            # Break the loop to prevent further processing in this iteration.
            Break
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
    }

    # Check if the LinkLabelClicked flag is set to true in the UiHash.
    if ($Global:UiHash.LinkLabelClicked) {
        # Reset the LinkLabelClicked flag to false.
        $Global:UiHash.LinkLabelClicked = $false

        # Check if the CONFIGFILEPATH_LINK_LABEL_CLICKED flag is set to true in the UiHash.
        if ($Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED) {
            # If it is set, open the Config folder in File Explorer.
            Start-Process -FilePath "explorer.exe" -ArgumentList "$PSScriptRoot\Config"
            # Reset the CONFIGFILEPATH_LINK_LABEL_CLICKED flag to false after processing the link label click.
            $Global:UiHash.CONFIGFILEPATH_LINK_LABEL_CLICKED = $false
        }

        # Check if the SYSTEMINFO_LINK_LABEL_CLICKED flag is set to true in the UiHash.
        if ($Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED) {
            # If it is set, open the System Information window.
            Start-Process -FilePath "msinfo32.exe"
            # Reset the SYSTEMINFO_LINK_LABEL_CLICKED flag to false after processing the link label click.
            $Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $false
        }
    }
    
    # Sleep for a short duration to prevent high CPU usage.
    Start-Sleep -Milliseconds $MainLoopRefreshRate
}

# End of script.
# Trigger on loop exit.
Exit