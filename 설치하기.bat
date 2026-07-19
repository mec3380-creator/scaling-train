@echo off
chcp 65001 >nul
setlocal EnableExtensions

title 하루목록 설치

echo.
echo  ====================================
echo    하루목록 설치 프로그램
echo  ====================================
echo.

:: 이 bat 파일이 있는 폴더 (원본 파일 위치)
set "SOURCE=%~dp0"
set "SOURCE=%SOURCE:~0,-1%"

:: 필요한 파일이 있는지 확인
if not exist "%SOURCE%\index.html" goto :missing
if not exist "%SOURCE%\style.css" goto :missing
if not exist "%SOURCE%\app.js" goto :missing

:: 한글 Windows에서도 올바른 바탕화면 경로 찾기
for /f "usebackq delims=" %%I in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESKTOP=%%I"

if not defined DESKTOP (
  echo [오류] 바탕화면 경로를 찾지 못했습니다.
  pause
  exit /b 1
)

set "APPDIR=%DESKTOP%\하루목록"
set "SHORTCUT=%DESKTOP%\하루목록.lnk"

echo  설치 위치: %APPDIR%
echo.

:: 폴더 만들고 파일 복사
if not exist "%APPDIR%" mkdir "%APPDIR%"
copy /Y "%SOURCE%\index.html" "%APPDIR%\index.html" >nul
copy /Y "%SOURCE%\style.css"  "%APPDIR%\style.css"  >nul
copy /Y "%SOURCE%\app.js"     "%APPDIR%\app.js"     >nul
copy /Y "%SOURCE%\제거하기.bat" "%APPDIR%\제거하기.bat" >nul 2>nul

:: 바탕화면에 바로가기 만들기
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$desktop = [Environment]::GetFolderPath('Desktop');" ^
  "$appDir = Join-Path $desktop '하루목록';" ^
  "$target = Join-Path $appDir 'index.html';" ^
  "$shortcutPath = Join-Path $desktop '하루목록.lnk';" ^
  "$w = New-Object -ComObject WScript.Shell;" ^
  "$s = $w.CreateShortcut($shortcutPath);" ^
  "$s.TargetPath = $target;" ^
  "$s.WorkingDirectory = $appDir;" ^
  "$s.WindowStyle = 1;" ^
  "$s.Description = '하루목록 - 할 일 관리';" ^
  "$s.Save();"

if errorlevel 1 (
  echo [오류] 바로가기 만들기에 실패했습니다.
  pause
  exit /b 1
)

echo  설치가 완료되었습니다!
echo.
echo  - 바탕화면 폴더: 하루목록
echo  - 바로가기: 하루목록
echo.
echo  바탕화면의 "하루목록" 아이콘을 더블클릭하면
echo  브라우저에서 앱이 실행됩니다.
echo.
pause
exit /b 0

:missing
echo [오류] index.html, style.css, app.js 파일이
echo        설치하기.bat 과 같은 폴더에 있어야 합니다.
echo.
pause
exit /b 1
