#This script is intended for version 8.x of Websense
#define switches
param(
[switch]$start,
[switch]$stop,
[switch]$restart
)



#stop Websense DSS services
function stop-DSSservices {
    $1 = Get-Service -Name DSSBatchServer
    $2 = Get-Service -Name DSSMessageBroker
    $3 = Get-Service -Name PAFPREP
    $4 = Get-Service -Name WorkScheduler
    $5 = Get-Service -Name EPServer
    $6 = Get-Service -Name DSSManager
    $7 = Get-Service -name PolicyEngine
    schtasks.exe /CHANGE /TN "Websense TRITON AP-DATA Watchdog" /disable
    Write-Host -ForegroundColor Yellow "Stopping Services"
    if ($1.Status -eq "running") {Stop-Service -Name $1.Name}
    if ($2.Status -eq "running") {Stop-Service -Name $2.Name}
    if ($3.Status -eq "running") {Stop-Service -Name $3.Name}
    if ($4.Status -eq "running") {Stop-Service -Name $4.Name}
    if ($5.Status -eq "running") {Stop-Service -Name $5.Name}
    if ($6.Status -eq "running") {Stop-Service -Name $6.Name}
    if ($7.Status -eq "running") {Stop-Service -Name $7.Name}
}
#Start Websense DSS Services
function start-DSSservices {
    $1 = Get-Service -Name DSSBatchServer
    $2 = Get-Service -Name DSSMessageBroker
    $3 = Get-Service -Name PAFPREP
    $4 = Get-Service -Name WorkScheduler
    $5 = Get-Service -Name EPServer
    $6 = Get-Service -Name DSSManager
    $7 = Get-Service -name PolicyEngine
    schtasks.exe /CHANGE /TN "Websense TRITON AP-DATA Watchdog" /enable
    Write-Host -ForegroundColor Yellow "Starting Services"
    start-service -Name $7.Name
    start-service -Name $6.Name
    start-service -Name $5.Name
    start-service -Name $4.Name
    start-service -Name $3.Name
    start-service -Name $2.Name
    start-service -Name $1.Name
}    
 #Define switch actions
if ($stop.IsPresent -match "true" -and $start.IsPresent -match "false" -and $restart.IsPresent -match "false") {
    stop-DSSservices
    Write-Host -ForegroundColor Yellow "Done!"
}
if ($stop.IsPresent -match "false" -and $start.IsPresent -match "true" -and $restart.IsPresent -match "false") {
    start-DSSservices
    Write-Host -ForegroundColor Yellow "Done!"
}
if ($stop.IsPresent -match "false" -and $start.IsPresent -match "false" -and $restart.IsPresent -match "true") {
    stop-DSSservices
    start-DSSservices
    Write-Host -ForegroundColor Yellow "Done!"
}
if ($stop.IsPresent -match "false" -and $start.IsPresent -match "false" -and $restart.IsPresent -match "false") {
    Write-Host -ForegroundColor Yellow "syntax is: DssAdmin [-stop -start -restart] "
}
if ($stop.IsPresent -match "true" -and $start.IsPresent -match "true" -and $restart.IsPresent -match "true") {
    Write-Host -ForegroundColor Yellow "syntax is: DssAdmin [-stop -start -restart] "
}

#Matt Dudlo version 1.2



# SIG # Begin signature block
# MIIaKAYJKoZIhvcNAQcCoIIaGTCCGhUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKWQ7ba/wvlgqK26rCCaaCXnI
# W5Gggg0nMIIF2TCCA8GgAwIBAgIHEAD16+A5QzANBgkqhkiG9w0BAQsFADB9MQsw
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
# MRYEFKxhI0IldqmGAQ3lPj+LrBRuK3juMA0GCSqGSIb3DQEBAQUABIICANC3pcD4
# BCY9eey4Ll+j1tW9uEx1yjSyjv2h2Wvtp5kUnW010JR/e1bghVtKzkc4937k59j2
# WyxziJyld/0PTwznaV/ygaNTJGr268o7+l7KGQwOXWJ1HJaQJ6GEHE3g5Hs9nE7M
# pCEE/g+ap3R+0mXyPZUK9OpVnvDDNozmZkm1u8un59Vcz8/fdxlOkouwojCVrBgi
# wHyPo7lPXtuxCGYcN0NzYNPFUE8eDmbijJPZhmQOd4AQ80xrfXJKZFL1S80dEfy9
# PCUNTFlNgbFP1NTeN7qJJi+VDadb/EBnE9xLYOl6yTPQ4qJEq/HKAdvL+Yyxf0YH
# ML4NFdikejRcpSTGFtJyaOUoDKZpckV+9kcFx1TodsWKCMC/mf2OvjUsfTRW4g8f
# /XwhXrv3IVPxMCU+TNw0DOFWQfFNB0PD3ZUE65EjKVxSqnuIUobv6E/jGjNwNZDh
# y//zLBss2w78Mgq18jz75FJMkLkH+bWcRNsDFhYoXzch1+PHE2lJt4opCgiGaLJg
# X5TY2Y9/tJpi2TxK8XjNj9QrzZkhndN3iiA4WK/4yFZCjtOTRzrORrRy/zGDP/qj
# hwBmqqovz9NaaDlPLHclWFjZr2aGe/3lrLjabv3PuQAqxUbzu5NPZZo0UAVYCjjX
# TYmNnHEWs2BLv9jzZrEOAT8LFbAsRy4elaBsoYIJLTCCCSkGCisGAQQBgjcDAwEx
# ggkZMIIJFQYJKoZIhvcNAQcCoIIJBjCCCQICAQMxCzAJBgUrDgMCGgUAMIHIBgsq
# hkiG9w0BCRABBKCBuASBtTCBsgIBAQYLKwYBBAGBtTcBAgAwITAJBgUrDgMCGgUA
# BBTOx3UNNXvvDTSJ4ITK4P4AIg9fSwIDa8lUGA8yMDE1MTAyMjE3MzcxNVowAwIB
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
# MTczNzE1WjAjBgkqhkiG9w0BCQQxFgQUEvJoxnquZfoKMETZu8aVEHXRQFwwKwYL
# KoZIhvcNAQkQAgwxHDAaMBgwFgQUli/d12xhRa2vpemtmOMCDQgh3YEwDQYJKoZI
# hvcNAQEBBQAEggEApfhd5w8y4560eIL4fZjXCvuHBkLklG3n9aNWYKD69x9xcIcA
# Bo+0h+B2x+0S5tDNxfwzTvT2jUIt/IUkToqBm0UItCfP28w4/al3ga03T5uyHhd9
# wvsEwzczEAiE5yCI99ome2AfmjgSS2wUzgGEg5OordByzQiJCF0H7Z0oIAK3pOZh
# wMb/TBJ2XEvApLQiLnMzy/eCpQEe7u8HxcDH7pzcfjxYFHrYJscIkZJBhlxlpQYs
# Jg6LivEhYc0SVwDdxvlnprHf5WpJhX796xE0ED1g8xe5Mb4KZiCd1qEONOx5GpZC
# v+qH0dfx3cE60UuSNUbZclOq2OoGggsmnygeYw==
# SIG # End signature block
