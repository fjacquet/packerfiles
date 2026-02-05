Write-Output "Configuring chocolatey"

Set-ExecutionPolicy unrestricted -force -Confirm:$false
# $env:chocolateyProxyLocation = 'http://172.16.86.10:3128'
# Install Chocolatey
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# choco config set proxy http://172.16.86.10:3128
choco install 7zip.install -y
choco install baretail -y
choco install bginfo -y
choco install chef-client -y
choco install chefdkt -y
choco install curl -y
choco install firefox -y
choco install googlechrome -y
choco install inspec -y
choco install iiscrypto -y
choco install jre8 -y
choco install mobaxterm -y
choco install notepadplusplus -y
choco install powershell -y
choco install puppet -y
choco install putty -y
choco install sysinternals -y
choco install ultradefrag -y
choco install vscode -y
choco install windirstat -y

exit 0