#
# 1. Powershell Script
# Creating a simple PS script to make use of parameters, carry out some operations and print them out
#

param($FirstName,$env:COMPUTERNAME, $password)

Write-Host "First Name: $FirstName"
Write-Host "Computer Name: $env:COMPUTERNAME"
Write-Host $("Initial: $FirstName.SubString(0,1)")
Write-Host "Password: $password"

if ($env:COMPUTERNAME){
    Write-Host "Current host is chosen as the computer name!"
    return
}

$NewObj = @{
    'Name'= $FirstName
    'Computer'= $env:COMPUTERNAME
    'NameInitial'= ($FirstName.SubString(0,1))
    'SecurePassword' = (ConvertTo-SecureString $password -AsPlainText -Force)
}

Write-Host ($NewObj | Format-Table -Force | Out-String)
