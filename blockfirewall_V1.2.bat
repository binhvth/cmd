@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Chạy lại với quyền Admin...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Kích hoạt delayed expansion
setlocal enabledelayedexpansion

:: Lấy đường dẫn hiện hành
set "current=%~dp0"

:: Liệt kê đệ quy các file .exe và .msi vào output1.txt
dir /s /b "%current%*.exe" > "E:\output1.txt"
dir /s /b "%current%*.task" >> "E:\output1.txt"
dir /s /b "%current%*.update" >> "E:\output1.txt"
:: Đọc từng dòng từ file output và tạo rule chặn
for /f "delims=" %%i in (E:\output1.txt) do (
    set "filepath=%%i"
    echo Đang chặn: !filepath!
    netsh advfirewall firewall add rule name="BlockMyApp %%~ni" dir=out action=block program="!filepath!" enable=yes
)

pause