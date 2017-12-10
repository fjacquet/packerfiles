Write-Output "Configuring proxy"
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value ""
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 0


exit 0