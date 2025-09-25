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
Try {
    Import-Module -Name "$PSScriptRoot\Helper\ParsingHelper.psm1" -Force
    Import-Module -Name "$PSScriptRoot\Helper\FormHelper.psm1" -Force
    Import-Module -Name "$PSScriptRoot\Helper\InternetHelper.psm1" -Force
    Import-Module -Name "$PSScriptRoot\Helper\InfoHelper.psm1" -Force
    Import-Module -Name "$PSScriptRoot\Helper\PowerHelper.psm1" -Force
} Catch {
    Write-Host "Failed to import required modules. Please ensure they are present in the Helper directory."
    Exit 1
}

if ($LaunchType -ne "test") {
    # Before doing anything, create run the lockfile manager to ensure lockfile creation
    $Result = . "$PSScriptRoot\FPCA-LockManager.ps1" -Create -ProcessID $PID -ScriptPath $PSScriptRoot -LockName "FPCA_Main"
    # Compare the result and handle accordingly
    if ($Result.Status -eq "Running") {
        Show-TopMostMessageBox -Message "An instance of FPCA is already running. Please close it before starting a new one." -Title "FPCA - Instance Running" -Icon "Warning"
        Exit 1
    } elseif ($Result.Status -eq "Failed") {
        Show-TopMostMessageBox -Message "Failed to create lock file. Error: $($Result.Message).`nIf this issue continues, please reinstall the app." -Title "FPCA - Lock Creation Failed" -Icon "Error"
        Exit 1
    }
}

# Get info from the fpca.info file
$Global:MainHash.FPCAInfo = Get-Content -Path "$PSScriptRoot\fpca.info" | ConvertFrom-StringData

# Set default values in the HashTables.
$Global:UiHash.LaunchType = $LaunchType
$Global:UiHash.FPCAInfo = $Global:MainHash.FPCAInfo
$Global:UiHash.FPCASettings = $Global:MainHash.FPCASettings
$Global:UiHash.PSScriptroot = $PSScriptRoot
$Global:MainHash.PSScriptroot = $PSScriptRoot
$Global:MainHash.ImportButtonMode = "None"
$Global:MainHash.PreviousTab = $null
$Global:UiHash.UIClosedFor = ""
$Global:UiHash.AppButtonsFlags = @{}
$Global:UiHash.EnabledMods = @{}
$Global:UiHash.ActiveSettingsValues = @{}
$Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_COUNTER = 0
$InternetCheckUpdateCounter = 0
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
$Global:UiHash.ModEnabledAppCheckBoxChanged = $false
$Global:UiHash.ModEnabledConfigCheckBoxChanged = $false
$Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_PRESENCEFLAG = $false
$Global:UiHash.REFRESH_CONFIG_MODPANEL = $false
$Global:UiHash.REFRESH_APP_PANEL = $false
$Global:UiHash.REFRESH_SETTINGS_TAB = $false
$Global:UiHash.REFRESH_APP_MODPANEL = $false
$Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $false
$Global:UiHash.CONFIG_START_BUTTON_CLICKED = $false
$Global:UiHash.REFRESH_CONFIG_PANEL = $false
$Global:UiHash.REFRESH_CUSTOMCONFIG_PANEL = $false
$Global:UiHash.SAVESETTINGSBUTTON_CLICKED = $false
$Global:UiHash.RESETSETTINGSBUTTON_CLICKED = $false
$Global:UiHash.StartPopUpRunning = $false

# Run Settings Manager to load settings into the ActiveSettingsValues hashtable.
if (Test-Path -Path "$PSScriptRoot\FPCA-SettingsManager.ps1") {
    Write-Host "Loading settings from Settings.ini file..." -ForegroundColor Cyan
    $Result = . "$PSScriptRoot\FPCA-SettingsManager.ps1" -Reload -FirstLoad -UiHash $Global:UiHash
} else {
    Show-TopMostMessageBox -Message "SettingsManager script not found at path: $PSScriptRoot\FPCA-SettingsManager.ps1. Please ensure the file exists." -Title "FPCA - Settings Load Failed" -Icon "Error"
    # Clean up lockfile if created
    if ($LaunchType -ne "test") {
        . "$PSScriptRoot\FPCA-LockManager.ps1" -Remove -ProcessID $PID -ScriptPath $PSScriptRoot -LockName "FPCA_Main"
    }
    Exit 1
}

if ($Result.Result) {
    Write-Host "Settings loaded successfully." -ForegroundColor Green
} else {
    Show-TopMostMessageBox -Message "Failed to load settings. $($Result.Message).`nIf this issue continues, please reinstall the app." -Title "FPCA - Settings Load Failed" -Icon "Error"
    # Clean up lockfile if created
    if ($LaunchType -ne "test") {
        . "$PSScriptRoot\FPCA-LockManager.ps1" -Remove -ProcessID $PID -ScriptPath $PSScriptRoot -LockName "FPCA_Main"
    }
    Exit 1
}

$Result = $null

# Run the modloader script to parse and enable mods.
if (Test-Path -Path "$PSScriptRoot\Mod-Loader.ps1") {
    . "$PSScriptRoot\Mod-Loader.ps1" -UiHash $Global:UiHash
}

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
        . (Join-Path $Global:UiHash.PSScriptroot '\Scripts\UI-Scripts\Main-Ui.ps1')

        # Define actions made by the buttons in the main form.
        $CONFIG_START_BUTTON.Add_Click({
            if ($Global:UiHash.CONFIG_START_BUTTON_CLICKED -eq $false) {
                $Global:UiHash.CONFIG_START_BUTTON_CLICKED = $true
                $Global:UiHash.ConfigButtonClicked = $true
            }
        })

        # Add Button click event handlers.
        $SAVE_SETTINGS_BUTTON.Add_Click({
            if ($Global:UiHash.SAVESETTINGSBUTTON_CLICKED -eq $false) {
                $Global:UiHash.SAVESETTINGSBUTTON_CLICKED = $true
            }
        })
        # Add Button click event handlers.
        $RESET_SETTINGS_BUTTON.Add_Click({
            if ($Global:UiHash.RESETSETTINGSBUTTON_CLICKED -eq $false) {
                $Global:UiHash.RESETSETTINGSBUTTON_CLICKED = $true
            }
        })

        # Add Button's control to the UiHash for later access.
        $Global:UiHash.CONFIG_START_BUTTON = $CONFIG_START_BUTTON

        # Add Label link click event handlers.
        $SYSTEMINFO_LINK_LABEL.Add_Click({
            if ($Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED -eq $false) {
                $Global:UiHash.SYSTEMINFO_LINK_LABEL_CLICKED = $true
                $Global:UiHash.PermanentButtonClicked = $true
            }
        })
    
        # Add Labels to the UiHash for later access.
        $Global:UiHash.SYSTEMINFO_LINK_LABEL = $SYSTEMINFO_LINK_LABEL
        $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL = $SETTINGS_OPERATIONRESULT_LABEL

        # Add label controls to the UiHash for later access.
        $Global:UiHash.CONNECTION_TITLE_LABEL = $CONNECTION_TITLE_LABEL
        $Global:UiHash.PC_CPU_NAME_LABEL = $PC_CPU_NAME_LABEL
        $Global:UiHash.PC_BOARD_BRANDNAME_LABEL = $PC_BOARD_BRANDNAME_LABEL
        $Global:UiHash.PC_BOARD_MODEL_LABEL = $PC_BOARD_MODEL_LABEL
        $Global:UiHash.PC_GPU_MODEL_LABEL = $PC_GPU_MODEL_LABEL
        $Global:UiHash.PC_RAM_GBCOUNT_LABEL = $PC_RAM_GBCOUNT_LABEL
        $Global:UiHash.PC_RAM_FREQUENCY_LABEL = $PC_RAM_FREQUENCY_LABEL

        # Add tab controls to the UiHash for later access.
        $Global:UiHash.MAIN_TAB_CONTROL = $MAIN_TAB_CONTROL

        $Timer = New-Object System.Windows.Forms.Timer
        $Timer.Interval = $Global:UiHash.ActiveSettingsValues.MainUiTimerInterval # Set the timer interval to the value defined in the settings.
        $Timer.Add_Tick({
            # This block is executed every time the timer ticks.
            
            # Check if the timer interval needs to be updated
            if ($Global:UiHash.ActiveSettingsValues.MainUiTimerInterval -ne $Timer.Interval) {
                Write-Host "Updating timer interval from $($Timer.Interval) to $($Global:UiHash.ActiveSettingsValues.MainUiTimerInterval)" -ForegroundColor Cyan
                $Timer.Stop()
                $Timer.Interval = $Global:UiHash.ActiveSettingsValues.MainUiTimerInterval
                $Timer.Start()
            }
            
            if ($MAIN_TAB_CONTROL.SelectedTab.Name -eq "CONFIG_TAB") {

                ### CONFIG TAB HANDLING ###
                if ($Global:UiHash.REFRESH_CONFIG_PANEL) {
                    # Store the current scroll position before refresh
                    $savedScrollPosition = $SCROLL_CONFIG_PANEL.AutoScrollPosition
                    
                    # Suspend layout to prevent flickering during bulk updates
                    $SCROLL_CONFIG_PANEL.SuspendLayout()
                    
                    try {
                        # Clear the CONFIG_TAB and add all 
                        $SCROLL_CONFIG_PANEL.Controls.Clear()
                        
                        # Reset scroll position to top temporarily for proper UI generation
                        $SCROLL_CONFIG_PANEL.AutoScrollPosition = New-Object System.Drawing.Point(0, 0)
                        
                        . "$($Global:UiHash.PSScriptRoot)\Scripts\Ui-Scripts\Gen\Gen-ConfigurationTab-Ui.ps1" -UiHash $Global:UiHash
                        
                        # Add all mod UI elements to the panel
                        foreach ($category in $Global:UiHash.ConfigTabUIElements.Categories.Keys) {
                            $SCROLL_CONFIG_PANEL.Controls.Add($Global:UiHash.ConfigTabUIElements.Categories[$category])
                        }
                        
                        # Add individual config elements
                        foreach ($config in $Global:UiHash.ConfigTabUIElements.Configs.Keys) {
                            foreach ($element in $Global:UiHash.ConfigTabUIElements.Configs[$config].Keys) {
                                if ($element -eq "MainCheckBox" -or $element -eq "CreateShortcutCheckBox" -or $element -eq "RemindDefaultCheckBox") {
                                $Global:UiHash.ConfigTabUIElements.Configs[$config][$element].Add_CheckedChanged({
                                    if ($Global:UiHash.REFRESH_CONFIG_PANEL -eq $false) {
                                        $Global:UiHash.REFRESH_CONFIG_PANEL = $true
                                    }
                                })
                                
                                }
                            $SCROLL_CONFIG_PANEL.Controls.Add($Global:UiHash.ConfigTabUIElements.Configs[$config][$element])
                            }
                        }
                        $Global:UiHash.CONFIG_CHECKBOX_CHECKED = $true
                        $Global:UiHash.REFRESH_CONFIG_PANEL = $false
                    
                    } finally {
                        # Resume layout and trigger a refresh
                        $SCROLL_CONFIG_PANEL.ResumeLayout($true)
                        
                        # Store scroll position for restoration in next timer tick
                        $Global:UiHash.PendingScrollPosition = $savedScrollPosition
                        $Global:UiHash.RestoreScrollPosition = $true
                    }
                }
                if ($Global:UiHash.REFRESH_CONFIG_MODPANEL) {
                    # Store the current scroll position before refresh
                    $savedScrollPosition = $SCROLL_CONFIGMOD_PANEL.AutoScrollPosition
                    
                    # Suspend layout to prevent flickering
                    $SCROLL_CONFIGMOD_PANEL.SuspendLayout()
                    
                    try {
                        # Clear the Mod config panel and generate the custom configuration UI.
                        $SCROLL_CONFIGMOD_PANEL.Controls.Clear()
                        
                        # Reset scroll position to top temporarily for proper UI generation
                        $SCROLL_CONFIGMOD_PANEL.AutoScrollPosition = New-Object System.Drawing.Point(0, 0)
                        
                        . "$($Global:UiHash.PSScriptRoot)\Scripts\Ui-Scripts\Gen\Gen-ConfigurationTabMod-Ui.ps1" -UiHash $Global:UiHash
                        
                        # Add all mod UI elements to the panel
                        foreach ($mod in $Global:UiHash.ConfigTabModUIElements.Keys) {
                            foreach ($element in $Global:UiHash.ConfigTabModUIElements[$mod].Keys) {
                                if ($element -eq "EnableCheckbox") {
                                    $Global:UiHash.ConfigTabModUIElements[$mod][$element].Add_CheckedChanged({
                                        if ($Global:UiHash.ModEnabledConfigCheckBoxChanged -eq $false) {
                                            $Global:UiHash.ModEnabledConfigCheckBoxChanged = $true
                                        }
                                    })
                                }
                                $SCROLL_CONFIGMOD_PANEL.Controls.Add($Global:UiHash.ConfigTabModUIElements[$mod][$element])
                            }
                        }
                        $Global:UiHash.REFRESH_CONFIG_MODPANEL = $false
                    
                    } finally {
                        # Resume layout and trigger a refresh
                        $SCROLL_CONFIGMOD_PANEL.ResumeLayout($true)
                        
                        # Store scroll position for restoration in next timer tick
                        $Global:UiHash.PendingConfigModScrollPosition = $savedScrollPosition
                        $Global:UiHash.RestoreConfigModScrollPosition = $true
                    }
                }

                # Handle scroll position restoration after layout operations are complete
                if ($Global:UiHash.RestoreScrollPosition -and $Global:UiHash.PendingScrollPosition) {
                    $SCROLL_CONFIG_PANEL.AutoScrollPosition = New-Object System.Drawing.Point([Math]::Abs($Global:UiHash.PendingScrollPosition.X), [Math]::Abs($Global:UiHash.PendingScrollPosition.Y))
                    $Global:UiHash.RestoreScrollPosition = $false
                    $Global:UiHash.PendingScrollPosition = $null
                }
                
                if ($Global:UiHash.RestoreConfigModScrollPosition -and $Global:UiHash.PendingConfigModScrollPosition) {
                    $SCROLL_CONFIGMOD_PANEL.AutoScrollPosition = New-Object System.Drawing.Point([Math]::Abs($Global:UiHash.PendingConfigModScrollPosition.X), [Math]::Abs($Global:UiHash.PendingConfigModScrollPosition.Y))
                    $Global:UiHash.RestoreConfigModScrollPosition = $false
                    $Global:UiHash.PendingConfigModScrollPosition = $null
                }

            } elseif ($MAIN_TAB_CONTROL.SelectedTab.Name -eq "APP_TAB") {
                # Check if the REFRESH_APP_BUTTON_CLICKED flag is set to true in the UiHash.
                if ($Global:UiHash.REFRESH_APP_PANEL) {
                    # Store the current scroll position before refresh
                    $savedScrollPosition = $SCROLL_APP_PANEL.AutoScrollPosition
                    
                    # Suspend layout to prevent flickering
                    $SCROLL_APP_PANEL.SuspendLayout()
                    
                    try {
                        # Clear the APP_TAB and add all
                        $SCROLL_APP_PANEL.Controls.Clear()

                        # Reset scroll position to top temporarily for proper UI generation
                        $SCROLL_APP_PANEL.AutoScrollPosition = New-Object System.Drawing.Point(0, 0)

                        . "$($Global:UiHash.PSScriptRoot)\Scripts\Ui-Scripts\Gen\Gen-ApplicationTab-Ui.ps1" -UiHash $Global:UiHash

                        foreach ($type in $Global:UiHash.AppTabUIElements.Keys) {
                            foreach ($element in $Global:UiHash.AppTabUIElements[$type].Keys) {
                                if ($type -eq "Buttons") {
                                    $Global:UiHash.AppButtonsFlags[$element] = $false
                                    # Capture the element variable in a local scope for the closure
                                    $elementCapture = $element
                                    $Global:UiHash.AppTabUIElements[$type][$element].Add_Click({
                                        param($sender, $e)
                                        if ($Global:UiHash.AppButtonsFlags -and $Global:UiHash.AppButtonsFlags.ContainsKey($elementCapture)) {
                                            if ($Global:UiHash.AppButtonsFlags[$elementCapture] -eq $false) {
                                                $Global:UiHash.AppButtonsFlags[$elementCapture] = $true
                                                $Global:UiHash.AppButtonClicked = $true
                                            }
                                        }
                                    }.GetNewClosure())
                                }
                                $SCROLL_APP_PANEL.Controls.Add($Global:UiHash.AppTabUIElements[$type][$element])
                            }
                        }
                        $Global:UiHash.REFRESH_APP_PANEL = $false
                        
                    } finally {
                        # Resume layout and trigger a refresh
                        $SCROLL_APP_PANEL.ResumeLayout($true)
                        
                        # Store scroll position for restoration in next timer tick
                        $Global:UiHash.PendingAppScrollPosition = $savedScrollPosition
                        $Global:UiHash.RestoreAppScrollPosition = $true
                    }
                }
                if ($Global:UiHash.REFRESH_APP_MODPANEL) {
                    # Store the current scroll position before refresh
                    $savedScrollPosition = $SCROLL_APPMOD_PANEL.AutoScrollPosition
                    
                    # Suspend layout to prevent flickering
                    $SCROLL_APPMOD_PANEL.SuspendLayout()
                    
                    try {
                        # Clear the SCROLL_APPMOD_PANEL and add all mod panels directly
                        $SCROLL_APPMOD_PANEL.Controls.Clear()
                        
                        # Reset scroll position to top temporarily for proper UI generation
                        $SCROLL_APPMOD_PANEL.AutoScrollPosition = New-Object System.Drawing.Point(0, 0)
                        
                        . "$($Global:UiHash.PSScriptRoot)\Scripts\Ui-Scripts\Gen\Gen-ApplicationTabMod-Ui.ps1" -UiHash $Global:UiHash
                        
                        # Add all mod UI elements to the SCROLL_APPMOD_PANEL
                        foreach ($mod in $Global:UiHash.AppTabModUIElements.Keys) {
                            foreach ($element in $Global:UiHash.AppTabModUIElements[$mod].Keys) {
                                if ($element -eq "EnableCheckbox") {
                                    $Global:UiHash.AppTabModUIElements[$mod][$element].Add_CheckedChanged({
                                        if ($Global:UiHash.ModEnabledAppCheckBoxChanged -eq $false) {
                                            $Global:UiHash.ModEnabledAppCheckBoxChanged = $true
                                        }
                                    })
                                }
                            $SCROLL_APPMOD_PANEL.Controls.Add($Global:UiHash.AppTabModUIElements[$mod][$element])
                            }
                        }
                    $Global:UiHash.REFRESH_APP_MODPANEL = $false
                    
                    } finally {
                        # Resume layout and trigger a refresh
                        $SCROLL_APPMOD_PANEL.ResumeLayout($true)
                        
                        # Store scroll position for restoration in next timer tick
                        $Global:UiHash.PendingAppModScrollPosition = $savedScrollPosition
                        $Global:UiHash.RestoreAppModScrollPosition = $true
                    }
                }
                
                # Handle scroll position restoration for APP tab panels
                if ($Global:UiHash.RestoreAppScrollPosition -and $Global:UiHash.PendingAppScrollPosition) {
                    $SCROLL_APP_PANEL.AutoScrollPosition = New-Object System.Drawing.Point([Math]::Abs($Global:UiHash.PendingAppScrollPosition.X), [Math]::Abs($Global:UiHash.PendingAppScrollPosition.Y))
                    $Global:UiHash.RestoreAppScrollPosition = $false
                    $Global:UiHash.PendingAppScrollPosition = $null
                }
                
                if ($Global:UiHash.RestoreAppModScrollPosition -and $Global:UiHash.PendingAppModScrollPosition) {
                    $SCROLL_APPMOD_PANEL.AutoScrollPosition = New-Object System.Drawing.Point([Math]::Abs($Global:UiHash.PendingAppModScrollPosition.X), [Math]::Abs($Global:UiHash.PendingAppModScrollPosition.Y))
                    $Global:UiHash.RestoreAppModScrollPosition = $false
                    $Global:UiHash.PendingAppModScrollPosition = $null
                }
            } elseif ($MAIN_TAB_CONTROL.SelectedTab.Name -eq "TOOLS_TAB") {
               
            } elseif ($MAIN_TAB_CONTROL.SelectedTab.Name -eq "SETTINGS_TAB") {
                if ($Global:UiHash.REFRESH_SETTINGS_TAB) {
                    $SETTINGS_TAB_CONTROL.Controls.Clear()
                    . "$($Global:UiHash.PSScriptRoot)\Scripts\Ui-Scripts\Gen\Gen-SettingsTab-Ui.ps1" -UiHash $Global:UiHash
                    foreach ($category in $Global:UiHash.SettingsTabUIElements.Keys) {
                        foreach ($element in $Global:UiHash.SettingsTabUIElements[$category].Keys) {
                            if ($element -eq "CategoryTab") {
                                if ($category -eq "General") {
                                    $SETTINGS_TAB_CONTROL.TabPages.Insert(0, $Global:UiHash.SettingsTabUIElements[$category][$element])
                                } else {
                                    $SETTINGS_TAB_CONTROL.TabPages.Add($Global:UiHash.SettingsTabUIElements[$category][$element])
                                }
                            }
                        }
                    }
                    if ($Global:UiHash.SettingsTabUIElements.Count -gt 0) {
                        $SETTINGS_TAB_CONTROL.SelectedTab = $SETTINGS_TAB_CONTROL.TabPages[0]
                    }
                    $Global:UiHash.REFRESH_SETTINGS_TAB = $false
                }
            }
        })
        $Timer.Start()  # Start the timer to trigger the tick event every second.

        # Add the main form load event handler.
        $MAIN_FORM.Add_Load({
            # This block is executed when the main form is loaded.
            # Set the version number label text to the version from the FPCAInfo.
            $VERSION_NUMBER_LABEL.Text = $Global:UiHash.FPCAInfo.version
            $VERSION_LABEL.ForeColor = [System.Drawing.Color]::Green
            $VERSION_NUMBER_LABEL.ForeColor = [System.Drawing.Color]::Green
            $Global:UiHash.StartPopUpRunning = $true
            # Check the launch type and display a welcome or update message accordingly.
            if ($Global:UiHash.LaunchType -eq 'FirstLaunch') {
                Show-TopMostMessageBox -Message "Welcome to FPCA!`nVersion: $($Global:UiHash.FPCAInfo.version)`nIf you encounter any bugs, please report them!" -Title "FPCA - Welcome!" -Owner $MAIN_FORM -Icon "Information"
            } elseif ($Global:UiHash.LaunchType -eq 'UpdatedLaunch') {
                Show-TopMostMessageBox -Message "FPCA has been updated to Version: $($Global:UiHash.FPCAInfo.version)!`nPlease check the changelog for more information." -Title "FPCA - Update" -Owner $MAIN_FORM -Icon "Information"
            } elseif ($Global:UiHash.LaunchType -eq 'OutdatedLaunch') {
                # If the launch type is OutdatedLaunch, it means the version is outdated.
                # Change color of the version label to red to indicate an outdated version.
                $VERSION_LABEL.ForeColor = [System.Drawing.Color]::Red
                $VERSION_NUMBER_LABEL.ForeColor = [System.Drawing.Color]::Red
            }
            # Set the MainFormLoaded variable to true to indicate that the main form has been loaded.
            # This is used to control the main loop in the script.
            $Global:UiHash.StartPopUpRunning = $false
            $Global:UiHash.MainFormLoaded = $true
        })
        # Check for icon presence and set it if available.
        if (Test-Path -Path "$($Global:UiHash.PSScriptroot)\Assets\img\icons\FPCA_Icon.ico") {
            $MAIN_FORM.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($Global:UiHash.PSScriptroot)\Assets\img\icons\FPCA_Icon.ico")
        }
        # Add timer to the UiHash for later access.
        $Global:UiHash.MainFormTimer = $Timer
        # Add main form controls to the UiHash for later access.
        $Global:UiHash.MainForm = $MAIN_FORM
        # Display the main form of the application.
        # This is the main entry point for the UI, where the user can interact with the application.
        $MAIN_FORM.ShowDialog()
        # After the dialog is closed, the script will continue executing.

        # Handle for conditional closing of the UI.
        if ($Global:UiHash.UIClosedFor -eq "StartConfig") {
            # Check for last actions before closing the UI and runspace before launching the configuration script.
            Exit
        } elseif ($Global:UiHash.UIClosedFor -eq "Settings") {
            # If the UI is closed for settings
            Exit
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
    if ($Global:UiHash.StartPopUpRunning -eq $false) {
        if ($MainFormLoadLoopCounter -gt $Global:UiHash.ActiveSettingsValues.MainFormLoadLoopCounter) {
            # If the main form is not loaded after 500 iterations, display an error message and exit.
            [System.Windows.Forms.MessageBox]::Show("Main form failed to load. Please try again or contact support.", "FPCA - Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            $Global:MainHash.MainListener = $false
            # Clean up the runspace and PowerShell instance to prevent memory leaks.
            $UiPowershell.EndInvoke($UiHandle)
            $UiPowershell.Runspace.Dispose()
            Break
        }
        # Increment the loop counter to track how many times we've checked for the main form load.
        $MainFormLoadLoopCounter++
    }
    # Sleep for a short duration to prevent high CPU usage while waiting for the main form to load.
    Start-Sleep -Milliseconds 300
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
        # Display a message box to inform the user that the application is closing and if they want to delete the application
        $result = [System.Windows.Forms.DialogResult]::No
        if ($Global:UiHash.ActiveSettingsValues.DeleteOnExit -eq "Auto") {
            $result = [System.Windows.Forms.DialogResult]::Yes
        } elseif ($Global:UiHash.ActiveSettingsValues.DeleteOnExit -eq "Prompt") {
            $result = Show-TopMostMessageBox -Message "Do you want to delete FPCA?" -Title "FPCA - Delete Application" -Icon "Question" -Buttons "YesNo"
        }
        # If the user chooses to delete the application, create a scheduled task to delete the application folder.
        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            New-ScheduledSelfDelete -OnTime -DelaySecs 10 -ScriptPath $PSScriptRoot
        }
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
        if ($Global:UiHash.REFRESH_APP_PANEL -eq $false) {
            $Global:UiHash.REFRESH_APP_PANEL = $true
        }
        if ($GLobal:UiHash.REFRESH_APP_MODPANEL -eq $false) {
            $Global:UiHash.REFRESH_APP_MODPANEL = $true
        }
    } elseif ($Global:MainHash.CurrentTab -eq "CONFIG_TAB" -and $Global:MainHash.PreviousTab -ne "CONFIG_TAB") {
        if ($Global:UiHash.REFRESH_CONFIG_PANEL -eq $false) {
            $Global:UiHash.REFRESH_CONFIG_PANEL = $true
        }
        if ($GLobal:UiHash.REFRESH_CONFIG_MODPANEL -eq $false) {
            $Global:UiHash.REFRESH_CONFIG_MODPANEL = $true
        }
    } elseif ($Global:MainHash.CurrentTab -eq "SETTINGS_TAB" -and $Global:MainHash.PreviousTab -ne "SETTINGS_TAB") {
        if ($Global:UiHash.REFRESH_SETTINGS_TAB -eq $false) {
            $Global:UiHash.REFRESH_SETTINGS_TAB = $true
        }
    }
    # Update previous tab for next iteration
    $Global:MainHash.PreviousTab = $Global:MainHash.CurrentTab


    # Check if the InternetCheckUpdateCounter has reached the max defined counter of iterations.
    if ($InternetCheckUpdateCounter -gt $Global:UiHash.ActiveSettingsValues.InternetCheckUpdateCounter) {
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
    }

    ###########################################################################################################################
    #                                                                                                                         #
    #                                           Config Tab Ui Handles                                                         #
    #                                                                                                                         #
    ###########################################################################################################################

    if ($Global:UiHash.MAIN_TAB_CONTROL.SelectedTab.Name -eq "CONFIG_TAB") {

        # UI interaction and event handling.
        # Check if the ButtonClicked flag is set to true in the UiHash.
        if ($Global:UiHash.ConfigButtonClicked) {
            # Reset the ButtonClicked flag to false.
            $Global:UiHash.ConfigButtonClicked = $false
            # Check if the CONFIG_START_BUTTON_CLICKED flag is set to true in the UiHash.
            # If it is set, it means that the user has clicked the Start Config button.
            if ($Global:UiHash.CONFIG_START_BUTTON_CLICKED) {
                # Set the StartConfigClosingRunning flag to true to indicate that the configuration process is starting
                $selectedTasks = @()
                $configSettings = @{}
                foreach ($config in $Global:UiHash.ConfigTabUIElements.Configs.Keys) {
                    if ($Global:UiHash.ConfigTabUIElements.Configs[$config].MainCheckBox.Checked) {
                        $selectedTasks += $config
                    }
                    if ($Global:UiHash.ConfigTabUIElements.Configs[$config].ContainsKey('InputTextBox')) {
                        if (-not $configSettings.ContainsKey($config)) {
                            $configSettings[$config] = @{}
                        }
                        $configSettings[$config].InputText = $Global:UiHash.ConfigTabUIElements.Configs[$config].InputTextBox.Text
                    }
                    if ($Global:UiHash.ConfigTabUIElements.Configs[$config].ContainsKey('InputComboBox')) {
                        if (-not $configSettings.ContainsKey($config)) {
                            $configSettings[$config] = @{}
                        }
                        $configSettings[$config].InputCombo = $Global:UiHash.ConfigTabUIElements.Configs[$config].InputComboBox.SelectedItem
                    }
                    if ($Global:UiHash.ConfigTabUIElements.Configs[$config].ContainsKey('CreateShortcutCheckBox') -and $Global:UiHash.ConfigTabUIElements.Configs[$config].CreateShortcutCheckBox.Checked) {
                        if (-not $configSettings.ContainsKey($config)) {
                            $configSettings[$config] = @{}
                        }
                        $configSettings[$config].CreateShortcut = $true
                    }
                    if ($Global:UiHash.ConfigTabUIElements.Configs[$config].ContainsKey('RemindDefaultCheckBox') -and $Global:UiHash.ConfigTabUIElements.Configs[$config].RemindDefaultCheckBox.Checked) {
                        if (-not $configSettings.ContainsKey($config)) {
                            $configSettings[$config] = @{}
                        }
                        $configSettings[$config].RemindDefault = $true
                    }
                }
                # If the selectedTasks array is not empty, launch the task launcher script with the selected tasks.
                if ($selectedTasks.Count -gt 0) {
                    # Set the UIClosedFor variable to "StartConfig" to indicate that the UI is being closed for configuration.
                    $Global:UiHash.UIClosedFor = "StartConfig"
                    # Close the main form to prevent further interaction.
                    $Global:UiHash.MainForm.Close()
                    # Launch the configuration script with the selected tasks.
                    . "$PSScriptRoot\FPCA-Config.ps1" -SelectedTasks $selectedTasks -SelectedTasksSettings $configSettings -AppSettings $Global:UiHash.ActiveSettingsValues

                    # Check the ExitData for the status on exit of the configuration process.
                    if ($ExitData -eq $null) {
                        Write-Host "Configuration script returned null data." -ForegroundColor Red
                        Show-TopMostMessageBox -Message "Configuration process failed to return status data. The process may have been interrupted." -Title "FPCA - Configuration Error" -Icon "Error"
                    } elseif (-not $ExitData.ContainsKey('Status')) {
                        Write-Host "Configuration script returned incomplete data: Status key missing." -ForegroundColor Red
                        Show-TopMostMessageBox -Message "Configuration process returned incomplete data. Please check the logs." -Title "FPCA - Configuration Error" -Icon "Error"
                    } elseif ($ExitData.Status -eq "Error") {
                        $errorMessage = if ($ExitData.ContainsKey('Message')) { $ExitData.Message } else { "Unknown error occurred" }
                        Write-Host "Configuration script reported error: $errorMessage" -ForegroundColor Red
                        Show-TopMostMessageBox -Message "Configuration process encountered an error: $errorMessage" -Title "FPCA - Configuration Error" -Icon "Error"
                    } elseif ($ExitData.ContainsKey('Status')) {
                        if ($ExitData.Status -eq "Success") {
                            if ($ExitData.ContainsKey('Type')) {
                                Switch ($ExitData.Type) {
                                    "BIOS" {
                                        if ($ExitData.ContainsKey('Messages')) {
                                            $JoinedMessages = $ExitData.Messages -join "`n"
                                            $Result = Show-TopMostMessageBox -Message "Bios restart required because of: $JoinedMessages" -Title "FPCA - Configuration Completed" -Icon "Warning" -Buttons "YesNo"
                                        }
                                        if ($Result -eq [System.Windows.Forms.DialogResult]::No) {
                                            # Do nothing, just exit the application.
                                            Break
                                        }
                                        $Result = Restart-ComputerCustom -BIOS -DelaySecs 10 -MaxRestartAttempts 5
                                    }
                                    "RESTART" {
                                        $Result = Restart-ComputerCustom -Normal -DelaySecs 10 -MaxRestartAttempts 3
                                    }
                                    "SHUTDOWN" {
                                        $Result = Restart-ComputerCustom -Shutdown -DelaySecs 10 -MaxRestartAttempts 3
                                    }
                                }
                                if ($Result.Result) {
                                    Write-Host "System action '$($ExitData.Type)' initiated successfully."
                                    Break
                                }
                            }
                            # If it was a success but no restart/shutdown was required or worked out, fallback to default selected behavior.
                            Switch ($Global:UiHash.ActiveSettingsValues.RestartAfterConfig) {
                                "Prompt" {
                                    $Result = Show-TopMostMessageBox -Message "Configuration completed successfully!`nDo you want to restart now?" -Title "FPCA - Configuration Completed" -Icon "Question" -Buttons "YesNoCancel"
                                    if ($Result -eq [System.Windows.Forms.DialogResult]::Yes) {
                                        $Result = Restart-ComputerCustom -Normal -DelaySecs 10 -MaxRestartAttempts 3
                                        if ($Result.Result) {
                                            Write-Host "System restart initiated successfully."
                                            Break
                                        } else {
                                            Show-TopMostMessageBox -Message "Failed to restart the computer. Please restart manually." -Title "FPCA - Restart Failed" -Icon "Error"
                                            Break
                                        }
                                    } elseif ($Result -eq [System.Windows.Forms.DialogResult]::No) {
                                        # Do nothing, just exit the application.
                                        Break
                                    } elseif ($Result -eq [System.Windows.Forms.DialogResult]::Cancel) {
                                        # Relaunch the application by starting the Start.bat file with elevated privileges.
                                        Start-Process -FilePath "$PSScriptRoot\Start.bat" -WindowStyle Hidden -Verb RunAs
                                        Break
                                    }
                                }
                                "Restart App" {
                                    # Relaunch the application by starting the Start.bat file with elevated privileges.
                                    Start-Process -FilePath "$PSScriptRoot\Start.bat" -WindowStyle Hidden -Verb RunAs
                                    Break
                                }
                                "Restart Computer" {
                                    $Result = Restart-ComputerCustom -Normal -DelaySecs 10 -MaxRestartAttempts 3
                                    if ($Result.Result) {
                                        Write-Host "System restart initiated successfully."
                                        Break
                                    } else {
                                        Show-TopMostMessageBox -Message "Failed to restart the computer. Please restart manually." -Title "FPCA - Restart Failed" -Icon "Error"
                                        Break
                                    }
                                }
                                "Restart in WinRE" {
                                    $Result = Restart-ComputerCustom -WinRE -DelaySecs 10 -MaxRestartAttempts 5
                                    if ($Result.Result) {
                                        Write-Host "System restart into WinRE initiated successfully."
                                        Break
                                    } else {
                                        Show-TopMostMessageBox -Message "Failed to restart the computer into WinRE. Please restart manually." -Title "FPCA - Restart Failed" -Icon "Error"
                                        Break
                                    }
                                }
                                "Shutdown Computer" {
                                    $Result = Restart-ComputerCustom -Shutdown -DelaySecs 10 -MaxRestartAttempts 3
                                    if ($Result.Result) {
                                        Write-Host "System shutdown initiated successfully."
                                        Break
                                    } else {
                                        Show-TopMostMessageBox -Message "Failed to shutdown the computer. Please shutdown manually." -Title "FPCA - Shutdown Failed" -Icon "Error"
                                        Break
                                    }
                                }
                            }
                            # If no valid option is selected, just exit the application.
                            Break
                        } elseif ($ExitData.Status -eq "Cancelled") {
                            $Result = Show-TopMostMessageBox -Message "Configuration was cancelled by the user.`nDo you want to relaunch the application?" -Title "FPCA - Configuration Cancelled" -Icon "Warning" -Buttons "YesNo"
                            if ($Result -eq [System.Windows.Forms.DialogResult]::Yes) {
                                # Relaunch the application by starting the Start.bat file with elevated privileges.
                                Start-Process -FilePath "$PSScriptRoot\Start.bat" -WindowStyle Hidden -Verb RunAs
                            }
                            Break
                        } else {
                            # If the ExitData does not contain a valid status, display an error message and exit the application.
                            Show-TopMostMessageBox -Message "A fatal error occurred during configuration... Please Report this issue!`nThe App will shutdown... " -Title "FPCA - Configuration Error" -Icon "Error"
                            Break
                        }
                    } else {
                        # If the configuration process failed, display an error message and exit the application.
                        Show-TopMostMessageBox -Message "The configuration process failed to return a completion status... Please Report this issue!`nThe App will shutdown... " -Title "FPCA - Configuration Error" -Icon "Error"
                        Break
                    }
                    Break
                } else {
                    # If no tasks are selected, display a message box to inform the user.
                    Show-TopMostMessageBox -Message "No tasks selected. Please select at least one task to start." -Title "FPCA - No Tasks Selected" -Owner $Global:UiHash.MainForm -Icon "Warning"
                    $Global:UiHash.CONFIG_START_BUTTON_CLICKED = $false
                }
            }

        }

        # Check if the ModEnabledConfigCheckBoxChanged flag is set to true in the UiHash.
        if ($Global:UiHash.ModEnabledConfigCheckBoxChanged) {
            # Reset the ModEnabledConfigCheckBoxChanged flag to false.
            $Global:UiHash.ModEnabledConfigCheckBoxChanged = $false
            # loop through mod checkbox states and update the ModEnabled state in the MainHash accordingly.
            foreach ($modElement in $Global:UiHash.ConfigTabModUIElements.Keys) {
                # Add null checks to prevent index errors
                if ($Global:UiHash.ConfigTabModUIElements[$modElement] -and $Global:UiHash.ConfigTabModUIElements[$modElement].EnableCheckbox) {
                    if ($Global:UiHash.ConfigTabModUIElements[$modElement].EnableCheckbox.Checked) {
                        $Global:UiHash.ConfigTabModUIElements[$modElement].EnableCheckbox.ForeColor = [System.Drawing.Color]::Green
                        if ($Global:UiHash.AvailableMods.All -and $Global:UiHash.AvailableMods.All.ContainsKey($modElement)) {
                            # Add the entire mod to EnabledMods if not already present
                            if (-not $Global:UiHash.EnabledMods.ContainsKey($modElement)) {
                                $Global:UiHash.EnabledMods[$modElement] = @{}
                            }
                            if (-not $Global:UiHash.EnabledMods[$modElement].ContainsKey('Information')) {
                                $Global:UiHash.EnabledMods[$modElement].Information = $Global:UiHash.AvailableMods.All[$modElement].Information
                            }
                            if (-not ($Global:UiHash.EnabledMods[$modElement].ContainsKey('Mod_Data'))) {
                                $Global:UiHash.EnabledMods[$modElement].Mod_Data = @{}
                            }
                            $Global:UiHash.EnabledMods[$modElement].Mod_Data += @{
                                Configuration = $Global:UiHash.AvailableMods.All[$modElement].Mod_Data.Configuration
                            }
                        }
                    } else {
                        $Global:UiHash.ConfigTabModUIElements[$modElement].EnableCheckbox.ForeColor = [System.Drawing.Color]::Black
                        if ($Global:UiHash.EnabledMods.ContainsKey($modElement)) {
                            if ($Global:UiHash.EnabledMods[$modElement].Mod_Data.ContainsKey('Configuration')) {
                                $Global:UiHash.EnabledMods[$modElement].Mod_Data.Remove('Configuration')
                            }
                            if ($Global:UiHash.EnabledMods[$modElement].Mod_Data.Count -eq 0) {
                                $Global:UiHash.EnabledMods.Remove($modElement)
                            }
                        }
                    }
                }
            }
            $Global:UiHash.REFRESH_CONFIG_MODPANEL = $true
        }

    }

    ###########################################################################################################################
    #                                                                                                                         #
    #                                           Application Tab Ui Handles                                                    #
    #                                                                                                                         #
    ###########################################################################################################################
    

    # Check if the user is on the Application tab.
    if ($Global:UiHash.MAIN_TAB_CONTROL.SelectedTab.Name -eq "APP_TAB") {
        # INSERT APPLICATION TAB HANDLING HERE

        # Check if the ModEnabledAppCheckBoxChanged flag is set to true in the UiHash.
        if ($Global:UiHash.ModEnabledAppCheckBoxChanged) { 
            # Reset the ModEnabledAppCheckBoxChanged flag to false.
            $Global:UiHash.ModEnabledAppCheckBoxChanged = $false
            # loop through mod checkbox states and update the ModEnabled state in the MainHash accordingly.
            foreach ($modElement in $Global:UiHash.AppTabModUIElements.Keys) {
                # Add null checks to prevent index errors
                if ($Global:UiHash.AppTabModUIElements[$modElement] -and $Global:UiHash.AppTabModUIElements[$modElement].EnableCheckbox) {
                    if ($Global:UiHash.AppTabModUIElements[$modElement].EnableCheckbox.Checked) {
                        $Global:UiHash.AppTabModUIElements[$modElement].EnableCheckbox.ForeColor = [System.Drawing.Color]::Green
                        if ($Global:UiHash.AvailableMods.All -and $Global:UiHash.AvailableMods.All.ContainsKey($modElement)) {
                            # Add the entire mod to EnabledMods if not already present
                            if (-not $Global:UiHash.EnabledMods.ContainsKey($modElement)) {
                                $Global:UiHash.EnabledMods[$modElement] = @{}
                            }
                            if (-not $Global:UiHash.EnabledMods[$modElement].ContainsKey('Information')) {
                                $Global:UiHash.EnabledMods[$modElement].Information = $Global:UiHash.AvailableMods.All[$modElement].Information
                            }
                            if (-not ($Global:UiHash.EnabledMods[$modElement].ContainsKey('Mod_Data'))) {
                                $Global:UiHash.EnabledMods[$modElement].Mod_Data = @{}
                            }
                            $Global:UiHash.EnabledMods[$modElement].Mod_Data += @{
                                Applications = $Global:UiHash.AvailableMods.All[$modElement].Mod_Data.Applications
                            }
                        }
                    } else {
                        $Global:UiHash.AppTabModUIElements[$modElement].EnableCheckbox.ForeColor = [System.Drawing.Color]::Black
                        if ($Global:UiHash.EnabledMods.ContainsKey($modElement)) {
                            if ($Global:UiHash.EnabledMods[$modElement].Mod_Data.ContainsKey('Applications')) {
                                $Global:UiHash.EnabledMods[$modElement].Mod_Data.Remove('Applications')
                            }
                            if ($Global:UiHash.EnabledMods[$modElement].Mod_Data.Count -eq 0) {
                                $Global:UiHash.EnabledMods.Remove($modElement)
                            }
                        }
                    }
                }
            }
            $Global:UiHash.REFRESH_APP_PANEL = $true
        }
        if ($Global:UiHash.AppButtonClicked) {
            $Global:UiHash.AppButtonClicked = $false
            # Handle application tab button clicks here.
            # Create a copy of the keys to avoid collection modification during enumeration
            $ButtonKeys = @($Global:UiHash.AppButtonsFlags.Keys)
            foreach ($key in $ButtonKeys) {
                if ($Global:UiHash.AppButtonsFlags[$key]) {
                    if ($key -match "_InstallButton") {
                        if ($key -match "Portable_") {
                            Write-Host "Button: $key pressed, it is a Portable App installation"
                        } elseif ($key -match "Installer_") {
                            Write-Host "Button: $key pressed, it is and Installer App installation"
                        }
                    }
                    $Global:UiHash.AppButtonsFlags[$key] = $false
                }
            }
        }
    }

    ###########################################################################################################################
    #                                                                                                                         #
    #                                           Settings Tab Ui Handles                                                       #
    #                                                                                                                         #
    ###########################################################################################################################

    if ($Global:UiHash.MAIN_TAB_CONTROL.SelectedTab.Name -eq "SETTINGS_TAB") {
        # UI interaction and event handling.
        # Settings Update operation handling
        # Saving Settings
        if ($Global:UiHash.SAVESETTINGSBUTTON_CLICKED) {
            Write-Host "Save Settings button clicked, saving settings..." -ForegroundColor Yellow
            $result = . "$PSScriptRoot\FPCA-SettingsManager.ps1" -Save -UiHash $Global:UiHash
            if ($result.Result) {
                Write-Host "Operation Result: $($result.Message)" -ForegroundColor Green
                $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.ForeColor = [System.Drawing.Color]::Green
                $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.Text = $result.Message
                $Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_PRESENCEFLAG = $true
            } else {
                Write-Host "Operation Result: $($result.Message)" -ForegroundColor Red
                $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.ForeColor = [System.Drawing.Color]::Red
                $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.Text = $result.Message
                $Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_PRESENCEFLAG = $true
            }
            $Global:UiHash.SAVESETTINGSBUTTON_CLICKED = $false
        }
        # Resetting Settings
        if ($Global:UiHash.RESETSETTINGSBUTTON_CLICKED) {
            $confirm = Show-TopMostMessageBox -Message "Are you sure you want to reset all settings to default?" -Title "FPCA - Confirm Reset" -Icon "Warning" -Buttons "YesNo" -Owner $Global:UiHash.MainForm
            if ($confirm -eq [System.Windows.Forms.DialogResult]::Yes) {
                Write-Host "Reset Settings button clicked, resetting settings to default..." -ForegroundColor Yellow
                $result = . "$PSScriptRoot\FPCA-SettingsManager.ps1" -Reset -UiHash $Global:UiHash
                if ($result.Result) {
                    Write-Host "Operation Result: $($result.Message)" -ForegroundColor Green
                    $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.ForeColor = [System.Drawing.Color]::Green
                    $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.Text = $result.Message
                    $Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_PRESENCEFLAG = $true
                } else {
                    Write-Host "Operation Result: $($result.Message)" -ForegroundColor Red
                    $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.ForeColor = [System.Drawing.Color]::Red
                    $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.Text = $result.Message
                    $Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_PRESENCEFLAG = $true
                }
            }
            $Global:UiHash.RESETSETTINGSBUTTON_CLICKED = $false
        }
        if ($Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_PRESENCEFLAG) {
            if ($Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_COUNTER -gt $Global:UiHash.ActiveSettingsValues.SettingsOpResultCounterThreshold) {
                $Global:UiHash.SETTINGS_OPERATIONRESULT_LABEL.Text = ""
                $Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_COUNTER = 0
                $Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_PRESENCEFLAG = $false
            } else {
                $Global:MainHash.SETTINGS_OPERATIONRESULT_LABEL_COUNTER++
            }
        }
    }

    # Sleep for a short duration to prevent high CPU usage.
    Start-Sleep -Milliseconds $Global:UiHash.ActiveSettingsValues.MainLoopRefreshRate
}

# End of script.
# Trigger on loop exit.
Exit