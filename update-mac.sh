#!/bin/bash
# Download and install the latest GitCopy release on macOS.
# Handles download, install to /Applications, and Gatekeeper fix in one step.

set -e

REPO="lisachidem/gitcopy-releases"
APP="/Applications/GitCopy.app"
TMP_DIR=$(mktemp -d)

echo "Fetching latest release info..."
RELEASE_JSON=$(curl -sf "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$RELEASE_JSON" | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"\(.*\)".*/\1/')
ZIP_URL=$(echo "$RELEASE_JSON" | grep '"browser_download_url"' | grep 'arm64-mac.zip"' | sed 's/.*"browser_download_url": *"\(.*\)".*/\1/')

if [ -z "$ZIP_URL" ]; then
  echo "Could not find mac download URL."
  echo "Download manually: https://github.com/$REPO/releases/latest"
  exit 1
fi

echo "Downloading GitCopy $VERSION..."
curl -L --progress-bar "$ZIP_URL" -o "$TMP_DIR/GitCopy.zip"

echo "Extracting..."
unzip -q "$TMP_DIR/GitCopy.zip" -d "$TMP_DIR"

echo "Installing to /Applications (may prompt for password)..."
if [ -d "$APP" ]; then
  sudo rm -rf "$APP"
fi
sudo cp -r "$TMP_DIR/GitCopy.app" /Applications/

echo "Fixing Gatekeeper..."
sudo xattr -cr "$APP"

rm -rf "$TMP_DIR"

echo ""
echo "GitCopy $VERSION installed. Open it from /Applications."
