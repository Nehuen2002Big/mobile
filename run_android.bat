@echo off
REM Script de conveniencia para levantar la app en Android.
REM Setea JAVA_HOME y ANDROID_HOME para esta sesion y lanza flutter run.

set JAVA_HOME=C:\android-sdk\jdk
set ANDROID_HOME=C:\android-sdk
set ANDROID_SDK_ROOT=C:\android-sdk
set PATH=%JAVA_HOME%\bin;C:\android-sdk\platform-tools;%PATH%

echo === Devices detectados ===
flutter devices

echo.
echo === Lanzando flutter run ===
flutter run
