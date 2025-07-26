# GitHub Actions Secrets Configuration

This document explains how to configure the secrets needed for automated publishing to browser extension stores.

## Required Secrets

### Chrome Web Store Publishing

1. Go to GitHub repository → Settings → Secrets and variables → Actions
2. Add the following secret:

**CHROME_STORE_KEYS**
```json
{
  "clientId": "your-chrome-web-store-client-id",
  "clientSecret": "your-chrome-web-store-client-secret",
  "refreshToken": "your-chrome-web-store-refresh-token",
  "extId": "your-chrome-extension-id"
}
```

To get these values:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Chrome Web Store API
4. Create OAuth 2.0 credentials
5. Use the Chrome Web Store API to get refresh token

### Firefox Add-ons Publishing

**FIREFOX_STORE_KEYS**
```json
{
  "apiKey": "your-firefox-api-key",
  "apiSecret": "your-firefox-api-secret",
  "extId": "your-firefox-extension-id"
}
```

To get these values:
1. Go to [Firefox Add-on Developer Hub](https://addons.mozilla.org/developers/)
2. Go to Tools → Manage API Keys
3. Generate new API credentials

## Setup Instructions

### 1. Chrome Web Store Setup

1. **Create Google Cloud Project**
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project

2. **Enable Chrome Web Store API**
   - In your project, go to APIs & Services → Library
   - Search for "Chrome Web Store API" and enable it

3. **Create OAuth 2.0 Credentials**
   - Go to APIs & Services → Credentials
   - Click "Create Credentials" → OAuth 2.0 Client ID
   - Choose "Desktop Application"
   - Download the credentials JSON

4. **Get Refresh Token**
   ```bash
   # Use the OAuth playground or implement OAuth flow
   # This is a one-time setup to get the refresh token
   ```

5. **Upload Extension Manually First**
   - Go to [Chrome Web Store Developer Dashboard](https://chrome.google.com/webstore/devconsole/)
   - Upload your extension manually to get the extension ID

### 2. Firefox Add-ons Setup

1. **Create Developer Account**
   - Sign up at [Firefox Add-on Developer Hub](https://addons.mozilla.org/developers/)

2. **Generate API Credentials**
   - Go to Tools → Manage API Keys
   - Click "Generate new API key"
   - Save the API key and secret

3. **Upload Extension Manually First**
   - Upload your extension manually to get the extension ID

### 3. Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following secrets:
   - `CHROME_STORE_KEYS`: Chrome Web Store configuration JSON
   - `FIREFOX_STORE_KEYS`: Firefox Add-ons configuration JSON

## Usage

### Creating a Release

1. **For stable releases (e.g., 1.0.0)**:
   - Go to Actions tab in your GitHub repository
   - Select "Create Release Tag" workflow
   - Click "Run workflow"
   - Enter version like `1.0.0`
   - This will automatically publish to both stores

2. **For pre-releases (e.g., 1.0.0-alpha.1)**:
   - Same process but use version like `1.0.0-alpha.1`
   - This will create a GitHub release but won't publish to stores

### Workflow Behavior

- **Stable versions** (1.0.0, 2.1.3): Published to both Chrome Web Store and Firefox Add-ons
- **Pre-release versions** (1.0.0-alpha.1, 1.0.0-beta.1, 1.0.0-rc.1): Only create GitHub releases
- All versions create downloadable ZIP files in the GitHub release

## Security Notes

- Never commit API keys or secrets to your repository
- Use GitHub Secrets to store sensitive information
- Regularly rotate your API keys
- Monitor the Actions logs for any security issues
