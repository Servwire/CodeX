@echo off & setlocal EnableDelayedExpansion
chcp 1257

set ip=%%A
set subnet=%%B
set gateway=%%C

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
IF "%%H" == "Connected" set "adapter=%%J" & goto found
)
:found

:loop
ping -n 1 api.ipify.org >nul
if %errorlevel% == 0 (
  	echo Request to api.ipify.org successful.
  	timeout /t 10 >nul
  	goto loop
) else (
  goto set
)

:set
echo Request to api.ipify.org failed.
echo Resetting network adapter...
echo EAD : %adapter%

netsh interface ip set address "%adapter%" static %ip% %subnet% %gateway%
netsh interface ipv4 set dnsservers name="%adapter%" static 1.1.1.1
netsh interface ipv4 add dnsservers name="%adapter%" 1.0.0.1 index=2
timeout /t 15 >nul
goto loop
