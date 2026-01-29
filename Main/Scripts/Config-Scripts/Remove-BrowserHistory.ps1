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
$Coms.Comment = "Clearing browser history"
$Coms.Progress = 10

function Remove-BrowserArtifacts {
	Param(
		[Parameter(Mandatory=$true)]
		[string]$BrowserName,
		[Parameter(Mandatory=$true)]
		[string]$DataRoot
	)

	$removedItems = 0
	if (-not (Test-Path -Path $DataRoot)) {
		return $removedItems
	}

	$profileFolders = Get-ChildItem -Path $DataRoot -Directory -ErrorAction SilentlyContinue
	foreach ($profile in $profileFolders) {
		$historyTargets = @(
			"History","History-journal","History Provider Cache","History Provider Cache-journal",
			"Visited Links","Visited Links-journal","Top Sites","Top Sites-journal",
			"Shortcuts","Shortcuts-journal","Network Action Predictor","Network Action Predictor-journal",
			"Web Data","Web Data-journal"
		)
		foreach ($target in $historyTargets) {
			$targetPath = Join-Path -Path $profile.FullName -ChildPath $target
			if (Test-Path -Path $targetPath) {
				Remove-Item -Path $targetPath -Force -ErrorAction SilentlyContinue
				$removedItems++
			}
		}

		$cacheFolders = @(
			"Cache","Code Cache","GPUCache","Service Worker\\CacheStorage",
			"Service Worker\\ScriptCache","IndexedDB","Local Storage","Sessions","Session Storage"
		)
		foreach ($folder in $cacheFolders) {
			$folderPath = Join-Path -Path $profile.FullName -ChildPath $folder
			if (Test-Path -Path $folderPath) {
				Remove-Item -Path $folderPath -Recurse -Force -ErrorAction SilentlyContinue
				$removedItems++
			}
		}
	}

	return $removedItems
}

Try {
	$Coms.Comment = "Stopping browser processes"
	$Coms.Progress = 25

	$processNames = @("chrome","msedge","msedgewebview2","GoogleCrashHandler","GoogleCrashHandler64")
	foreach ($proc in $processNames) {
		Get-Process -Name $proc -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
	}

	Start-Sleep -Seconds 2

	$Coms.Comment = "Removing Chrome history"
	$Coms.Progress = 55

	$summary = [System.Collections.Generic.List[string]]::new()

	$userRoots = Get-ChildItem -Path "C:\Users" -Directory -ErrorAction SilentlyContinue |
		Where-Object { $_.Name -notin @("Public","Default","Default User","All Users") }

	$chromeRemoved = 0
	$edgeRemoved = 0

	foreach ($user in $userRoots) {
		$localAppData = Join-Path -Path $user.FullName -ChildPath "AppData\Local"
		$chromePath = Join-Path -Path $localAppData -ChildPath "Google\Chrome\User Data"
		$edgePath = Join-Path -Path $localAppData -ChildPath "Microsoft\Edge\User Data"

		$chromeRemoved += Remove-BrowserArtifacts -BrowserName "Chrome" -DataRoot $chromePath
		$edgeRemoved += Remove-BrowserArtifacts -BrowserName "Edge" -DataRoot $edgePath
	}

	$summary.Add("Chrome artifacts removed: $chromeRemoved")
	$summary.Add("Edge artifacts removed: $edgeRemoved")

	$Coms.Comment = "Chrome cleanup complete"
	$Coms.Progress = 75

	$Coms.Comment = "Edge cleanup complete"
	$Coms.Progress = 90

	$Coms.Comment = "Browser history cleared"
	$Coms.Progress = 100
	$Coms.Status = "Completed"
	foreach ($line in $summary) {
		Write-Host $line -ForegroundColor Green
	}
	Write-Host "Browser history removal finished" -ForegroundColor Green

} Catch {
	$Coms.ErrorMessage = $_.Exception.Message
	$Coms.Comment = "Failed to clear browser history"
	$Coms.Progress = 0
	$Coms.Status = "Failed"
	Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
