#!/bin/bash
# Download and install the latest GitCopy release on macOS.
# Handles download, install to /Applications, and Gatekeeper fix in one step.

set -e

REPO="lisachidem/gitcopy-releases"
APP="/Applications/GitCopy.app"
TMP_DIR=$(mktemp -d)

echo "Fetching latest release info..."
RELEASE_JSON=$(curl -sf "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$RELEASE_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])")
ZIP_URL=$(echo "$RELEASE_JSON" | python3 -c "import sys,json; r=json.load(sys.stdin); print(next(a['browser_download_url'] for a in r['assets'] if a['name'].endswith('arm64-mac.zip')))")

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
