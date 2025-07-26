#!/bin/bash

# Release script for the extension
# Usage: ./scripts/release.sh <version>
# Example: ./scripts/release.sh 1.0.0
# Example: ./scripts/release.sh 1.0.0-alpha.1

set -e

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version is required"
    echo "Usage: $0 <version>"
    echo "Examples:"
    echo "  $0 1.0.0          # Stable release"
    echo "  $0 1.0.0-alpha.1  # Alpha release"
    echo "  $0 1.0.0-beta.1   # Beta release"
    echo "  $0 1.0.0-rc.1     # Release candidate"
    exit 1
fi

# Validate version format
if [[ ! $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z]+\.[0-9]+)?$ ]]; then
    echo "❌ Error: Invalid version format"
    echo "Valid formats: 1.0.0, 1.0.0-alpha.1, 1.0.0-beta.1, 1.0.0-rc.1"
    exit 1
fi

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Error: Must be on main branch to create a release"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Error: Working directory is not clean"
    echo "Please commit or stash your changes first"
    git status --porcelain
    exit 1
fi

# Check if tag already exists
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    echo "❌ Error: Tag v$VERSION already exists"
    exit 1
fi

echo "🔍 Validating project..."

# Install dependencies
echo "📦 Installing dependencies..."
pnpm install --frozen-lockfile

# Run type check
echo "🔍 Running type check..."
pnpm compile

# Run format check
echo "✨ Running format check..."
pnpm format --check

# Build extensions
echo "🏗️  Building Chrome extension..."
pnpm build

echo "🏗️  Building Firefox extension..."
pnpm build:firefox

# Create zip files
echo "📦 Creating zip files..."
pnpm zip
pnpm zip:firefox

echo "✅ All checks passed!"

# Update package.json version
echo "📝 Updating package.json version to $VERSION..."
npm version $VERSION --no-git-tag-version

# Commit version change
echo "💾 Committing version change..."
git add package.json
git commit -m "chore: bump version to $VERSION"

# Create and push tag
echo "🏷️  Creating tag v$VERSION..."
git tag "v$VERSION"

echo "🚀 Pushing changes and tag..."
git push origin main
git push origin "v$VERSION"

# Determine release type
if [[ $VERSION =~ -(alpha|beta|rc) ]]; then
    RELEASE_TYPE="pre-release"
    STORE_PUBLISH="No (pre-release)"
else
    RELEASE_TYPE="stable release"
    STORE_PUBLISH="Yes (automatic)"
fi

echo ""
echo "🎉 Release v$VERSION created successfully!"
echo ""
echo "📋 Release Summary:"
echo "  Version: $VERSION"
echo "  Type: $RELEASE_TYPE"
echo "  Store Publishing: $STORE_PUBLISH"
echo ""
echo "🔗 Next Steps:"
echo "  1. Monitor the GitHub Actions workflow in the Actions tab"
echo "  2. The workflow will automatically:"
echo "     - Build the extension for both browsers"
echo "     - Create a GitHub release with downloadable assets"
if [[ ! $VERSION =~ -(alpha|beta|rc) ]]; then
    echo "     - Publish to Chrome Web Store and Firefox Add-ons"
fi
echo ""
echo "📍 GitHub Release: https://github.com/chromium-style-qrcode/add-qrcode-generator-icon-back-to-address-bar/releases/tag/v$VERSION"
