<#
.SYNOPSIS
    Script tự động đồng bộ và đẩy mã nguồn 3D Model lên GitHub cho Saigon Cảnh Quan.
.PARAMETER Message
    Thông điệp commit tùy chọn. Nếu để trống, script sẽ tự động gán timestamp thời gian thực.
.EXAMPLE
    .\deploy.ps1
    .\deploy.ps1 -Message "Thêm mô hình mới sh-3"
#>
[CmdletBinding()]
param(
    [string]$Message = ""
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Saigon Canh Quan - Auto Deploy 3D Model to GitHub"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "          SAIGON CẢNH QUAN - 3D MODEL GITHUB DEPLOYMENT (POWERSHELL)  " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Di chuyển về đúng thư mục dự án
Set-Location -Path $PSScriptRoot
Write-Host "[*] Thư mục làm việc: $PSScriptRoot" -ForegroundColor Gray
Write-Host ""

# 2. Kiểm tra trạng thái Git
Write-Host "[*] Kiểm tra trạng thái Git:" -ForegroundColor Yellow
git status -s
Write-Host ""

# 3. Chuẩn bị Commit Message
if ([string]::IsNullOrWhiteSpace($Message)) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $commitMsg = "Auto update 3D model [$timestamp]"
} else {
    $commitMsg = $Message
}

Write-Host "[*] Commit Message: `"$commitMsg`"" -ForegroundColor Green
Write-Host ""

# 4. Git add & commit
Write-Host "[*] Đang thêm file (git add .)..." -ForegroundColor Yellow
git add .

Write-Host "[*] Đang commit mã nguồn..." -ForegroundColor Yellow
git commit -m $commitMsg

# 5. Git push origin main
Write-Host ""
Write-Host "[*] Đang đẩy lên GitHub (git push origin main)..." -ForegroundColor Yellow
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host " [✓] THÀNH CÔNG: Toàn bộ mô hình và mã nguồn đã được cập nhật!" -ForegroundColor Green
    Write-Host "     Website GitHub Pages: https://saigoncanhquan.github.io/3DModel/" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[X] CẢNH BÁO: Quá trình đẩy lên GitHub gặp lỗi. Vui lòng kiểm tra quyền truy cập Git hoặc kết nối mạng." -ForegroundColor Red
}

Write-Host ""
Write-Host "Cửa sổ sẽ tự động đóng sau 3 giây..." -ForegroundColor Gray
Start-Sleep -Seconds 3

