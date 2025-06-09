# Script to help package Main folder into a zip file.
# This script requires the github repository's structure

# Get the parent folder of the script
$ParentFolder = Split-Path -Parent $PSScriptRoot

# Set paths
$Source = "$ParentFolder\main"
$TempFPCA = "$ParentFolder\FPCA"
$ZipFile = "$ParentFolder\FPCA.zip"

# Remove any existing temp FPCA folder and zip file
Remove-Item $TempFPCA -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $ZipFile -Force -ErrorAction SilentlyContinue

# Create the temp FPCA folder
New-Item -ItemType Directory -Path $TempFPCA -Force | Out-Null

# Copy all contents from main to FPCA (without main folder)
Copy-Item "$Source\*" $TempFPCA -Recurse

# Create the zip with FPCA as the root folder
Compress-Archive -Path $TempFPCA -DestinationPath $ZipFile

# Clean up temp folder
Remove-Item $TempFPCA -Recurse -Force