# This module contains functions to check internet connectivity.
# It includes functions to check internet status, HTTP website status, and Microsoft server status.

# Add required .NET assemblies
Add-Type -AssemblyName System.Net.Http

# Basic function to check internet connectivity
function Get-InternetStatus {
    $InternetStatus = test-connection 8.8.8.8 -count 1 -quiet
    return $InternetStatus
}

# Function to check if a website is reachable
function Get-HttpWebSiteStatus {
    param(
        [cmdletbinding()]
        [parameter(mandatory=$true)]
        [string]$Url
    )
    # Validate the URL format
    if (-not $Url -or $Url -notmatch '^(http|https)://') {
        throw "Invalid URL format: $Url"
    }
    # Create a web request to the specified URL
    $Request = [System.Net.WebRequest]::Create($Url)
    $Response = $Request.GetResponse()
    $WebsiteStatus = [int]$Response.StatusCode
    $Response.Close()
    if ($WebsiteStatus -eq 200) {
        return $true
    } else {
        return $false
    }
}

# Function to get the file length from the server
function Get-HttpFileLength {
    Param(
        [CmdletBinding()]
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    # Validate the URL format
    if (-not $Url -or $Url -notmatch '^(http|https)://') {
        throw "Invalid URL format: $Url"
    }
    # Create a web request to the specified URL
    $Request = [System.Net.HttpWebRequest]::Create($Url)
    $Request.Method = "GET"
    $Request.AllowAutoRedirect = $true
    $Headers = $Response.Headers
    $Response = $Request.GetResponse()
    $Headers = $Response.Headers

    $FileLength = $Headers["Content-Length"]
    $Response.Close()

    Return $FileLength
}