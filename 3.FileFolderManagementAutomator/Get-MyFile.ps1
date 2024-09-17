#
# File and Folder Management Automator
# This is a Powershell script to automate tasks
#
# 1. Find a file by extension, age or name
#


param ([string[]]$ComputerName = 'localhost', [string]$Criteria, [hashtable]$Attributes)

foreach ($Computer in $ComputerName) {
    ## Enumerate all of the default admin shares
    $CimInstParams = @{'ClassName' = 'Win32_Share'}
    if ($Computer -ne 'localhost') { ## If a ComputerName is not localhost, it has to be added
        $CimInstParams.ComputerName = $Computer
    }
    $DriveShares = (Get-CimInstance @CimInstParams  | where { $_.Name -match '^[A-Z]\$$' }).Name
    foreach ($Drive in $DriveShares) {
        switch ($Criteria) {
            'Extension' {
                Get-ChildItem -Path "\\$Computer\$Drive" -Filter "*.$($Attributes.Extension)" -Recurse
            }
            'Age' {
                $Today = Get-Date
                $DaysOld = $Attributes.DaysOld
                Get-ChildItem -Path "\\$Computer\$Drive" -Recurse | Where-Object { $_.LastWriteTime -le $Today.AddDays(-$DaysOld) }
            }
            'Name' {
                $Name = $Attributes.Name
                Get-ChildItem -Path "\\$Computer\$Drive" -Filter "$Name" -Recurse
            }
            default {
                Write-Error "Unrecognized criteria '$Criteria'"
            }
        }
    }
}
