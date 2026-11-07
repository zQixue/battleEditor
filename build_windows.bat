@echo off
setlocal
cd /d "%~dp0"

rem Default to flutter/dart on PATH. To use another SDK, set FLUTTER_BIN first:
rem   set FLUTTER_BIN=F:\sdk\flutter\bin\flutter.bat
set "FLUTTER=flutter"
set "DART=dart"
if defined FLUTTER_BIN (
  set "FLUTTER=%FLUTTER_BIN%"
  for %%I in ("%FLUTTER_BIN%") do (
    if exist "%%~dpIdart.bat" set "DART=%%~dpIdart.bat"
  )
)

echo [1/4] flutter pub get
call "%FLUTTER%" pub get || goto :error

rem Flutter 3.7 on Windows without Developer Mode copies plugin directories.
rem The build step then tries to create the same links again and fails with
rem errno 183, so clear the generated directory before building.
if exist "windows\flutter\ephemeral\.plugin_symlinks" rmdir /S /Q "windows\flutter\ephemeral\.plugin_symlinks"

echo [2/4] flutter build windows --release
call "%FLUTTER%" build windows --release || goto :error

echo [3/4] deploy CoolFormat.exe
copy /Y "tools\CoolFormat.exe" "build\windows\runner\Release\CoolFormat.exe" >nul || goto :error

echo [4/4] build restart.exe
call "%DART%" compile exe lib\CmdRestart.dart -o build\windows\runner\Release\restart.exe || goto :error

echo.
echo Build OK: build\windows\runner\Release\battleEditor.exe
exit /b 0

:error
echo.
echo Build FAILED.
exit /b 1
