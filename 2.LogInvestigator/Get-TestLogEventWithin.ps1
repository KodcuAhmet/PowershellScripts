param(
    [string]$ComputerName = 'localhost',
    [datetime]$StartTimestamp,
    [datetime]$EndTimestamp,
    [string]$LogFileExtension = 'log'
)

## Define the drives to look for log files if local or the shares to look for when remote
if ($ComputerName -eq 'localhost') {
    $Locations = (Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType = '3'").DeviceID
} else {
    ## Enumerate all shares
    $Shares = Get-CimInstance -ComputerName $ComputerName -ClassName Win32_Share | Where-Object { $_.Path -match '^\w[1]:\\$' }
    [System.Collections.ArrayList]$Locations = @()
    foreach ($Share in $Shares) {
        $SharePath = "\\$ComputerName\$($Share.Name)"
        if (!(Test-Path $SharePath)) {
            Write-Warning "Unable to access the '$SharePath' share on '$ComputerName'"
        } else {
            $Locations.Add($SharePath) | Out-Null
        }
    }
}

## Build the hashtable to perform splitting on Get-ChildItem
$GciParams = @{
    Path = $Locations
    Filter = "*.$LogFileExtension"
    Recurse = $true
    Force = $true
    ErrorAction = 'SilentlyContinue'
    File = $true
}

## Build the Where-Object scriptblock on a separate line due to its length
$WhereFilter = { ($_.LastWriteTime -ge $StartTimestamp) -and ($_.LastWriteTime -le $EndTimestamp) -and ($_.Length -ne 0) }

## Find all interesting log files
Get-ChildItem @GciParams | Where-Object $WhereFilter
