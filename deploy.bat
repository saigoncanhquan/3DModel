@echo off
chcp 65001 >nul
title Deploy 3D CAD to GitHub Pages
cd /d "%~dp0"
echo ========================================================
echo   DEPLOY 3D WEBGL CAD LEN GITHUB PAGES (100%% FREE HOSTING)
echo   Project: Unnamed-par33
echo ========================================================
echo.
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [LOI] Khong tim thay Git tren may tinh. Vui long cai dat Git tai: https://git-scm.com/
    goto :done
)
set /p REPO_URL=<repo_url.txt 2>nul
if "%REPO_URL%"=="" (
    echo Vui long nhap URL Repository GitHub cua ban:
    echo (Vi du: https://github.com/username/ten-repo.git)
    set /p REPO_URL="Repo URL: "
    if "%REPO_URL%"=="" (
        echo [LOI] URL khong duoc de trong!
        goto :done
    )
    echo %REPO_URL%>repo_url.txt
)
echo Dang khoi tao va deploy len nhanh gh-pages...
if not exist .git (
    git init
    git remote add origin %REPO_URL%
) else (
    git remote set-url origin %REPO_URL%
)
git checkout -B gh-pages
git add .
git commit -m "Deploy 3D CAD Model: Unnamed-par33"
echo Dang push len GitHub...
git push -u origin gh-pages --force
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [THANH CONG] Da deploy thanh cong len GitHub Pages!
    echo Trang web se san sang sau 1-2 phut tai GitHub Pages cua ban.
) else (
    echo.
    echo [LOI] Khong the push len GitHub. Vui long kiem tra URL repo va quyen truy cap.
)
:done
echo.
pause
