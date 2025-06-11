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