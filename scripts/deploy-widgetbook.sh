#!/bin/bash

# WorldChef Widgetbook Manual Deployment Script
# Use this script if GitHub Actions deployment is not working

set -e

echo "🚀 Starting WorldChef Widgetbook deployment..."

# Navigate to mobile directory
cd mobile

echo "📦 Building Widgetbook for GitHub Pages..."
flutter build web \
  -t lib/widgetbook/widgetbook.dart \
  --base-href /worldchef/ \
  --output build/widgetbook

echo "📋 Copying build files to docs directory..."
# Create docs directory if it doesn't exist
mkdir -p ../docs

# Remove old files
rm -rf ../docs/*

# Copy new build files
cp -r build/widgetbook/* ../docs/

echo "📝 Creating .nojekyll file..."
# Create .nojekyll to prevent Jekyll processing
touch ../docs/.nojekyll

echo "✅ Build complete! Files ready in docs/ directory."
echo ""
echo "Next steps:"
echo "1. git add docs/"
echo "2. git commit -m 'Deploy Widgetbook to GitHub Pages'"
echo "3. git push origin main"
echo "4. Configure GitHub Pages to serve from docs/ directory"
echo ""
echo "The Widgetbook will be available at: https://rwb3n.github.io/worldchef/" 