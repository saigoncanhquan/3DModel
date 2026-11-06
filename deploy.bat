@echo off
setlocal
chcp 65001 >nul
title Saigon Canh Quan - Auto Deploy 3D Model to GitHub

echo ======================================================================
echo           SAIGON CANH QUAN - 3D MODEL GITHUB DEPLOYMENT
echo ======================================================================
echo.

cd /d "%~dp0"
echo [*] Thu muc lam viec: %CD%
echo.

echo [*] Kiem tra trang thai Git:
git status -s
echo.

set "USER_MSG=%*"
if "%USER_MSG%"=="" (
    for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set "TIMESTAMP=%%i"
    set "COMMIT_MSG=Auto update 3D model [%%TIMESTAMP%%]"
) else (
    set "COMMIT_MSG=%USER_MSG%"
)

setlocal enabledelayedexpansion
if "%USER_MSG%"=="" set "COMMIT_MSG=Auto update 3D model [!TIMESTAMP!]"
echo [*] Commit Message: "!COMMIT_MSG!"
echo.

echo [*] Dang them file: git add .
git add .

echo [*] Dang commit ma nguon...
git commit -m "!COMMIT_MSG!"

echo.
echo [*] Dang day len GitHub: git push origin main
git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ======================================================================
    echo  [OK] THANH CONG: Toan bo mo hinh va ma nguon da duoc cap nhat!
    echo       Website: https://saigoncanhquan.github.io/3DModel/
    echo ======================================================================
) else (
    echo.
    echo [!] CANH BAO: Qua trinh day len GitHub gap loi.
)

echo.
echo Cua so se tu dong dong sau 3 giay...
ping 127.0.0.1 -n 4 >nul
exit /b 0
