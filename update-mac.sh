#!/bin/bash
# Install GitCopy to ~/Applications — no sudo needed.

set -e

REPO="lisachidem/gitcopy-releases"
APP_DIR="$HOME/Applications"
APP="$APP_DIR/GitCopy.app"
TMP_DIR=$(mktemp -d)

echo "Fetching latest release info..."
RELEASE_JSON=$(curl -sf "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$RELEASE_JSON" | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])")
ZIP_URL=$(echo "$RELEASE_JSON" | python3 -c "import sys,json; r=json.load(sys.stdin); print(next(a['browser_download_url'] for a in r['assets'] if a['name'].endswith('arm64-mac.zip')))")

echo "Downloading GitCopy $VERSION..."
curl -L --progress-bar "$ZIP_URL" -o "$TMP_DIR/GitCopy.zip"

echo "Extracting..."
unzip -q "$TMP_DIR/GitCopy.zip" -d "$TMP_DIR"

echo "Installing to ~/Applications..."
mkdir -p "$APP_DIR"
rm -rf "$APP"
cp -r "$TMP_DIR/GitCopy.app" "$APP_DIR/"

echo "Fixing Gatekeeper..."
xattr -cr "$APP"

rm -rf "$TMP_DIR"

echo "Done: $VERSION"
