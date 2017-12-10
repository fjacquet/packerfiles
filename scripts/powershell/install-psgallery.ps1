Write-Output "Configuring PowerShell mudules "
Set-ExecutionPolicy unrestricted -force -Confirm:$false
ProxyAddress = 'http://172.16.86.10:3128'
$null = & netsh @('winhttp','set','proxy',$ProxyAddress)
# Nice PowerShell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false -Verbose
Install-Module -Name VMware.PowerCLI -Force -Confirm:$false -AllowClobber -Verbose
Install-Module -Name Pscx  -Force -Confirm:$false -AllowClobber
Install-Module -Name PSExcel -Force -Confirm:$false -Verbose
Install-Module -Name Posh-SSH -Force -Confirm:$false -Verbose
Install-Module -Name PSWindowsUpdate -Force -Confirm:$false -Verbose
Install-Module -Name PSScriptAnalyzer  -Force -Confirm:$false -Verbose
Install-Script -Name Request-Certificate -Force -Confirm:$false -Verbose
Install-Script -Name UnattendXml  -Force -Confirm:$false -Verbose
Install-Module -Name Pester -Force -Confirm:$false -Verbose
exit 0