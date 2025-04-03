#!/usr/bin/env bash
set -ueo pipefail
PS4='\033[0;33m+$?( $( set +u; [[ -z "$BASH_SOURCE" ]] || realpath "${BASH_SOURCE[0]}"):${LINENO} ):\033[0m ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Check if we can write to /bin by creating a temporary file
if ! touch /bin/.test-write-permission 2>/dev/null; then
  echo "ERROR: You must run this script as Administrator to create /bin/bash symlink."
  echo "Right-click Git Bash and choose 'Run as Administrator', then re-run this script."
  exit 1
else
  rm -f /bin/.test-write-permission
fi

# Portable make installer for Git Bash
ZIP_URL="https://sanekits.github.io/git-bash-patch/make-portable.zip"
TARGET="${HOME}/.local/bin"
TMPDIR=$(mktemp -d)

mkdir -p "$TARGET"

echo "Downloading make-portable.zip..."
curl -L "$ZIP_URL" -o "$TMPDIR/make.zip" || { echo "Download failed"; exit 1; }

echo "Extracting..."
unzip "$TMPDIR/make.zip" -d "$TMPDIR/make"

echo "Installing to $TARGET..."
cp "$TMPDIR/make/"* "$TARGET" || { echo "Install failed"; exit 1; }

rm -rf "$TMPDIR"

echo "Creating symlink at /bin ..."
mkdir -p /bin
ln -sf "$HOME/.local/bin/make.exe" /bin/make

echo "Done. You may need to add \$HOME/.local/bin to your PATH. Test with: exec bash; make --version"
