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

$Coms.Status = "Running"
$Coms.Comment = "Configuring keyboard layouts"
$Coms.Progress = 10

Try {
    # Get the selected keyboard layout from TaskSettings
    $selectedLayout = $TaskSettings.InputComboBox
    if (-not $selectedLayout) {
        $selectedLayout = "Keep French CA"  # Default fallback
    }
    
    $Coms.Comment = "Selected layout: $selectedLayout"
    $Coms.Progress = 20
    
    # Map layout choices to their language tag identifiers
    $layoutMap = @{
        "Keep French CA"  = "fr-CA"   # French (Canada)
        "Keep French CMS" = "fr-FR"   # French (France) - CMS variant
        "Keep English CA" = "en-CA"   # English (Canada)
        "Keep English US" = "en-US"   # English (United States)
        "Keep French FR"  = "fr-FR"   # French (France)
    }
    
    # Get the target language tag
    $targetLanguageTag = $layoutMap[$selectedLayout]
    if (-not $targetLanguageTag) {
        throw "Unknown keyboard layout selection: $selectedLayout"
    }
    
    Write-Host "Target language tag: $targetLanguageTag" -ForegroundColor Green
    
    # Get current installed language packs and keyboard layouts
    $Coms.Comment = "Getting current keyboard layouts"
    $Coms.Progress = 30
    
    # Get all installed input methods
    $installedLanguages = Get-WinUserLanguageList
    Write-Host "Currently installed languages:" -ForegroundColor Yellow
    foreach ($lang in $installedLanguages) {
        Write-Host "  - $($lang.LanguageTag) ($($lang.EnglishName))" -ForegroundColor Gray
    }
    
    # Filter to keep only the selected language
    $Coms.Comment = "Removing unwanted keyboard layouts"
    $Coms.Progress = 50
    
    $languagesToKeep = @()
    $removedCount = 0
    
    foreach ($language in $installedLanguages) {
        if ($language.LanguageTag -eq $targetLanguageTag) {
            $languagesToKeep += $language
            Write-Host "Keeping: $($language.LanguageTag) ($($language.EnglishName))" -ForegroundColor Green
        } else {
            Write-Host "Removing: $($language.LanguageTag) ($($language.EnglishName))" -ForegroundColor Red
            $removedCount++
        }
    }
    
    # Check if target language exists
    if ($languagesToKeep.Count -eq 0) {
        # Target language not installed, we need to add it first
        $Coms.Comment = "Installing selected keyboard layout"
        $Coms.Progress = 60
        
        Write-Host "Target language $targetLanguageTag not found. Installing..." -ForegroundColor Yellow
        
        try {
            # Install the language pack if needed
            $languageToAdd = New-WinUserLanguageList -Language $targetLanguageTag
            Set-WinUserLanguageList -LanguageList $languageToAdd -Force
            Write-Host "Successfully installed $targetLanguageTag" -ForegroundColor Green
        } catch {
            throw "Failed to install language $targetLanguageTag`: $($_.Exception.Message)"
        }
    } else {
        # Apply the filtered language list
        $Coms.Comment = "Applying keyboard layout changes"
        $Coms.Progress = 70
        
        try {
            Set-WinUserLanguageList -LanguageList $languagesToKeep -Force
            Write-Host "Successfully updated keyboard layout list" -ForegroundColor Green
        } catch {
            throw "Failed to update keyboard layouts: $($_.Exception.Message)"
        }
    }
    
    # Verify the changes
    $Coms.Comment = "Verifying keyboard layout changes"
    $Coms.Progress = 85
    
    Start-Sleep -Seconds 2  # Give system time to apply changes
    
    $finalLanguages = Get-WinUserLanguageList
    Write-Host "`nFinal keyboard layouts:" -ForegroundColor Yellow
    foreach ($lang in $finalLanguages) {
        Write-Host "  - $($lang.LanguageTag) ($($lang.EnglishName))" -ForegroundColor Gray
    }
    
    # Check if we successfully kept only the target language
    if ($finalLanguages.Count -eq 1 -and $finalLanguages[0].LanguageTag -eq $targetLanguageTag) {
        $Coms.Comment = "Keyboard layouts configured successfully. Removed $removedCount layouts."
        Write-Host "Success: Only $targetLanguageTag keyboard layout is now active" -ForegroundColor Green
    } elseif ($finalLanguages.LanguageTag -contains $targetLanguageTag) {
        $Coms.Comment = "Target layout configured, but other layouts may still be present"
        Write-Host "Partial success: $targetLanguageTag is active, but some other layouts may remain" -ForegroundColor Yellow
    } else {
        throw "Verification failed: Target language $targetLanguageTag not found in final list"
    }
    
    $Coms.Progress = 100
    $Coms.Status = "Completed"
    
    Write-Host "`nNote: You may need to restart or log out/in for all changes to take full effect" -ForegroundColor Cyan
    
} Catch {
    $Coms.ErrorMessage = $_.Exception.Message
    $Coms.Comment = "Failed to configure keyboard layouts"
    $Coms.Progress = 0
    $Coms.Status = "Failed"
    
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You can manually configure keyboard layouts in Windows Settings > Time & Language > Language" -ForegroundColor Yellow
}