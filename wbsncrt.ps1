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

# SIG # Begin signature block
# MIIH9gYJKoZIhvcNAQcCoIIH5zCCB+MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUtEM1uYmzySlzil8FxQhydQRs
# 2KGgggVuMIIFajCCBFKgAwIBAgIKRrxSGQAAAAAACjANBgkqhkiG9w0BAQ0FADBD
# MRMwEQYKCZImiZPyLGQBGRYDbmV0MRUwEwYKCZImiZPyLGQBGRYFZHVkbG8xFTAT
# BgNVBAMTDGR1ZGxvLURDMS1DQTAeFw0xNTEwMTEyMTMzMThaFw0xNjEwMTAyMTMz
# MThaMGAxEzARBgoJkiaJk/IsZAEZFgNuZXQxFTATBgoJkiaJk/IsZAEZFgVkdWRs
# bzENMAsGA1UECxMESG9tZTEOMAwGA1UECxMFVXNlcnMxEzARBgNVBAMTCk1hdHQg
# RHVkbG8wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDH+L03NUKqUTev
# R6ZBkSGuYtXyjUoQFG8eCvv1w45ZqVzFDzORHDApT/W5jRy4bqhywW4j3sfMGUHR
# adIg83IcX3LKpdA/l1lTmIe+aEKffGezrPVhX1rSsZuMN8JHnCMX1DjOSSqYugkH
# 6NlXHB7Jf2olQ3QJQJlmI648TeD5AIcJK0K2yXdf+ANlyhhyxgYKnUxgujrrgUO+
# EWw5bQOmDIMPisIUnRf7UAJWzNEct+6uVdeGsTckVNJWkGDTGK1u8VeGswAkLEdg
# 1iprVlNv4Tfgt5brWAO/wRaJnRKAY+MYLZ8OEgVsaGTKDDnvWLLmh/7s7IgvzhoI
# yc8frHzpAgMBAAGjggJBMIICPTAlBgkrBgEEAYI3FAIEGB4WAEMAbwBkAGUAUwBp
# AGcAbgBpAG4AZzATBgNVHSUEDDAKBggrBgEFBQcDAzAOBgNVHQ8BAf8EBAMCB4Aw
# HQYDVR0OBBYEFBcxQadp/tUSIKzIgU/472fzGknrMB8GA1UdIwQYMBaAFEWFSR47
# 8Do77ed7An74qShUp97aMIHEBgNVHR8EgbwwgbkwgbaggbOggbCGga1sZGFwOi8v
# L0NOPWR1ZGxvLURDMS1DQSxDTj1EQzEsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUy
# MFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9ZHVkbG8s
# REM9bmV0P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFz
# cz1jUkxEaXN0cmlidXRpb25Qb2ludDCBvAYIKwYBBQUHAQEEga8wgawwgakGCCsG
# AQUFBzAChoGcbGRhcDovLy9DTj1kdWRsby1EQzEtQ0EsQ049QUlBLENOPVB1Ymxp
# YyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24s
# REM9ZHVkbG8sREM9bmV0P2NBQ2VydGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1j
# ZXJ0aWZpY2F0aW9uQXV0aG9yaXR5MCkGA1UdEQQiMCCgHgYKKwYBBAGCNxQCA6AQ
# DA5NYXR0QGR1ZGxvLm5ldDANBgkqhkiG9w0BAQ0FAAOCAQEAF5aj+X+HGtPj3obL
# YkAeKShWeitKvSzVKSHhcnFDDP2uHV+yBEDS4K1tCvkB/xF9urP9LBITom05fn7S
# nsHY0cDyYDvkeCTPlETC9gKm/v+kkD+rYinzw3Vrr/qzW6Bq2LrG2/0t5RmyrM1V
# JtqPobivhJja579PHePpzUdkUohBt6n2Y1dIVLNuz1UbdMzN03uI5mTjzXjE9exj
# +7mMBMS7ObIm7NiGw0CTaTMMA1TMTp1rqGO6sGLam0LRVOIPfXCbQihhtniPpFQD
# Wnns2j26bZmrEl3w+B9X6JLoB773ybsfpJtmLmKFd3fINrXPb1ysxsNCtkKw11+h
# hAzotDGCAfIwggHuAgEBMFEwQzETMBEGCgmSJomT8ixkARkWA25ldDEVMBMGCgmS
# JomT8ixkARkWBWR1ZGxvMRUwEwYDVQQDEwxkdWRsby1EQzEtQ0ECCka8UhkAAAAA
# AAowCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFFfPMw4BfIoLkGge9m+HIqg+PbJWMA0GCSqGSIb3
# DQEBAQUABIIBAAcZj8K03D3EjzmcYBxwXcf8xSqjtGf/dN3HaSqs18cpUEsyRxfw
# xzyFBc3nQbmLZLeNOkUuSIkgDwx6OSo0l5MhJlpAbgTnvIg2whma6vyIVrhs3t6M
# t1SNpJKeZZmMeyiF/moMNmK46Cz24tGjGdOIqs/pnG+bnZ7bSI8ojT5g6yka1PlJ
# 8OB02op1x8scyvXa/V1k6iCm1sc+1JpJidvpVPiF4bX9LfYhdgeqwHIWkXryfe/v
# 6HM1yngYNj+2oiFwVJ0H/eWlobha0d8sQw+X1YlJP5psuZSW1N78Qapil5bbdSdv
# ZSKGpV4PGgxZ2ICOaVjORM5zVmQ9iqBmNW0=
# SIG # End signature block
