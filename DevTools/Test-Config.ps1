# script to test the config UI without launching the main UI.
# This script is intended for development and testing purposes only.
$ParentFolder = Split-Path -Parent $PSScriptRoot
$ConfigScriptPath = "$ParentFolder\Main\FPCA-Config.ps1"

# Define the selected tasks and loaded configurations for testing
$SelectedTasks = @("CHROME","FIREFOX")
$LoadedModConfigs = @()


# Launch the configuration script with the selected tasks and loaded configurations
. $ConfigScriptPath -SelectedTasks $SelectedTasks -LoadedModConfigs $LoadedModConfigs