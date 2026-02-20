#!/usr/bin/env bash
# Install/update Clever Cloud CLI
set -euo pipefail

echo "==> Installing/updating Clever Cloud CLI..."

# Ensure ~/.local/bin exists
mkdir -p ~/.local/bin

# Create temp directory for download
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract
curl -O https://clever-tools.clever-cloud.com/releases/latest/clever-tools-latest_linux.tar.gz
tar xzf clever-tools-latest_linux.tar.gz

# Install binary
cp clever-tools-latest_linux/clever ~/.local/bin/

# Cleanup
cd -
rm -rf "$TEMP_DIR"

echo "==> Clever Cloud CLI installed to ~/.local/bin/clever"
echo "    Make sure ~/.local/bin is in your PATH"
