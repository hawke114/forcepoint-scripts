#*=============================================================================
#* Script Name: firefoxcertimport.ps1
#* Created:     2016-3-17
#* Author:  Matthew Dudlo
#* Purpose:  This script copies the firefox databases need to mass-deploy
#*           Trusted CA certificates.
#*=============================================================================
 
#*=============================================================================
#* PARAMETER DECLARATION
#*=============================================================================

#*=============================================================================
#* REVISION HISTORY
#*=============================================================================
#*
#*=============================================================================
 
#*=============================================================================
#* IMPORT LIBRARIES
#*=============================================================================
 
#*=============================================================================
#* PARAMETERS
#*=============================================================================
 
#*=============================================================================
#* INITIALISE VARIABLES
#*=============================================================================
# Increase buffer width/height to avoid PowerShell from wrapping the text in
# output files
$pshost = get-host
$pswindow = $pshost.ui.rawui
$newsize = $pswindow.buffersize
$newsize.height = 3000
$newsize.width = 500
$pswindow.buffersize = $newsize
#Enumerate windows version
$windowsversion =  [System.Environment]::OSVersion.Version
#determine major version number
$major = $windowsversion.Major
#Define path Firefox Profiles are stored in
$firefoxprofilepath = "$env:appdata\Mozilla\Firefox\Profiles"

#*=============================================================================
#* EXCEPTION HANDLER
#*=============================================================================
 
#*=============================================================================
#* FUNCTION LISTINGS
#*=============================================================================
 
#*=============================================================================
#* Function: copy-windows10files
#* Created:  2016-3-17
#* Author:   Matt Dudlo
#* Purpose:  Copies firefox database files necessary for windows 10
#* =============================================================================
 function copy-windows10files {
Write-Host -ForegroundColor Green "copying windows 10 files"
$directory = Get-ChildItem | where {$_.Attributes -eq "directory"}
foreach ($folder in $directory) {
Copy-Item \\<share>\Windows10\cert8.db -Destination $folder -Force
Copy-Item \\<share>\Windows10\key3.db -Destination $folder -Force
Copy-Item \\<share>\Windows10\secmod.db -Destination $folder -Force
}
}

#*=============================================================================
#* Function: copy-windows7files
#* Created:  2016-3-17
#* Author:  Matt Dudlo
#* Purpose: Copies the database files necessary for windows 7
#* 
#* =============================================================================
function copy-windows7files {
Write-Host -ForegroundColor Green "copying windows 7 files"
$directory = Get-ChildItem | where {$_.mode -eq "d----"}
foreach ($folder in $directory) {
Copy-Item \\<share>\Windows7\cert8.db -Destination $folder -Force
Copy-Item \\<share>\windows7\key3.db -Destination $folder -Force
Copy-Item \\<share>\Windows7\secmod.db -Destination $folder -Force
}
}

#*=============================================================================
#* END OF FUNCTION LISTINGS
#*=============================================================================
 
#*=============================================================================
#* SCRIPT BODY
#*=============================================================================
cd $firefoxprofilepath


if ($major -eq '10') {
copy-windows10files
}

if ($major -eq '6') {
copy-windows7files
}


#*=============================================================================
#* END SCRIPT BODY
#*=============================================================================
 
#*=============================================================================
#* END OF SCRIPT
#*=============================================================================
