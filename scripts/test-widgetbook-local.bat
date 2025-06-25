@echo off
REM ============================================================================
REM Widgetbook Local Build & Serve Test Script (RED STEP - SHOULD FAIL)
REM ============================================================================
REM This script tests the local Widgetbook development workflow.
REM EXPECTED BEHAVIOR: This test should FAIL because we don't have local build scripts yet.
REM 
REM Test Objective: Verify that Widgetbook can be built for local development 
REM                 and served without asset 404s at http://localhost:8080/
REM
REM Author: Hybrid_AI_OS (TDD Task t001)
REM Created: 2025-06-25
REM Plan: plan_widgetbook_dual_build
REM ============================================================================

echo [TEST] Starting Widgetbook Local Build Test...
echo [TEST] Current directory: %CD%
echo.

REM Navigate to mobile directory
cd /d "%~dp0..\mobile"
if errorlevel 1 (
    echo [FAIL] Could not navigate to mobile directory
    exit /b 1
)

echo [TEST] Checking for Flutter installation...
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [FAIL] Flutter not found in PATH
    exit /b 1
)

echo [TEST] Checking for Widgetbook entry point...
if not exist "lib\widgetbook\widgetbook.dart" (
    echo [FAIL] Widgetbook entry point not found at lib\widgetbook\widgetbook.dart
    exit /b 1
)

echo [TEST] Attempting to build Widgetbook for local development...
echo [TEST] Command: flutter build web -t lib/widgetbook/widgetbook.dart --base-href / --output build/widgetbook

REM Clean previous build
flutter clean >nul 2>&1

REM Get dependencies
echo [TEST] Getting Flutter dependencies...
flutter pub get
if errorlevel 1 (
    echo [FAIL] Flutter pub get failed
    exit /b 1
)

REM Try to build with local base-href (this should work but we don't have scripts yet)
flutter build web -t lib/widgetbook/widgetbook.dart --base-href / --output build/widgetbook
if errorlevel 1 (
    echo [FAIL] Flutter build failed - this might be expected if there are build issues
    echo [INFO] Build failure is acceptable for RED step - the main test is asset serving
)

REM Check if build output exists
if not exist "build\widgetbook\index.html" (
    echo [FAIL] Build output missing - index.html not found in build/widgetbook/
    echo [INFO] This failure indicates the build process needs fixing
    exit /b 1
)

echo [TEST] Build completed. Checking build output structure...
dir /b build\widgetbook\ | findstr /i "index.html flutter_bootstrap.js main.dart.js" >nul
if errorlevel 1 (
    echo [WARN] Some expected build artifacts may be missing
)

echo.
echo [TEST] Starting local server test...
echo [TEST] This will test if assets load correctly at http://localhost:8080/

REM Start server in background and test asset loading
cd build\widgetbook
echo [TEST] Starting Python HTTP server on port 8080...
echo [TEST] Server will run for 10 seconds to test asset loading

REM Start server in background
start /b python -m http.server 8080 >nul 2>&1

REM Wait for server to start
timeout /t 3 /nobreak >nul

echo [TEST] Testing asset availability...

REM Test if main page loads (should return 200)
curl -s -o nul -w "%%{http_code}" http://localhost:8080/ | findstr "200" >nul
if errorlevel 1 (
    echo [FAIL] Main page (/) returned non-200 status
    set TEST_RESULT=FAIL
) else (
    echo [PASS] Main page (/) returns 200 OK
)

REM Test critical assets that were 404ing in the original problem
curl -s -o nul -w "%%{http_code}" http://localhost:8080/flutter_bootstrap.js | findstr "200" >nul
if errorlevel 1 (
    echo [FAIL] flutter_bootstrap.js returns 404 - asset path issue confirmed
    set TEST_RESULT=FAIL
) else (
    echo [PASS] flutter_bootstrap.js loads successfully
)

curl -s -o nul -w "%%{http_code}" http://localhost:8080/main.dart.js | findstr "200" >nul
if errorlevel 1 (
    echo [FAIL] main.dart.js returns 404 - asset path issue confirmed  
    set TEST_RESULT=FAIL
) else (
    echo [PASS] main.dart.js loads successfully
)

REM Kill the server
taskkill /f /im python.exe >nul 2>&1

echo.
echo [TEST] ============================================================================
if "%TEST_RESULT%"=="FAIL" (
    echo [RESULT] TEST FAILED - Local Widgetbook workflow has asset loading issues
    echo [INFO] This is EXPECTED for TDD RED step - proves the problem exists
    echo [NEXT] Implement task t002 to create proper local build scripts
    exit /b 1
) else (
    echo [RESULT] TEST PASSED - Local Widgetbook workflow works correctly
    echo [INFO] This is UNEXPECTED for TDD RED step - investigate configuration
    exit /b 0
) 