
# Script for running 'repo' tool in either Windows Subsystem for Linux's or Cygwin's bash

Param($command, $path)

if (Test-Path $path) {
    $cmdPath = Split-Path -parent $PSCommandPath

    #if Windows Subsystem for Linux (WSL)
    if ( $(Get-Command bash).Source -eq "C:\WINDOWS\system32\bash.exe") {
        $path = $path -replace '\\','/'
        $path = $path -replace '.:',"/mnt/c"

        $cmdPath = $cmdPath -replace '\\','/'
        $cmdPath = $cmdPath -replace '.:','/mnt/c'

        bash -l "$cmdPath/repo" $command -f $path
    }
    # if Cygwin is installed and CYGWIN environment variable pointing to its installation location is defined
    elseif (Test-Path env:CYGWIN) {
        $cygwin = "$($env:CYGWIN)\bin\bash.exe"
        $params = '-l',"$cmdPath\repo","$command",'-f',"$path"
        & $cygwin $params
    }
    else {
        Write-Error "'bash' cannot be found. Please install either Windows Subsystem for Linux or Cygwin. If the latter, define CYGWIN environment variable pointing to the installation location."
        exit 2
    }
}
else {
    Write-Error "File $path not found"
    exit 1
}
