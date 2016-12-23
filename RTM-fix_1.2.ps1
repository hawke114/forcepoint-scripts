#This script is intended for Websense Versions 7.8 and 8.0 
param(
[switch]$confirm
)

[string]$rtm = "C:\Program Files (x86)\Websense\Web Security\rtm\bin"
[string]$path = Test-Path $rtm
$WarningPreference = "stop"

function stop-services {
$a = get-service -DisplayName ("Websense RTM Client")
$b = get-service -DisplayName ("Websense RTM Server")
$c = get-service -DisplayName ("Websense RTM Database")
write-host -ForegroundColor DarkRed Stopping $a.DisplayName
if ($a.status -eq "running") {stop-service $a.DisplayName -WarningAction Continue}
write-host -ForegroundColor DarkRed Stopping $b.DisplayName
if ($b.status -eq "running") {Stop-Service $b.DisplayName -WarningAction Continue}
write-host -ForegroundColor DarkRed Stopping $c.DisplayName
if ($b.status -eq "running") {stop-service $c.DisplayName -WarningAction Continue}
}

function start-services {
$a = get-service -DisplayName ("Websense RTM Client")
$b = get-service -DisplayName ("Websense RTM Server")
$c = get-service -DisplayName ("Websense RTM Database")
write-host -ForegroundColor Green Starting $c.DisplayName
Start-Service -DisplayName $c.DisplayName -WarningAction Continue
Write-Host -ForegroundColor Green Starting $b.DisplayName
Start-Service -DisplayName $b.DisplayName -WarningAction Continue
Write-Host -ForegroundColor Green Starting $a.DisplayName
Start-Service -DisplayName $a.DisplayName -WarningAction Continue
Write-Host -ForegroundColor Yellow Done!
}

function rename-p12 {
cd $RTM
rm -Recurse felix-cache
$exist = Test-Path *.p12
if ([string]$exist -match "true") {
    Get-ChildItem -Filter "*.p12" | Rename-Item -NewName {$_.name -replace '.p12','.p12_old'}
    }
}

function main-task {
    Write-Host -ForegroundColor Green "Path is valid, modifying files and restarting services"
    stop-services
    Write-Host -ForegroundColor DarkGreen "modifying files"
    rename-p12
    start-services
}

if ([string]$confirm.ispresent -match "false") {
    Write-Host -ForegroundColor cyan -nonewline "#################################################################################################################################################"
    Write-Host -ForegroundColor Yellow "
    This script is provided as a troubleshooting tool only, use it at your own risk.
    It is the responsibility of the system owner/manager to create backups of their system prior to executing this script.
    Please create a backup of your Web Security configuration by running the command 'wsbackup -b -d <directory>' from the Websense\bin directory
    If you understand this warning, and have created the appropriate backups, you may execute this script with the '-confirm' switch to continue"

    Write-Host -ForegroundColor Cyan "#################################################################################################################################################"
    
    Write-Warning -Message "Script stopped, no action performed"
    }
    
[string]$path2 = Test-Path $rtm'\felix-cache'

if ([string]$path -eq "true" -and [string]$path2 -eq "true") {
    main-task
    }
    else {
        while ([string]$path -eq "false" -and [string]$path2 -eq "false") {
            Write-Host -ForegroundColor Yellow "Please input full path to '\Websense\Web Security\rtm\bin':" -NoNewline
            $rtm = Read-Host
            [string]$path = Test-Path $rtm
            [string]$path2 = Test-Path $rtm'\felix-cache'
        }
    main-task
}
#Matt Dudlo Version 1.2


# SIG # Begin signature block
# MIIaKAYJKoZIhvcNAQcCoIIaGTCCGhUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWowGpmMDGXTfCjQ/NcSctKrj
# ezmggg0nMIIF2TCCA8GgAwIBAgIHEAD16+A5QzANBgkqhkiG9w0BAQsFADB9MQsw
# CQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2Vj
# dXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzEpMCcGA1UEAxMgU3RhcnRD
# b20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMDcxMDE0MjIwMTQ2WhcNMjIx
# MDE0MjIwMTQ2WjCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0
# ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcx
# ODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUg
# T2JqZWN0IENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyiOLIjUe
# mqAbPJ1J0D8MlzgWKbr4fYlbRVjvhHDtfhFN6RQxq0PjTQxRgWzwFQNKJCdU5ftK
# oM5N4YSjId6ZNavcSa6/McVnhDAQm+8H3HWoD030NVOxbjgD/Ih3HaV3/z9159nn
# vyxQEckRZfpJB2Kfk6aHqW3JnSvRe+XVZSufDVCe/vtxGSEwKCaNrsLc9pboUoYI
# C3oyzWoUTZ65+c0H4paR8c8eK/mC914mBo6N0dQ512/bkSdaeY9YaQpGtW/h/W/F
# kbQRT3sCpttLVlIjnkuY4r9+zvqhToPjxcfDYEf+XD8VGkAqle8Aa8hQ+M1qGdQj
# Aye8OzbVuUOw7wIDAQABo4IBTDCCAUgwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNV
# HQ8BAf8EBAMCAQYwHQYDVR0OBBYEFNBOD0CZbLhLGW87KLjg44gHNKq3MB8GA1Ud
# IwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7yMGkGCCsGAQUFBwEBBF0wWzAnBggr
# BgEFBQcwAYYbaHR0cDovL29jc3Auc3RhcnRzc2wuY29tL2NhMDAGCCsGAQUFBzAC
# hiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwMgYDVR0fBCsw
# KTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2ZzY2EuY3JsMEMGA1Ud
# IAQ8MDowOAYEVR0gADAwMC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3Ns
# LmNvbS9wb2xpY3kucGRmMA0GCSqGSIb3DQEBCwUAA4ICAQA1suVmF5Qm9DFAVnNH
# 6dxjIjln3EdotpZpTSDWoz7MIi2sk+pHs7Km0wAk2CN7wSpOIAbMn6AedFbmW9wc
# j8lRlNGnWzpCMAvmnu/2+rEKjI4wPLDUKvL7pH1VdqklDVJ3hZMqwfxjpekaGaIW
# uNhL0NWcGHp/3s1pWjSIhuE0/ejUnZBpazfQk2oP7uTkPmfG4psvgZFVuhclfMzK
# 7hZq8zG/Oo9QOdaFzgOBFLMkQ8mnJYZcZBGo65V2am/aDDZmTW1/HY/OdrYw7abZ
# CY/jliHDtvLwWhENowUEm6LDNTulvgcTPLQXmL4qw7+rF7FCzMZdp/QxKoIa5Cy+
# HZDcEyr17/spgPqJZYpNPqop6zOg+o1co84NXzyM2tdzVzY6CYYHIdNyEHe6aUDn
# QNMskpKoQgarLWhTTmi3xCx86ndgnd6wFPGT5X8J8R5Oc/+TGRxAo5296cq2UnUC
# 8Kp2mLdxhBh9zMYkcno3q738GBMqB3/aSHiwAm2GDv97l3Y+vCihicyW70GtSijM
# DX4tG7WM0xBAopTYTirHaS+HQWkyxg65D0CQdwWQS6rpFWjw4npyEuB7MctBYGA9
# T7RRgdHoNiX3AYbslZaBwS2cLiVxhIwIcihPOIAQysmlRzeNXDIEmXUOo1HH2WMV
# ldDG8QyTKNrS2fLIwfmj2+SIqTCCB0YwggYuoAMCAQICBxNJVLj9kZwwDQYJKoZI
# hvcNAQELBQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQu
# MSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgw
# NgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIE9i
# amVjdCBDQTAeFw0xNTEwMjEwMjIyMTNaFw0xNzEwMjEwNzQ2MDZaMHoxCzAJBgNV
# BAYTAlVTMREwDwYDVQQIEwhJbGxpbm9pczEWMBQGA1UEBxMNSGlja29yeSBIaWxs
# czEWMBQGA1UEAxMNTWF0dGhldyBEdWRsbzEoMCYGCSqGSIb3DQEJARYZbWF0dC5k
# dWRsb0BoYXdrZWFkbWluLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoC
# ggIBANnUwaVrsGe4+EfTMZDn6UgkcpHZc9ckcLKx4qMbzHNtl9pj/4QSc37RLIgh
# lgGxJE50/guFHHkR606FJ/qfmULIJqK5LcsAscPm/pzSdKbkLia3I5TZWmlFPfVK
# 6jBTwYRnRU1HcaEuYHbt3HWmOIBxb568ouhYCzK+1epJssj5F9zHNQtxlZHFMcy+
# ZHNlKQkvXd9jDkHg59wbOVw6bwvqpxZElTA8pKYYP2cW5jlSnsh+TjstBnFsjKN7
# G+um/s9C7L84fuHmBCER06ua9V+rk/T2bIt8wMoBbLGmTJmil6YPwIzlVjcF9ETH
# KYrs5m+y7qu+OGKB+65Kjhb7MEcOeC3V1tjzjh+YnXWcNtqfITif+LCnPXLlFg36
# O2XZrXgq5C8D0C243D7bqDhmLb/2MC5gHMO87XrGGXtedJB8VLJu+Y52gO0XyI91
# ginKpCUWfhpmFFPxdUOsdZ6AhScbaQk95ud0qP7sm/2/EKmFVYng5cyD4GYdMwfF
# eOzKi8ZPD/FI7qS1pWZlXmH7746GiA/MKVEAmtA9kou06pS2CZ/dADa37fHirhu4
# n7z5nixfcXD1i/1q+c8bjg9oG8bqdWsXDUH/oVFves15BiJ1HwbUzmVIGCPF3fU+
# HHrWwGSlZuw7AfU4ZEmrmJEAGCU6075mAMSBJaskMKmPz/ePAgMBAAGjggK8MIIC
# uDAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIHgDAiBgNVHSUBAf8EGDAWBggrBgEF
# BQcDAwYKKwYBBAGCNwoDDTAdBgNVHQ4EFgQUh2XraHlsWH8U8KuK3t801tsdqWkw
# HwYDVR0jBBgwFoAU0E4PQJlsuEsZbzsouODjiAc0qrcwggFMBgNVHSAEggFDMIIB
# PzCCATsGCysGAQQBgbU3AQIDMIIBKjAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5z
# dGFydHNzbC5jb20vcG9saWN5LnBkZjCB9wYIKwYBBQUHAgIwgeowJxYgU3RhcnRD
# b20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwAwIBARqBvlRoaXMgY2VydGlmaWNh
# dGUgd2FzIGlzc3VlZCBhY2NvcmRpbmcgdG8gdGhlIENsYXNzIDIgVmFsaWRhdGlv
# biByZXF1aXJlbWVudHMgb2YgdGhlIFN0YXJ0Q29tIENBIHBvbGljeSwgcmVsaWFu
# Y2Ugb25seSBmb3IgdGhlIGludGVuZGVkIHB1cnBvc2UgaW4gY29tcGxpYW5jZSBv
# ZiB0aGUgcmVseWluZyBwYXJ0eSBvYmxpZ2F0aW9ucy4wNgYDVR0fBC8wLTAroCmg
# J4YlaHR0cDovL2NybC5zdGFydHNzbC5jb20vY3J0YzItY3JsLmNybDCBiQYIKwYB
# BQUHAQEEfTB7MDcGCCsGAQUFBzABhitodHRwOi8vb2NzcC5zdGFydHNzbC5jb20v
# c3ViL2NsYXNzMi9jb2RlL2NhMEAGCCsGAQUFBzAChjRodHRwOi8vYWlhLnN0YXJ0
# c3NsLmNvbS9jZXJ0cy9zdWIuY2xhc3MyLmNvZGUuY2EuY3J0MCMGA1UdEgQcMBqG
# GGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG9w0BAQsFAAOCAQEAP8ZL
# oBO/Eh5jaxoYXmlzg/fwqxPSBMWkq8xrEQBV5TdrRrZy1ROCU7dn8fPe/WoRRqKh
# rx1Cj1JrE4gjl8qAuKnmhuWxgNFFtEEiiJ4AgO1SpK+jOwgWrchKf3ttoR2mfD8Y
# pj4N3ZZiJ5UzX40JqHvXyEWpHzfFx6ZQnmu6qaCvYrMXdMy+ISKWDSOE48FI8WTt
# aT6Mr5MfBbxGAGP5LPkCY8D0hLy0T2z10F4EmlCRZ9D/i6iKDk4oX+sBjxiuQHOs
# MXOh9Dy5sKIw57pBjfjAlxEjhnn1hi77ZZ/iyfbx1FSqIVCedsnmg5bp1npLLNBX
# yobrBdJv/l/lkL8UrjGCDGswggxnAgEBMIGYMIGMMQswCQYDVQQGEwJJTDEWMBQG
# A1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2Vy
# dGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmlt
# YXJ5IEludGVybWVkaWF0ZSBPYmplY3QgQ0ECBxNJVLj9kZwwCQYFKw4DAhoFAKB4
# MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQB
# gjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkE
# MRYEFNW3cJA8B1xHHvu6sODvB2/mQ2vSMA0GCSqGSIb3DQEBAQUABIICAGKMpn/k
# 6NqU6lwOOhW2NvwKB3f9o8r4j0POh6fTjFqtQrYNOhrWdPpqFcUtEgBSNK9w21kF
# 1KE/dWvTIMBi+5CbX1qZMZ+8Ua91Um5gGMZ9bIcl4CUNJ0/Ch+kss7yVt+X+i7yM
# PRg6wrSW8XfrwinVd+FJSZY9QSLNssY1UJmFE1C41smzG4EMwstjBSTaHSNS9u5Y
# KBdsTNJzpXxNy6yuGj8N/Lj5zwXuzvEeg1JgD8f4i0ixlSfWFydYMzTAeNf+EnKK
# 2Fu0znlzevHBl1vTzCeQ4x2kx1XtQTCY5+KI9c5P/gTlYJjZ3IS5fiSHcxmteirg
# a9PseibRlevZ9WkEnq1wOChC2gW+f5ajp2M6UkeWf5BWB0VHA5n6N9u8ZYkoKEV2
# DPoLSmRQXkfH1CQbZVZrt0WITGwjru6fk3BQHth0JMKgoD8SMd7yPAuAFl26wTBy
# G+8PO2FFq+0vFrS6Ql0+iJxn7Pb3R7awWWpNQWFAidUnvj6yWMnOBxplWs1KS+QO
# QJSLSkkw4kTnaA1sIHrKOPpALDLm7H2S9unhxThNkM2Zd/PY1aSuVTa1Rn9HSoTM
# TyjG9rXv5dhhNd+yohcmLnX/7Yl2H2qmpiOCqWseTXz9Cjz2siehFOhNxPfWbpqk
# ShctCOOuM/gkBlWdPnoot44X8pnxJOBO/SSRoYIJLTCCCSkGCisGAQQBgjcDAwEx
# ggkZMIIJFQYJKoZIhvcNAQcCoIIJBjCCCQICAQMxCzAJBgUrDgMCGgUAMIHIBgsq
# hkiG9w0BCRABBKCBuASBtTCBsgIBAQYLKwYBBAGBtTcBAgAwITAJBgUrDgMCGgUA
# BBR1x0m6lfNfSN/1YRTsrBQLvkp95wIDa8lbGA8yMDE1MTAyMjE3MzgxMFowAwIB
# AaBipGAwXjEpMCcGA1UEAxMgU3RhcnRDb20gVGltZS1TdGFtcGluZyBBdXRob3Jp
# dHkxMTAvBgNVBAoTKFN0YXJ0Q29tIEx0ZC4gKFN0YXJ0IENvbW1lcmNpYWwgTGlt
# aXRlZCmgggXmMIIF4jCCA8qgAwIBAgIBQDANBgkqhkiG9w0BAQUFADB9MQswCQYD
# VQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJl
# IERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzEpMCcGA1UEAxMgU3RhcnRDb20g
# Q2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTEwMTMxMDAwMDAyWhcNMjEwMTMx
# MjM1OTU5WjBeMSkwJwYDVQQDEyBTdGFydENvbSBUaW1lLVN0YW1waW5nIEF1dGhv
# cml0eTExMC8GA1UEChMoU3RhcnRDb20gTHRkLiAoU3RhcnQgQ29tbWVyY2lhbCBM
# aW1pdGVkKTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALjaoj9hfSON
# ModNUS8q4EZ3OnpzQA9ectSCPPWAsQWQ7GfrcIllhCf90JOaEq4PNC9IFDJglQpd
# Tk4Rn7JTmo5xXWoEAJ8k7rf90k/lVXQKsvOody6XG/lGSHVmOELRhhzJQDbRSABw
# MdWSmWzJYeWvfgy2VbTf9mqTKctLQ869D7Hg9mPTpJkyBPXa6qRZtPfbOLWT/55Z
# mr57YHXG7U3fo0ykiL5j8zxxZY2q0iRYDtOLrCtKj/De6A2Xgpkti3mCd4DoWs1H
# aJUMcexw922xts3V1xw4/JaA5wFbxBKDA7pQZpDjjhFadtf6U5Bp+DPkFJGj9xCO
# iIBQFhFPkvUCAwEAAaOCAYowggGGMAwGA1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQD
# AgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMB0GA1UdDgQWBBR3JIbRNvGquYSU
# oECrkExDRnFwizAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jAjBgNV
# HRIEHDAahhhodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8waQYIKwYBBQUHAQEEXTBb
# MCcGCCsGAQUFBzABhhtodHRwOi8vb2NzcC5zdGFydHNzbC5jb20vY2EwMAYIKwYB
# BQUHMAKGJGh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL2NhLmNydDAyBgNV
# HR8EKzApMCegJaAjhiFodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zZnNjYS5jcmww
# SgYDVR0gBEMwQTA/BgsrBgEEAYG1NwECADAwMC4GCCsGAQUFBwIBFiJodHRwOi8v
# d3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMA0GCSqGSIb3DQEBBQUAA4ICAQCa
# rRNIeUWEJnTJ2SLg0OgfzSveY+CCaj15JlCDUBpfb39joVvtbLzcpL1G3W9hHo9w
# GKKG9L/a2RAvrIg35ZSGak3CuFO6MIz+nw34HiQFFpyTAhNqWopYQevnyq00EfG3
# 6gauV+a1Oe82+dt2wPwyt49xrTzHNvDhZ/0aytqMS/lm2owfWs5mBuid8xSOvq/3
# U1hPR9YCtLdq+9IxOTbsc2lWWnA4LPu9k87KaM+3qjITk5EmLcOWbW/6B41YTHRF
# rC+EifkGbtDVjQTRsoFiCQkZ+kh0DH8/jB9DdkmZqGkUyMrc4H6Dm5J3kMnwAyf1
# nz3HZgJLW4cndXCt7Itypel7w1PG1lR3Mv9mTT9WbLIDC00juVoVSkZ0zTOxs0jl
# TVW2B3+OweOSZJRSpPJcfrA4SFV+rEbIruPadohmaB1yVUk8msaAu+ulZfYkgFeW
# Lpb/camxXxhHEEFNY6Zu5GkneOmpx5BnrY7Fhg/uzaPMMNuvFXu8JzOSIXgX+pb+
# qjM0tJP5dY24m5qcOZgrwH1buKOd2y0+ZAaZn+eJYtySXNvn4G4Gqsbmg1S9EdLa
# +2C8qxDiN6KnW7iogtTV3gpuJNwTtabqigq08u000MTWWjI0siX4Vt5wVekEnVmL
# 2jlQGfcUzamJh9he0KdDHVoKWLUCbyHC3nQKB/CwQjGCAjkwggI1AgEBMIGCMH0x
# CzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
# ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFy
# dENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIBQDAJBgUrDgMCGgUAoIGMMBoG
# CSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAcBgkqhkiG9w0BCQUxDxcNMTUxMDIy
# MTczODEwWjAjBgkqhkiG9w0BCQQxFgQUHBsg8kG2sr6vO+M73ymoLEUgHfIwKwYL
# KoZIhvcNAQkQAgwxHDAaMBgwFgQUli/d12xhRa2vpemtmOMCDQgh3YEwDQYJKoZI
# hvcNAQEBBQAEggEAVo1BPc7UY0kFbr84kZkiqu83GUjYhb0OKR8GYH86KZyVqiVN
# VWKrf8sOqcnggf/Ez1JLiRzJ/DT+2HLj/hbKG6WmhyE2Hr6bubhSVXZzsuSandY2
# vAglXPepKQMtqvcerPK2qJgFgR7Z4i3lXqWMwpC1ywvM9hNfbrHC4wVcq+nZgK4G
# +JqTCBUF38uFF9KFtcGFZGYnzeya6sCbld4uqPH4H6vYHuUUFnLvrURpCdBys3mc
# vkVYTwYY0bSLYgbYLfIXLf93wpnmExIOTQjduehkVi8oqdhvE+D5y/9x/4/he1hv
# YLMUfHZYTFGzyToyeD4AGpB1YyUrYoqqSuQslg==
# SIG # End signature block
