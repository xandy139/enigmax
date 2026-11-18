@echo off
set PATH=%PATH%;C:\Users\alexa\flutter\bin
cd /d "%~dp0"
echo Iniciando EnigmaX no Chrome...
flutter run -d chrome
pause
