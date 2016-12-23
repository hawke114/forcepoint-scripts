#*=============================================================================
#* Script Name: firefoxcertimport.ps1
#* Created:     2016-3-17
#* Author:  Matthew Dudlo
#* Purpose:  This script facilitates the creation of a sub ca
#*           
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
 param(
 [switch]$request,
 [switch]$sign,
 [switch]$convert
 )
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


#*=============================================================================
#* EXCEPTION HANDLER
#*=============================================================================
 
#*=============================================================================
#* FUNCTION LISTINGS
#*=============================================================================
 
#*=============================================================================
#* Function: request-certificate
#* Created:  2016-3-24
#* Author:   Matt Dudlo
#* Purpose:  creates a csr
#* =============================================================================
 function request-certificate {
 Write-Host -ForegroundColor Yellow "please specify output file name:" -NoNewline
 $reqname = Read-Host
 Write-Host -ForegroundColor Yellow "please fill out the certificate request form below:"
  .\openssl.exe req  -new -newkey rsa:2048 -out "${reqname}.csr" -keyout "${reqname}.key"
 }

#*=============================================================================
#* Function: sign-certificate
#* Created:  2016-3-24
#* Author:  Matt Dudlo
#* Purpose: attempts to sign the request with certreq
#* 
#* =============================================================================
function sign-certificate {
Write-Host -ForegroundColor Yellow "please specify csr path:" -NoNewline
$csrname=Read-Host
certreq -submit -attrib CertificateTemplate:SubCA $csrname
}

#*=============================================================================
#* Function: convert-certificate
#* Created:  2016-3-24
#* Author:  Matt Dudlo
#* Purpose: converts certificate from x509 to pkcs12
#* 
#* =============================================================================
function convert-certificate {
Write-Host -ForegroundColor Yellow "please specify path to certificate:" -NoNewline
$certfile=Read-Host
$certfile
Write-Host -ForegroundColor Yellow "please specify path to private key:" -NoNewline
$keyfile=Read-Host
$keyfile
.\openssl.exe pkcs12 -in .\$certfile -inkey .\$keyfile -export -out "${certfile}.p12"
}
#*=============================================================================
#* END OF FUNCTION LISTINGS
#*=============================================================================
 
#*=============================================================================
#* SCRIPT BODY
#*=============================================================================
Write-Host -ForegroundColor Yellow "Enter the drive letter Websense is installed to (eg: C, D, E, F):" -NoNewline
 $driveletter= Read-Host
 $valid=Test-Path ${driveletter}:\'Program Files (x86)\Websense\Web Security\apache\bin'
 $path1= "${driveletter}:\Program Files (x86)\Websense\EIP Infra\apache\"
 $path2= "$path1\bin"
 $path3= "$path1\conf\openssl.cnf"
 $testpath2= Test-Path $path2
 $testpath3= Test-Path $path3
if ($valid -eq "true")  {
    Copy-Item -Path $path3 -Destination $path2
    }
    else {
        while ([string]$testpath2 -eq "false" -and [string]$testpath3 -eq "false") {
            Write-Host -ForegroundColor Yellow "Please input full path to '\Websense\Web Security\apache\':" -NoNewline
            $path1 = Read-Host
            [string]$testpath2 = Test-Path $path1\bin
            [string]$testpath3 = Test-Path $path1\conf\ssl\openssl.cnf
        }
    Copy-Item -Path $path1\conf\ssl\openssl.cnf -Destination $mainpath\bin
}

cd $path1\bin
$env:OPENSSL_CONF=".\openssl.cnf"
if ([string]$request.IsPresent -eq 'true' )
{
request-certificate
exit
}

if ([string]$sign.IsPresent -eq 'true' )
{
sign-certificate
exit
}

if ([string]$convert.IsPresent -eq 'true' )
{
convert-certificate
exit
}

Write-Host -ForegroundColor Red "Usage:
wbsncrt.ps1 -request | -sign | -convert"
#*=============================================================================
#* END SCRIPT BODY
#*=============================================================================
 
#*=============================================================================
#* END OF SCRIPT
#*=============================================================================