Write-Output " Set NFS on manual "
Set-Service NfsClnt -startuptype "manual"
Set-Service NfsService -startuptype "manual"
Update-Help

Write-Output " Change to swiss keyboard"
Set-TimeZone "Central Europe Standard Time"

Set-WinSystemLocale fr-CH
$langList = New-WinUserLanguageList fr-CH
Set-WinUserLanguageList $langList -force -Confirm:$false

$nic = get-netadapter
Disable-NetAdapterBinding –InterfaceAlias $nic.name –ComponentID ms_tcpip6

exit 0