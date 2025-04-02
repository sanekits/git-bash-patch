#!/bin/bash
set -ueo pipefail

# Portable make installer for Git Bash
ZIP_URL="https://sanekits.github.io/git-bash-patch/make-portable.zip"
TARGET="${HOME}/.local/bin"
TMPDIR=$(mktemp -d)

echo "Downloading make-portable.zip..."
curl -L "$ZIP_URL" -o "$TMPDIR/make.zip" || { echo "Download failed"; exit 1; }

echo "Extracting..."
unzip "$TMPDIR/make.zip" -d "$TMPDIR/make"

echo "Installing to $TARGET..."
cp "$TMPDIR/make/"* "$TARGET" || { echo "Install failed"; exit 1; }

echo "Cleaning up..."
rm -rf "$TMPDIR"

echo "Done: make installed to $TARGET"
