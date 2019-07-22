
# Script for running 'repo' tool in either Windows Subsystem for Linux's or Cygwin's bash

Param($command, $drive, $path)

function Get-ScriptDirectory {
    Split-Path -parent $PSCommandPath
}

if (Test-Path $path) {
    $cmdPath = Get-ScriptDirectory
    $path = $($path -replace '\\','/')
    $path = ($path -replace '.:',"/$drive/c")

    if ($drive -ne "cygdrive") {
        $cmdPath = $($cmdPath -replace '\\','/')
        $cmdPath = ($cmdPath -replace '.:',"/$drive/c")

        $ret = $(bash -l "$cmdPath/repo" $command -f $path)
    } 
    else {
        $ret = (C:\cygwin64\bin\bash.exe -l "$cmdPath\repo" $command -f $path)
    }
}
else {
    Write-Error "File $path not found"
    exit 1
}
Write-Output "Executed $command on $path"