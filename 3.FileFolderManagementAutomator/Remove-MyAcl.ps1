<#
 .SYNOPSIS
    This function allows an easy method to remove file system ACE's
 .PARAMETER Path
    The file path of the file
 .PARAMETER Identity
    The security principle to match with the ACE you'd like to remove
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [ValidateScript({ Test-Path -Path $_ })]
    [string]$Path,
    [Parameter(Mandatory=$true)]
    [string]$Identity
)
process {
    try {
        $Acl = (Get-Item $Path).GetAccessControl('Access')
        $Acl.Access | where { $_.IdentityReference -eq $Identity } | foreach { $Acl.RemoveAccessRule($_) | Out-Null }
        Set-Acl -Path $Path -AclObject $Acl
    } catch {
        Write-Error " $($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
    }
}
