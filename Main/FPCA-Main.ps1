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

# Define a function to read and parse UTF-8 encoded files according to ini format.
function Get-FromUTF8File {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    $info = @{}
    $section = ""
    # Parse the files content
    foreach ($line in Get-Content $FilePath) {
        $line = $line.Trim()
        if ($line -match "^\s*#|^\s*;|^\s*$") {
            continue
        }
        if ($line -match "^\[(.+)\]$") {
            $section = $matches[1]
            $info[$section] = @{}
        } elseif ($line -match "^(.*?)=(.*)$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            if ($section -ne "") {
                $info[$section][$key] = $value
            }
        }
    }
    return $info
}

# Get info from the fpca.info file
$Global:MainHash.FPCAInfo = Get-FromUTF8File -FilePath "$PSScriptRoot\fpca.info"
# Get settings from the Settings.ini file
$Global:MainHash.FPCASettings = Get-FromUTF8File -FilePath "$PSScriptRoot\Settings.ini"
# Set default values in the HashTables.
$Global:UiHash.LaunchType = $LaunchType
$Global:UiHash.FPCAInfo = $Global:MainHash.FPCAInfo
$Global:UiHash.FPCASettings = $Global:MainHash.FPCASettings
$Global:UiHash.PSScriptroot = $PSScriptRoot


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

        # If this is the first launch, launch the welcome message.
        if ($Global:UiHash.LaunchType -eq 'FirstLaunch') {
            [System.Windows.Forms.MessageBox]::Show("Welcome to FPCA!`nVersion: $($Global:UiHash['FPCAInfo']['General']['Version'])`nIf you encounter any bugs please report them!", "FPCA - Welcome!", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }

        # Add the main form to the runspace.
        . (Join-Path $Global:UiHash.PSScriptroot '\UI-Script\Main-Ui.ps1')
        # Block to add buttons and other UI elements to the main form.
        # Also serves to add form objects to the UiHash for later access.

        ### INSERT UI CODE HERE ###

        # Display the main form of the application.
        # This is the main entry point for the UI, where the user can interact with the application.
        $MAIN_FORM.ShowDialog()
        # After the dialog is closed, the script will continue to run.

        # This variable is changed to indicate that the UI has been closed.
        $Global:UiHash.UIClosed = $true
        
    } catch {
        [System.Windows.Forms.MessageBox]::Show("UI failed: $($_.Exception.Message)")
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

# Wait for the UI to close
while ($UiPowershell.InvocationStateInfo.State -eq 'Running') {
    Start-Sleep -Milliseconds 200
}