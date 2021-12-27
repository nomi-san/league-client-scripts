@echo off & setlocal
echo\

:: Check for elevated (fucking gxxsvc)
net SESSION 1>nul 2>nul
if %errorlevel% NEQ 0 (
    echo Please run as Admin.
    exit /b 2
)

:: Check for LC running
tasklist /fi "ImageName eq LeagueClient.exe" /fo csv 2>NUL | find /I "LeagueClient.exe">NUL
if %errorlevel% NEQ 0 (
    echo League Client is not running.
    exit /b 2
)

:: Get RiotClientServices's command line
for /F "tokens=* USEBACKQ" %%a in (
    `"WMIC PROCESS WHERE name='RiotClientServices.exe' GET commandline | findstr ."`
) do set cmd_line=%%a

:: Kill RiotClientServices
taskkill /F /IM RiotClientServices.exe
timeout 2 > NUL

:: Kill LeagueClient
taskkill /F /IM LeagueClient.exe
timeout 5 > NUL

:: Start RiotClientServices
start "" %cmd_line%

echo\
endlocal
