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
        [string]$Url,
        [parameter(mandatory=$false)]
        [int]$MaxRedirects = 5,
        [parameter(mandatory=$false)]
        [int]$TimeoutSeconds = 30,
        [parameter(mandatory=$false)]
        [switch]$ReturnDetails
    )
    
    # Validate the URL format
    if (-not $Url -or $Url -notmatch '^(http|https)://') {
        throw "Invalid URL format: $Url"
    }
    
    $Result = @{
        IsReachable = $false
        StatusCode = $null
        FinalUrl = $null
        RedirectCount = 0
        ErrorMessage = $null
    }
    
    try {
        # Create a web request to the specified URL
        $Request = [System.Net.HttpWebRequest]::Create($Url)
        $Request.Method = "HEAD"
        $Request.AllowAutoRedirect = $true
        $Request.MaximumAutomaticRedirections = $MaxRedirects
        $Request.Timeout = $TimeoutSeconds * 1000
        $Request.UserAgent = "FPCA-Updater/1.0"
        $Request.KeepAlive = $false
        $Request.ServicePoint.Expect100Continue = $false
        
        # Get the response
        $Response = $Request.GetResponse()
        $Result.StatusCode = [int]$Response.StatusCode
        $Result.FinalUrl = $Response.ResponseUri.ToString()
        
        # Calculate redirect count
        if ($Result.FinalUrl -ne $Url) {
            $Result.RedirectCount = 1  # Simplified count
        }
        
        $Response.Close()
        
        # Determine if reachable based on status code
        $Result.IsReachable = $Result.StatusCode -in @(200, 301, 302, 303, 307, 308)
        
    } catch [System.Net.WebException] {
        $webEx = $_.Exception
        $Result.ErrorMessage = $webEx.Message
        
        if ($webEx.Response) {
            $Result.StatusCode = [int]$webEx.Response.StatusCode
            $Result.IsReachable = $Result.StatusCode -in @(401, 403)  # Server reachable but access denied
        }
        
    } catch [System.Exception] {
        $Result.ErrorMessage = $_.Exception.Message
    }
    
    # Return simple boolean or detailed object
    if ($ReturnDetails) {
        return $Result
    } else {
        return $Result.IsReachable
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

# Function to resolve redirections 
function Resolve-RedirectUrl {
    param (
        [string]$Url, 
        [int]$MaxRedirects = 10
    )
        
    $currentUrl = $Url
    $redirectCount = 0
        
    while ($redirectCount -lt $MaxRedirects) {
        try {
            # Create HttpClient with redirect handling disabled
            $handler = New-Object System.Net.Http.HttpClientHandler
            $handler.AllowAutoRedirect = $false
            $client = New-Object System.Net.Http.HttpClient($handler)
                
            # Send HEAD request to check for redirects
            $response = $client.SendAsync((New-Object System.Net.Http.HttpRequestMessage([System.Net.Http.HttpMethod]::Head, $currentUrl))).Result
                
            if ($response.StatusCode -in @([System.Net.HttpStatusCode]::MovedPermanently, [System.Net.HttpStatusCode]::Found, [System.Net.HttpStatusCode]::SeeOther, [System.Net.HttpStatusCode]::TemporaryRedirect, [System.Net.HttpStatusCode]::PermanentRedirect, 308)) {
                $location = $response.Headers.Location
                if ($location) {
                    if ($location.IsAbsoluteUri) {
                        $currentUrl = $location.ToString()
                    } else {
                        # Handle relative redirects
                        $baseUri = New-Object System.Uri($currentUrl)
                        $currentUrl = (New-Object System.Uri($baseUri, $location)).ToString()
                    }
                    Write-Host "Redirect $($redirectCount + 1): $currentUrl"
                    $redirectCount++
                } else {
                    break
                }
            } else {
                # No more redirects
                break
            }
                
            $client.Dispose()
                
        } catch {
            Write-Host "Error resolving redirect: $($_.Exception.Message)"
            break
        }
    }
        
    if ($redirectCount -ge $MaxRedirects) {
        throw "Too many redirects (>$MaxRedirects)"
    }
        
    return $currentUrl
}