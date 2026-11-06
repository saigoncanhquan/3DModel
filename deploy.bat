@echo off
chcp 65001 >nul
title Saigon Canh Quan - Auto Deploy 3D Model to GitHub

echo ======================================================================
echo           SAIGON CẢNH QUAN - 3D MODEL GITHUB DEPLOYMENT
echo ======================================================================
echo.

:: 1. Di chuyển về đúng thư mục dự án
cd /d "%~dp0"
echo [*] Thư mục làm việc: %CD%
echo.

:: 2. Kiểm tra trạng thái Git
echo [*] Kiểm tra trạng thái Git:
git status -s
echo.

:: 3. Chuẩn bị Commit Message
set "USER_MSG=%*"
if "%USER_MSG%"=="" (
    for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"`) do set "TIMESTAMP=%%i"
    set "COMMIT_MSG=Auto update 3D model [!TIMESTAMP!]"
) else (
    set "COMMIT_MSG=%USER_MSG%"
)

:: Fix for delayed expansion if needed
setlocal enabledelayedexpansion
if "%USER_MSG%"=="" (
    set "COMMIT_MSG=Auto update 3D model [!TIMESTAMP!]"
)
echo [*] Commit Message: "!COMMIT_MSG!"
echo.

:: 4. Thêm toàn bộ thay đổi và commit
echo [*] Đang thêm file (git add .)...
git add .

echo [*] Đang commit mã nguồn...
git commit -m "!COMMIT_MSG!"
if errorlevel 1 (
    echo [i] Không có thay đổi mới nào cần commit hoặc đã được commit trước đó.
)

:: 5. Đẩy lên nhánh main trên GitHub
echo.
echo [*] Đang đẩy lên GitHub (git push origin main)...
git push origin main

if errorlevel 0 (
    echo.
    echo ======================================================================
    echo  [✓] THÀNH CÔNG: Toàn bộ mô hình và mã nguồn đã được cập nhật!
    echo      GitHub Pages: https://saigoncanhquan.github.io/3DModel/
    echo ======================================================================
) else (
    echo.
    echo [X] CẢNH BÁO: Quá trình đẩy lên GitHub gặp lỗi. Vui lòng kiểm tra kết nối mạng hoặc quyền truy cập.
)

echo.
echo Cửa sổ sẽ tự động đóng sau 3 giây...
timeout /t 3 >nul
exit /b 0
