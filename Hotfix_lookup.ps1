#*=============================================================================
#* Script Name: get-process.ps1
#* Created:     2015-10-24
#* Author:  Matthew Dudlo
#* Purpose:     This Script checks for Websense Hotfixes.
#*          
#*=============================================================================
 
#*=============================================================================
#* PARAMETER DECLARATION
#*=============================================================================
param(
[switch]$download,
[switch]$save
)
#*=============================================================================
#* REVISION HISTORY
#*=============================================================================
#* Date: 2015-12-29
#* Author:Matt Dudlo
#* Version: 1.2
#* Purpose: Fixed issues in code preventing download of hotfixes in versions
#*          other than 8.0.1
#*=============================================================================
#* Date: 2015-10-24
#* Author:Matt Dudlo
#* Purpose: Lookup and download Websense Hotfixes
#* Version: 1.1
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
# define version to lookup hotfixes for
$version = $args[0]
# Define .NET method for downloading files
$Wget = New-Object System.Net.WebClient
$HFPath = "$PWD\hotfixes_$Version"
$endpath = $pwd.Path
#*=============================================================================
#* EXCEPTION HANDLER
#*=============================================================================
 
#*=============================================================================
#* FUNCTION LISTINGS
#*=============================================================================
 
#*=============================================================================
#* Function:    getfile
#* Created:     2015-10-23
#* Author:  Matthew Dudlo
#* Purpose:     This function downloads files via HTTP.
#* =============================================================================
 
 function getfile 
 {
    $path = $args[0]
    foreach ($url in $path)
    {  
        #Get the filename 
	    $filename = [System.IO.Path]::GetFileName($url) 

	    #Create the output path 
	    $file = [System.IO.Path]::Combine($HFPath, $filename) 
                    
        $Wget.DownloadFile($Url, $file )             
    }
}

#*=============================================================================
#* Function:    download_hf_list
#* Created:     2015-10-23
#* Author:  Matthew Dudlo
#* Purpose:     This function downloads the hotfix master list.
#* =============================================================================

function download_hf_list {
    $xmlfilename = [System.IO.Path]::GetFileName("http://appliancehotfix.websense.com/download/hotfixes/hf_list.xml")
    $xmlfile = [System.IO.Path]::Combine($HFPath, $xmlfilename)
    $wget.DownloadFile("http://appliancehotfix.websense.com/download/hotfixes/hf_list.xml" , $xmlfile)
}

#*=============================================================================
#* Function:    getfilename
#* Created:     2015-10-23
#* Author:  Matthew Dudlo
#* Purpose:     This function resolves a file name from a url for input into
#*               getfile
#* =============================================================================

function getfilename {
 [System.IO.Path]::GetFileName($args[0])
 }

#*=============================================================================
#* END OF FUNCTION LISTINGS
#*=============================================================================
 
#*=============================================================================
#* SCRIPT BODY
#*=============================================================================
 [string]$DownloadFile = Test-Path  "$pwd\hotfixes_$version"
 if ($DownloadFile -match "false")
    {
        mkdir hotfixes_$version | Out-Null
    }

#Download Master Hotfix list
download_hf_list

#Load Master XML List to Memory
[xml]$HFList = Get-Content $HFPath\hf_list.xml

#Extract URL for Version-Specific XML File
$1 = $HFList.listxml.hotfix | Where-Object {$_.version -eq $Version} | Select-Object listxmlurl
$VersionXML = $1.listxmlurl

#Download Version-Specific XML File
getfile $VersionXML

cd "hotfixes_$version"

#Extract File Name From URL
$HFXML = getfilename $VersionXML

#Import Version-Specific XML to Memory
[xml]$HFVersion = get-content $HFXML 
 
if ($save.IsPresent -match "true"){
        [string]$outfile = "hotfix_"+ $version +"_list.txt"
       $HFVersion.hotfixes.hotfix | where-object {$_.product -match '^\S+'}  | Select-Object id, module, description, releasedate, fileurl, releasenoteurl | Sort-Object module | Export-Csv $HFPath\$outfile
        }

#Conditional Parameter to Download Hotfix Files
if ([string]$download.IsPresent -match "true") {
   $get = import-csv "hotfix_${version}_list.txt" | foreach {$_.fileurl} 
   getfile $get 
}




if ($download.IsPresent -match "false" -and $save.IsPresent -match "false")
{
    $HFVersion.hotfixes.hotfix | where-object {$_.product -match '^\S+'}  | Select-Object id, module, description, releasedate, fileurl, releasenoteurl | Sort-Object module | out-gridview -title "$version Hotfixes"
}

cd $endpath





#*=============================================================================
#* END SCRIPT BODY
#*=============================================================================
 
#*=============================================================================
#* END OF SCRIPT
#*=============================================================================
# SIG # Begin signature block
# MIIbnwYJKoZIhvcNAQcCoIIbkDCCG4wCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUiiUMglVFXqv3uy2WTF4Y7C69
# 9RSgghXAMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggXZMIIDwaADAgECAgcQAPXr4DlDMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYT
# AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGln
# aXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0
# aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0wNzEwMTQyMjAxNDZaFw0yMjEwMTQyMjAx
# NDZaMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkG
# A1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UE
# AxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBPYmplY3Qg
# Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDKI4siNR6aoBs8nUnQ
# PwyXOBYpuvh9iVtFWO+EcO1+EU3pFDGrQ+NNDFGBbPAVA0okJ1Tl+0qgzk3hhKMh
# 3pk1q9xJrr8xxWeEMBCb7wfcdagPTfQ1U7FuOAP8iHcdpXf/P3Xn2ee/LFARyRFl
# +kkHYp+TpoepbcmdK9F75dVlK58NUJ7++3EZITAoJo2uwtz2luhShggLejLNahRN
# nrn5zQfilpHxzx4r+YL3XiYGjo3R1DnXb9uRJ1p5j1hpCka1b+H9b8WRtBFPewKm
# 20tWUiOeS5jiv37O+qFOg+PFx8NgR/5cPxUaQCqV7wBryFD4zWoZ1CMDJ7w7NtW5
# Q7DvAgMBAAGjggFMMIIBSDASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQE
# AwIBBjAdBgNVHQ4EFgQU0E4PQJlsuEsZbzsouODjiAc0qrcwHwYDVR0jBBgwFoAU
# TgvvGqRAW6UXaYcwyjRoQ9BBrvIwaQYIKwYBBQUHAQEEXTBbMCcGCCsGAQUFBzAB
# hhtodHRwOi8vb2NzcC5zdGFydHNzbC5jb20vY2EwMAYIKwYBBQUHMAKGJGh0dHA6
# Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL2NhLmNydDAyBgNVHR8EKzApMCegJaAj
# hiFodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmwwQwYDVR0gBDwwOjA4
# BgRVHSAAMDAwLgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3Bv
# bGljeS5wZGYwDQYJKoZIhvcNAQELBQADggIBADWy5WYXlCb0MUBWc0fp3GMiOWfc
# R2i2lmlNINajPswiLayT6kezsqbTACTYI3vBKk4gBsyfoB50VuZb3ByPyVGU0adb
# OkIwC+ae7/b6sQqMjjA8sNQq8vukfVV2qSUNUneFkyrB/GOl6RoZoha42EvQ1ZwY
# en/ezWlaNIiG4TT96NSdkGlrN9CTag/u5OQ+Z8bimy+BkVW6FyV8zMruFmrzMb86
# j1A51oXOA4EUsyRDyaclhlxkEajrlXZqb9oMNmZNbX8dj852tjDtptkJj+OWIcO2
# 8vBaEQ2jBQSbosM1O6W+BxM8tBeYvirDv6sXsULMxl2n9DEqghrkLL4dkNwTKvXv
# +ymA+ollik0+qinrM6D6jVyjzg1fPIza13NXNjoJhgch03IQd7ppQOdA0yySkqhC
# BqstaFNOaLfELHzqd2Cd3rAU8ZPlfwnxHk5z/5MZHECjnb3pyrZSdQLwqnaYt3GE
# GH3MxiRyejervfwYEyoHf9pIeLACbYYO/3uXdj68KKGJzJbvQa1KKMwNfi0btYzT
# EECilNhOKsdpL4dBaTLGDrkPQJB3BZBLqukVaPDienIS4Hsxy0FgYD1PtFGB0eg2
# JfcBhuyVloHBLZwuJXGEjAhyKE84gBDKyaVHN41cMgSZdQ6jUcfZYxWV0MbxDJMo
# 2tLZ8sjB+aPb5IipMIIHRjCCBi6gAwIBAgIHE0lUuP2RnDANBgkqhkiG9w0BAQsF
# ADCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNV
# BAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMT
# L1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUgT2JqZWN0IENB
# MB4XDTE1MTAyMTAyMjIxM1oXDTE3MTAyMTA3NDYwNlowejELMAkGA1UEBhMCVVMx
# ETAPBgNVBAgTCElsbGlub2lzMRYwFAYDVQQHEw1IaWNrb3J5IEhpbGxzMRYwFAYD
# VQQDEw1NYXR0aGV3IER1ZGxvMSgwJgYJKoZIhvcNAQkBFhltYXR0LmR1ZGxvQGhh
# d2tlYWRtaW4uY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA2dTB
# pWuwZ7j4R9MxkOfpSCRykdlz1yRwsrHioxvMc22X2mP/hBJzftEsiCGWAbEkTnT+
# C4UceRHrToUn+p+ZQsgmorktywCxw+b+nNJ0puQuJrcjlNlaaUU99UrqMFPBhGdF
# TUdxoS5gdu3cdaY4gHFvnryi6FgLMr7V6kmyyPkX3Mc1C3GVkcUxzL5kc2UpCS9d
# 32MOQeDn3Bs5XDpvC+qnFkSVMDykphg/ZxbmOVKeyH5OOy0GcWyMo3sb66b+z0Ls
# vzh+4eYEIRHTq5r1X6uT9PZsi3zAygFssaZMmaKXpg/AjOVWNwX0RMcpiuzmb7Lu
# q744YoH7rkqOFvswRw54LdXW2POOH5iddZw22p8hOJ/4sKc9cuUWDfo7ZdmteCrk
# LwPQLbjcPtuoOGYtv/YwLmAcw7ztesYZe150kHxUsm75jnaA7RfIj3WCKcqkJRZ+
# GmYUU/F1Q6x1noCFJxtpCT3m53So/uyb/b8QqYVVieDlzIPgZh0zB8V47MqLxk8P
# 8UjupLWlZmVeYfvvjoaID8wpUQCa0D2Si7TqlLYJn90ANrft8eKuG7ifvPmeLF9x
# cPWL/Wr5zxuOD2gbxup1axcNQf+hUW96zXkGInUfBtTOZUgYI8Xd9T4cetbAZKVm
# 7DsB9ThkSauYkQAYJTrTvmYAxIElqyQwqY/P948CAwEAAaOCArwwggK4MAkGA1Ud
# EwQCMAAwDgYDVR0PAQH/BAQDAgeAMCIGA1UdJQEB/wQYMBYGCCsGAQUFBwMDBgor
# BgEEAYI3CgMNMB0GA1UdDgQWBBSHZetoeWxYfxTwq4re3zTW2x2paTAfBgNVHSME
# GDAWgBTQTg9AmWy4SxlvOyi44OOIBzSqtzCCAUwGA1UdIASCAUMwggE/MIIBOwYL
# KwYBBAGBtTcBAgMwggEqMC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3Ns
# LmNvbS9wb2xpY3kucGRmMIH3BggrBgEFBQcCAjCB6jAnFiBTdGFydENvbSBDZXJ0
# aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+VGhpcyBjZXJ0aWZpY2F0ZSB3YXMg
# aXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMiBWYWxpZGF0aW9uIHJlcXVp
# cmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxpYW5jZSBvbmx5
# IGZvciB0aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRoZSBy
# ZWx5aW5nIHBhcnR5IG9ibGlnYXRpb25zLjA2BgNVHR8ELzAtMCugKaAnhiVodHRw
# Oi8vY3JsLnN0YXJ0c3NsLmNvbS9jcnRjMi1jcmwuY3JsMIGJBggrBgEFBQcBAQR9
# MHswNwYIKwYBBQUHMAGGK2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xh
# c3MyL2NvZGUvY2EwQAYIKwYBBQUHMAKGNGh0dHA6Ly9haWEuc3RhcnRzc2wuY29t
# L2NlcnRzL3N1Yi5jbGFzczIuY29kZS5jYS5jcnQwIwYDVR0SBBwwGoYYaHR0cDov
# L3d3dy5zdGFydHNzbC5jb20vMA0GCSqGSIb3DQEBCwUAA4IBAQA/xkugE78SHmNr
# GhheaXOD9/CrE9IExaSrzGsRAFXlN2tGtnLVE4JTt2fx8979ahFGoqGvHUKPUmsT
# iCOXyoC4qeaG5bGA0UW0QSKIngCA7VKkr6M7CBatyEp/e22hHaZ8PximPg3dlmIn
# lTNfjQmoe9fIRakfN8XHplCea7qpoK9isxd0zL4hIpYNI4TjwUjxZO1pPoyvkx8F
# vEYAY/ks+QJjwPSEvLRPbPXQXgSaUJFn0P+LqIoOTihf6wGPGK5Ac6wxc6H0PLmw
# ojDnukGN+MCXESOGefWGLvtln+LJ9vHUVKohUJ52yeaDlunWekss0FfKhusF0m/+
# X+WQvxSuMYIFSTCCBUUCAQEwgZgwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
# dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0
# ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50
# ZXJtZWRpYXRlIE9iamVjdCBDQQIHE0lUuP2RnDAJBgUrDgMCGgUAoHgwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUi7Gi
# JVz0fT47HtftNcIYOpWtSgwwDQYJKoZIhvcNAQEBBQAEggIAhWums+3r7sptpTei
# VCkuOEmfqgQGfKkaffpufFooyQoqPqozdvt5njy8s1cWTnbiU/d9Bp6jz8Dlql32
# zmXwjTmZovC2ZEvfHEdXqk+Dz0/F+t2S7e3rwrUSLur3fZW4LZaiwjnsAaejJY93
# x1wgzynoCqtEszWx2hBJ5QRg6nTXVEKL46jutw1++lHDdkPM/WgwYKseygnC/bDb
# nj7ckR2Ci83465jI/OHbhgJoqk32FkyrFfLUErbRXEm1YboPx4PVti7rRrmMwvZ2
# X9Ki5RlCXkZ0Fdiga8fVfUqSp/eAkWUzUvvQV7Eb2acFKnyDccaV4tQqC952EFlr
# g0Sl4MXWsxW3etaxfSChgKUgPaQmmKadSSBu2YtHy5HA7mkFIFmNCbchWbZ0JhX7
# EC0q1rREsYw1FeIhRDfYApMq6oZhzQrn7k1iF/R/cw3uC/hvqtAHOoHZs8pmNawz
# 8oy+8M+rHikg3C/IUv79kiAhA9v2B5lPranXw9h2G9L7IRSHRtp7oFf43QxnPpc3
# Hbr9bwdje5FwScQFS5r7muDC+tmoar6bmXH8E508ld0FGqnoJv2ZCSIX4QbI3vgK
# C5ZV3aKKD4Tnmis1GPWqMVtNHpOaWAZHRMxHC6CgvvpGeo2Jy+025xTC9tYZSQoY
# +aIt2392ImVb0O1UgwlDQofp25OhggILMIICBwYJKoZIhvcNAQkGMYIB+DCCAfQC
# AQEwcjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRp
# b24xMDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0Eg
# LSBHMgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkD
# MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjI5MTkzNTE4WjAjBgkq
# hkiG9w0BCQQxFgQU/swIvrKniIq+8cbRHrkA6BwBbXYwDQYJKoZIhvcNAQEBBQAE
# ggEAXIedVl2WAn6qU9FAfCW5hd1tAlgszy5t9vNuO6kJ/ygXT8vifHlluYOxakqz
# PpdkoYv28EkLv34nfygHsrRh7oaNVHniJ2ZqNmpd62nzfL77NMzIHpCT5Mq7NsnM
# XGKf5aEJ9T6ToAKGY0RJNXkIstrgpzc0JK+4ovX2Ih9g8naqh1DcR5AO3yCuWZwB
# 5pUtyWesj7HrnIRfrcMUipJaS4P8QtR3KJQT79i1qMKsmOpnPGEZi5+riH7s3879
# 3SgS1V391y/i/bmFBKcnWLy0schx1KxxBUfBaCg2y4ZmvAxlYERzLeNFnBeshgEf
# NVN00UUK36xhb4IS2nxaLRz9Rg==
# SIG # End signature block
