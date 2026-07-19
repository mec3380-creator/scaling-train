@echo off
chcp 65001 >nul
setlocal EnableExtensions

title 하루목록 제거

echo.
echo  ====================================
echo    하루목록 제거 프로그램
echo  ====================================
echo.

for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESKTOP=%%I"

if not defined DESKTOP (
  echo [오류] 바탕화면 경로를 찾지 못했습니다.
  pause
  exit /b 1
)

set "APPDIR=%DESKTOP%\하루목록"
set "SHORTCUT=%DESKTOP%\하루목록.lnk"

echo  바탕화면의 하루목록 폴더와 바로가기를 삭제합니다.
echo.
set /p CONFIRM="정말 제거할까요? (Y/N): "
if /I not "%CONFIRM%"=="Y" (
  echo 취소했습니다.
  pause
  exit /b 0
)

if exist "%SHORTCUT%" del /F /Q "%SHORTCUT%"
if exist "%APPDIR%" rmdir /S /Q "%APPDIR%"

echo.
echo  제거가 완료되었습니다.
echo.
pause
exit /b 0
