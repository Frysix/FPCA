Param(
    [Parameter(Mandatory=$true)]
    [hashtable]$Coms,
    [Parameter(Mandatory=$true)]
    [string]$TaskName,
    [Parameter(Mandatory=$true)]
    [string]$ScriptRoot,
    [Parameter(Mandatory=$false)]
    [hashtable]$TaskSettings
)

Try {
    $Coms.Status = "Running"
    $Coms.Comment = "Testing for PowerHelper module's presence"
    $Coms.Progress = 20

    # Import the PowerHelper module
    if (-not (Test-Path -Path "$ScriptRoot\Helper\PowerHelper.psm1")) {
        Throw "PowerHelper module not found at path: $ScriptRoot\Helper\PowerHelper.psm1"
    }

    $Coms.Comment = "Importing PowerHelper module"
    $Coms.Progress = 40

    Import-Module -Name "$ScriptRoot\Helper\PowerHelper.psm1" -Force
    
    $Coms.Comment = "Creating self-deletion task"
    $Coms.Progress = 60

    $result = New-ScheduledSelfDelete -OnRestart -ScriptPath $ScriptRoot

    $Coms.Comment = "Verifying self-deletion task creation"
    $Coms.Progress = 80

    if ($result.Result) {
        $Coms.Comment = "Self-deletion task created and enabled successfully"
        $Coms.Progress = 100
        $Coms.Status = "Completed"
    } else {
        Throw "Failed to create self-deletion task: $($result.Error)"
    }
    
} Catch {
    $Coms.ErrorMessage = "Unable to create or register task for self-deletion with error: $($_.Exception.Message)"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
}
