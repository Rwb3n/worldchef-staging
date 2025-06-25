@echo off
REM WorldChef Widgetbook Manual Deployment Script for Windows
REM Use this script if GitHub Actions deployment is not working

echo 🚀 Starting WorldChef Widgetbook deployment...

REM Navigate to mobile directory
cd mobile

echo 📦 Building Widgetbook for GitHub Pages...
flutter build web -t lib/widgetbook/widgetbook.dart --base-href /worldchef/ --output build/widgetbook

echo 📋 Copying build files to docs directory...
REM Create docs directory if it doesn't exist
if not exist "..\docs" mkdir "..\docs"

REM Remove old files
del /q "..\docs\*.*" 2>nul
for /d %%x in ("..\docs\*") do rd /s /q "%%x" 2>nul

REM Copy new build files
xcopy "build\widgetbook\*" "..\docs\" /s /e /y

echo 📝 Creating .nojekyll file...
REM Create .nojekyll to prevent Jekyll processing
echo. > "..\docs\.nojekyll"

echo ✅ Build complete! Files ready in docs/ directory.
echo.
echo Next steps:
echo 1. git add docs/
echo 2. git commit -m "Deploy Widgetbook to GitHub Pages"
echo 3. git push origin main
echo 4. Configure GitHub Pages to serve from docs/ directory
echo.
echo The Widgetbook will be available at: https://rwb3n.github.io/worldchef/

pause 