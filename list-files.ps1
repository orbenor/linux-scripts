<#
.SYNOPSIS
   u:\scripts\list-files.ps1
.DESCRIPTION
   List all the files that a given user owns
.PARAMETER none
   username: user 
   logfile: path to log file. This is optional. If omitted the the log file is created "u:\scratch\<$username>-files.txt
.EXAMPLE
    C:\ams\psscripts\list-files.ps1 plo
    Example: C:\ams\psscripts\list-files.ps1 plo u:\scratch\log.txt

#>

param (
    [string]$username,
    [string]$logfile
    )


# Load modules
Set-ExecutionPolicy Unrestricted
Import-Module ActiveDirectory
Add-PSSnapin Quest.ActiveRoles.ADManagement

function printHelp {
    Write-Host "This script will find all the files owned by a user. It scans \\dfs\groups"
    Write-Host "C:\ams\psscripts\list-files.ps1 user logfile (optional)"
    Write-Host "Example: C:\ams\psscripts\list-files.ps1 plo"
    Write-Host "Example: C:\ams\psscripts\list-files.ps1 plo u:\scratch\log.txt"
}

if ($logfile -eq "") {
    $logfile = "u:\scratch\" + $username + "-files.txt"
    Write-Host "Setting log file to $logfile"
}
