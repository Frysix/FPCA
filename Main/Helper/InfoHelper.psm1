# This is a module that provides helper functions for fetching information from the system

# function to get the cpu's name
function Get-CPUName {
    $cpu = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1 -ExpandProperty Name
    return $cpu
}

# function to get the motherboard's brand and model
function Get-MotherboardInfo {
    $mb = Get-CimInstance -ClassName Win32_BaseBoard | Select-Object -First 1
    return @{
        BrandName = $mb.Manufacturer
        Model     = $mb.Product
    }
}

# function to get the gpu's model name
function Get-GPUName {
    $gpus = Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty Name
    if (-not $gpus) {
        return "No Gpu Detected"
    }

    # Prioritize NVIDIA, AMD, or Intel GPUs
    foreach ($gpu in $gpus) {
        if ($gpu -match 'NVIDIA|AMD|Radeon|Intel') {
            return $gpu
        }
    }

    # If none found, return the first GPU name or fallback
    if ($gpus.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($gpus[0])) {
        return $gpus[0]
    }

    return "No Gpu Detected"
}

# function to get the system's RAM size in GB and frequency in MHz
function Get-RAMInfo {
    $ramModules = Get-CimInstance -ClassName Win32_PhysicalMemory
    if (-not $ramModules) {
        return @{
            Frequency = "Unknown"
            Amount    = "No RAM Detected"
        }
    }

    # Get frequency (assume all modules have the same speed, use the first)
    $freq = $ramModules | Select-Object -First 1 -ExpandProperty Speed
    $freqStr = if ($freq) { "$freq MHz" } else { "Unknown" }

    # Get individual sizes in GB
    $sizesGB = $ramModules | ForEach-Object { [math]::Round($_.Capacity / 1GB) }
    $count = $sizesGB.Count
    $individual = if ($count -gt 0) { "$count x $($sizesGB[0])GB" } else { "Unknown" }
    $total = [math]::Ceiling(($sizesGB | Measure-Object -Sum).Sum)
    $amountStr = if ($count -gt 0) { "$individual | ${total}GB" } else { "No RAM Detected" }

    return @{
        Frequency = $freqStr
        Amount    = $amountStr
    }
}