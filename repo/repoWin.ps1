
# Script for running 'repo' tool in either Windows Subsystem for Linux's or Cygwin's bash

Param($command, $drive, $path)

if (Test-Path $path) {
    $path = ($path -replace '\\','/')
    $path = ($path -replace '.:',"/$drive/c")
    $cmdPath = (Split-Path -parent $PSCommandPath)

    if ($drive -ne "cygdrive") {
        $cmdPath = $($cmdPath -replace '\\','/')
        $cmdPath = ($cmdPath -replace '.:',"/$drive/c")

        bash -l "$cmdPath/repo" $command -f $path
    } 
    else {
        C:\cygwin64\bin\bash.exe -l "$cmdPath\repo" $command -f $path
    }
}
else {
    Write-Error "File $path not found"
    exit 1
}
Write-Output "Executed $command on $path"