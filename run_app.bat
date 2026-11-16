@echo off
title Vertical Ascent - Flutter Launcher
cd /d "%~dp0"
echo Launching Vertical Ascent (Shaft Hoist)...
echo 1. Chrome Web
echo 2. Windows Desktop
echo 3. Android Emulator (emulator-5554)
set /p choice="Select target (1/2/3, default 1): "
if "%choice%"=="2" (
    call C:\Projects\flutter\bin\flutter.bat run -d windows
) else if "%choice%"=="3" (
    call C:\Projects\flutter\bin\flutter.bat run -d emulator-5554 --android-skip-build-dependency-validation
) else (
    call C:\Projects\flutter\bin\flutter.bat run -d chrome
)
pause
