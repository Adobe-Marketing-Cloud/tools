
# Script for running 'repo' tool in either Windows Linux subsystem shell or Cygwin bash
# see https://github.com/Adobe-Marketing-Cloud/tools/blob/master/repo/repo

Param($command, $path)

function cleanup {
    $tmpPkg = "C:\temp\pkg.zip"

    if (Test-Path $tmpPkg) {
        rm $tmpPkg
    }
}

if (Test-Path $path) {
    $path = $($path -replace '\\','/')
    $ret = $(bash -l ./repo $command -f $path)
    #$ret = (C:\cygwin64\bin\bash.exe -l .\repo $command -f $path)
}
else{
    Write-Error "File $path not found"
    exit 1
}
cleanup 
Write-Output "File $path has been uploaded"