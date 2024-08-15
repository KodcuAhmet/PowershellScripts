<#
Comments
#>
[CmdletBinding()]
param (
    [ValidateScript({Test-Connection -ComputerName $_ -Quiet -Count 1})]
    [string]$ComputerName = 'localhost',
    [Parameter(Mandatory=$true)]
    [datetime]$StartTimestamp,
    [Parameter(Mandatory=$true)]
    [datetime]$EndTimestamp,
    [string]$LogFileExtension = 'log'
)
begin {
    . D:\PowershellScripts\LogInvestigator.ps1
}
process {
    try {
        $Params = @{
            'ComputerName' = $ComputerName
            'StartTimestamp' = $StartTimestamp
            'EndTimestamp' = $EndTimestamp
        }
        Start-Transcript D:\PowershellScripts\Logs.txt
        .\Get-WinEventWithin @Params
        .\Get-TestLogEventWithin @Params -LogFileExtension $LogFileExtension
        Stop-Transcript

    } catch {
        Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
    }
}
