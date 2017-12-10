
Write-Output "Disable IPv6"
# Disable IPv6 Transition Technologies
netsh int teredo set state disabled
netsh int 6to4 set state disabled
netsh int isatap set state disabled
netsh interface tcp set global autotuninglevel=disabled

Write-Output " Disable-InternetExplorerESC"
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey  -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer

Write-Output " Disable antivirus"
Set-MpPreference -DisableRealtimeMonitoring $true

Write-Output " Disable firewall"
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

Write-Output " Install basic features "
$features = @("DSC-Service", "FS-NFS-Service", "NFS-Client", "GPMC", "Multipath-IO", "RSAT", "SNMP-Service", "Storage-Services")
foreach ($feature in $features) {
    Write-Output "installing $feature"
    install-windowsfeature -Name $feature -IncludeAllSubFeature -IncludeManagementTools -Confirm:$false
}
exit 0
