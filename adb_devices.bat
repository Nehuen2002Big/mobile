@echo off
REM Verifica que adb detecta tu celular (despues de activar USB debugging).
set ANDROID_HOME=C:\android-sdk
set PATH=C:\android-sdk\platform-tools;%PATH%
adb devices
