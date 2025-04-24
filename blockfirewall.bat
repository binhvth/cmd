@echo off
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Chạy lại với quyền Admin...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
::Lấy đường dẫn hiện hành
set current=%~dp0


:: Liệt kê các file có định dạng exe, msi từ thư mục hiện hành đưa vào file output1.txt
dir /b "%current%*.exe" > "D:\output1.txt"
dir /b "%current%*.msi" >> "D:\output1.txt"
for /f "delims=" %%i in (D:\output1.txt) do (
    ::echo %%i
    set variable=%%i
    netsh advfirewall firewall add rule name="Block MyApp %%i" dir=out action=block program="%current%%%i" enable=yes
)
pause

