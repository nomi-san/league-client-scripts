@echo off

set /p name="Enter player name: "

:: Get LeagueClientUx's commandline
for /F "tokens=* USEBACKQ" %%a in (
    `"WMIC PROCESS WHERE name='LeagueClientUx.exe' GET commandline | findstr ."`
) do set "cmdline=%%a"

:: Split commandline by space
for %%a in (%cmdline%) do (
    :: Split arguments by "="
    for /f "tokens=1,2 delims==" %%i in (%%a) do (
        :: Get app port
        if "%%i"=="--app-port" (
            set "port=%%j"
        )
        :: Get auth token (pass)
        if "%%i"=="--remoting-auth-token" (
            set "pass=%%j"
        )
    )
)

curl -k -u riot:%pass% "https://127.0.0.1:%port%/lol-summoner/v1/summoners?name=%name%"
pause > nul
