net stop wuauserv
rmdir /S /Q C:\Windows\SoftwareDistribution\Download
mkdir C:\Windows\SoftwareDistribution\Download
net start wuauserv

Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

REM cmd /c "%ProgramFiles%\ultradefrag\udefrag.exe --optimize --repeat C:"

REM cmd /c "%SystemRoot%\System32\reg.exe ADD HKCU\Software\Sysinternals\SDelete /v EulaAccepted /t REG_DWORD /d 1 /f"
REM cmd /c "sdelete.exe -q -z C:"


exit 0
