# ============================================================================
# Widgetbook Local Build & Serve Test Script (RED STEP - SHOULD FAIL)
# ============================================================================
# This script tests the local Widgetbook development workflow.
# EXPECTED BEHAVIOR: This test should currently work with --base-href / 
# but we need to validate the problem and create proper script structure.
# 
# Test Objective: Verify that Widgetbook can be built for local development 
#                 and served without asset 404s at http://localhost:8080/
#
# Author: Hybrid_AI_OS (TDD Task t001)
# Created: 2025-06-25
# Plan: plan_widgetbook_dual_build
# ============================================================================

Write-Host "[TEST] Starting Widgetbook Local Build Test..." -ForegroundColor Cyan
Write-Host "[TEST] Current directory: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# Navigate to mobile directory
$originalLocation = Get-Location
try {
    Set-Location "mobile"
    Write-Host "[TEST] Changed to mobile directory: $(Get-Location)" -ForegroundColor Gray
} catch {
    Write-Host "[FAIL] Could not navigate to mobile directory" -ForegroundColor Red
    exit 1
}

# Check Flutter installation
Write-Host "[TEST] Checking for Flutter installation..." -ForegroundColor Gray
try {
    $flutterVersion = flutter --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter command failed"
    }
    Write-Host "[PASS] Flutter found" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Flutter not found in PATH" -ForegroundColor Red
    Set-Location $originalLocation
    exit 1
}

# Check for Widgetbook entry point
Write-Host "[TEST] Checking for Widgetbook entry point..." -ForegroundColor Gray
if (-not (Test-Path "lib\widgetbook\widgetbook.dart")) {
    Write-Host "[FAIL] Widgetbook entry point not found at lib\widgetbook\widgetbook.dart" -ForegroundColor Red
    Set-Location $originalLocation
    exit 1
}
Write-Host "[PASS] Widgetbook entry point found" -ForegroundColor Green

Write-Host "[TEST] Attempting to build Widgetbook for local development..." -ForegroundColor Gray
Write-Host "[TEST] Command: flutter build web -t lib/widgetbook/widgetbook.dart --base-href / --output build/widgetbook" -ForegroundColor Yellow

# Clean previous build
Write-Host "[TEST] Cleaning previous build..." -ForegroundColor Gray
flutter clean | Out-Null

# Get dependencies
Write-Host "[TEST] Getting Flutter dependencies..." -ForegroundColor Gray
flutter pub get
if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Flutter pub get failed" -ForegroundColor Red
    Set-Location $originalLocation
    exit 1
}

# Build with local base-href
Write-Host "[TEST] Building Widgetbook..." -ForegroundColor Gray
flutter build web -t lib/widgetbook/widgetbook.dart --base-href / --output build/widgetbook
if ($LASTEXITCODE -ne 0) {
    Write-Host "[FAIL] Flutter build failed" -ForegroundColor Red
    Write-Host "[INFO] Build failure indicates configuration issues" -ForegroundColor Yellow
    Set-Location $originalLocation
    exit 1
}

# Check if build output exists
if (-not (Test-Path "build\widgetbook\index.html")) {
    Write-Host "[FAIL] Build output missing - index.html not found in build/widgetbook/" -ForegroundColor Red
    Write-Host "[INFO] This failure indicates the build process needs fixing" -ForegroundColor Yellow
    Set-Location $originalLocation
    exit 1
}

Write-Host "[PASS] Build completed successfully" -ForegroundColor Green
Write-Host "[TEST] Checking build output structure..." -ForegroundColor Gray

# List build artifacts
$buildFiles = Get-ChildItem "build\widgetbook\" -Name
Write-Host "[INFO] Build artifacts: $($buildFiles -join ', ')" -ForegroundColor Gray

Write-Host ""
Write-Host "[TEST] Starting local server test..." -ForegroundColor Cyan
Write-Host "[TEST] This will test if assets load correctly at http://localhost:8080/" -ForegroundColor Gray

# Change to build directory
Set-Location "build\widgetbook"

# Start server and test
Write-Host "[TEST] Starting Python HTTP server on port 8080..." -ForegroundColor Gray
$serverJob = Start-Job -ScriptBlock { python -m http.server 8080 }

# Wait for server to start
Start-Sleep -Seconds 3

$testResult = "PASS"

try {
    Write-Host "[TEST] Testing asset availability..." -ForegroundColor Gray
    
    # Test main page
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/" -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "[PASS] Main page (/) returns 200 OK" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] Main page (/) returned status $($response.StatusCode)" -ForegroundColor Red
            $testResult = "FAIL"
        }
    } catch {
        Write-Host "[FAIL] Main page (/) failed to load: $($_.Exception.Message)" -ForegroundColor Red
        $testResult = "FAIL"
    }
    
    # Test critical assets
    $criticalAssets = @("flutter_bootstrap.js", "main.dart.js", "flutter_service_worker.js")
    foreach ($asset in $criticalAssets) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/$asset" -UseBasicParsing -TimeoutSec 5
            if ($response.StatusCode -eq 200) {
                Write-Host "[PASS] $asset loads successfully" -ForegroundColor Green
            } else {
                Write-Host "[FAIL] $asset returned status $($response.StatusCode)" -ForegroundColor Red
                $testResult = "FAIL"
            }
        } catch {
            Write-Host "[FAIL] $asset returns 404 or failed to load" -ForegroundColor Red
            $testResult = "FAIL"
        }
    }
    
} finally {
    # Clean up server
    Write-Host "[TEST] Stopping server..." -ForegroundColor Gray
    Stop-Job $serverJob -Force
    Remove-Job $serverJob -Force
}

# Return to original location
Set-Location $originalLocation

Write-Host ""
Write-Host "============================================================================" -ForegroundColor Cyan
if ($testResult -eq "FAIL") {
    Write-Host "[RESULT] TEST FAILED - Local Widgetbook workflow has asset loading issues" -ForegroundColor Red
    Write-Host "[INFO] This demonstrates the problem that needs to be solved" -ForegroundColor Yellow
    Write-Host "[NEXT] Implement task t002 to create proper local build scripts" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "[RESULT] TEST PASSED - Local Widgetbook workflow works correctly" -ForegroundColor Green
    Write-Host "[INFO] Local build with --base-href / works as expected" -ForegroundColor Yellow
    Write-Host "[NEXT] Proceed to implement organized script structure in t002" -ForegroundColor Yellow
    exit 0
} 