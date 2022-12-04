@echo off

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

:: Remove all challenger tokens
curl -k -g ^
    -u riot:%pass% ^
    -H "Content-Type: application/json" ^
    -X POST ^
    -d "{\"challengeIds\": []}" ^
    "https://127.0.0.1:%port%/lol-challenges/v1/update-player-preferences/"
    
echo Done!
pause
