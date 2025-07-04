# This module contains functions to parse and validate various data formats.


# This function parses a UTF-8 encoded file and returns its content as a hashtable in ini format.
# It reads the file line by line, ignoring comments and empty lines, and extracts sections and key-value pairs.
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

# This function takes a string and returns an integer if the string is a valid integer, otherwise it returns a default value.
# It uses [int]::TryParse to check if the string can be converted to an integer.
# If the conversion fails, it returns the specified default value.
# Example usage: Convert-StringToInt "123" 0  # Returns 123
function Convert-StringToInt {
    param(
        [string]$InputString,
        [int]$Default
    )
    $out = 0
    if ([int]::TryParse($InputString, [ref]$out)) {
        return $out
    } else {
        return $Default
    }
}

# This function reads ps1 files from a specified file and returns their content as script blocks.
function Get-ScriptBlocksFromFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    $scriptBlocks = @()
    if (Test-Path -Path $FilePath) {
        $content = Get-Content -Path $FilePath -Raw
        $scriptBlocks = $content -split "`n" | ForEach-Object { [scriptblock]::Create($_) }
    } else {
        Write-Host "File not found: $FilePath"
    }
    return $scriptBlocks
}

# Specifically designed to parse a configuration file in a custom format.
# The file contains sections, checkboxes, and settings in a structured format.
function Get-FromConfigFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    $result = @{}
    $category = $null
    $checkbox = $null

    foreach ($line in Get-Content $FilePath) {
        $line = $line.Trim()
        if ($line -match "^\[(.+)\]$") {
            $category = $matches[1]
            $result[$category] = @{}
            $checkbox = $null
        } elseif ($line -match "^\((.+)\)$" -and $category) {
            $checkbox = $matches[1]
            $result[$category][$checkbox] = @{}
        } elseif ($line -match "^(.*?)=(.*)$" -and $category -and $checkbox) {
            $setting = $matches[1].Trim()
            $value = $matches[2].Trim()
            $result[$category][$checkbox][$setting] = $value
        }
    }
    return $result
}

# Convert PSCustomObject to Hashtable
function ConvertTo-Hashtable($obj) {
    if ($obj -is [System.Collections.IDictionary]) {
        $hash = @{}
        foreach ($key in $obj.Keys) {
            $hash[$key] = ConvertTo-Hashtable $obj[$key]
        }
        return $hash
    } elseif ($obj -is [System.Collections.IEnumerable] -and
              -not ($obj -is [string])) {
        return @($obj | ForEach-Object { ConvertTo-Hashtable $_ })
    } else {
        return $obj
    }
}