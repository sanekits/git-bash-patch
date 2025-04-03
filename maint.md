# Portable Make Installer for Git Bash on Windows

## Overview

This guide sets up a portable version of `make` for Git Bash on Windows using a standalone MinGW-based `make.exe` build (from EzWinPorts).

The `make` binary is distributed as a ZIP archive hosted on GitHub Pages, allowing for easy, scriptable installation on any Git Bash system.

---

## Goals

- Add `make` to Git Bash 
- Lightweight, portable ZIP-based distribution
- Easy installation via script

---

## 1. GitHub Repo Setup

Create a GitHub repo called:

```
sanekits/git-bash-patch
```

Clone it locally:

```bash
git clone https://github.com/sanekits/git-bash-patch.git
cd git-bash-patch
mkdir docs
```

Enable GitHub Pages:

- Go to **Settings > Pages**
- Set **Source** to `main` and folder to `/docs`
- Save; your zip will be hosted at:

```
https://sanekits.github.io/git-bash-patch/make-portable.zip
```

---

## 2. Build `make-portable.zip`

### Requirements:

- Download the standalone `make.exe` build:
  - From: https://sourceforge.net/projects/ezwinports/files/
  - Direct zip link (as of writing):
    ```
https://sourceforge.net/projects/ezwinports/files/make-4.3-without-guile-w32-bin.zip
```

### Steps:

1. Download and extract `make.exe` from the above zip.
2. Create a folder `make-portable` and move `make.exe` into it:

```bash
mkdir make-portable
cp /path/to/make.exe make-portable/
```

3. Zip it:

```bash
cd make-portable
zip ../docs/make-portable.zip *
```

4. Commit and push:

```bash
git add docs/make-portable.zip
git commit -m "Add portable make zip"
git push
```

---

## 3. Write the Installer Script

In the root of your repo, create `make-installer.sh`:

```bash
#!/usr/bin/env bash
set -ueo pipefail

# Check if we can write to /bin by creating a temporary file
if ! touch /bin/.test-write-permission 2>/dev/null; then
  echo "ERROR: You must run this script as Administrator to create /bin/make symlink."
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
curl -L "$ZIP_URL" -o "$TMPDIR/make.zip"

echo "Extracting..."
unzip "$TMPDIR/make.zip" -d "$TMPDIR/make"

echo "Installing to $TARGET..."
cp "$TMPDIR/make/make.exe" "$TARGET"

rm -rf "$TMPDIR"

echo "Creating symlink at /bin/make..."
mkdir -p /bin
ln -sf "$HOME/.local/bin/make" /bin/make

echo "Done. You may need to add \$HOME/.local/bin to your PATH. Test with: make --version"
```

Make it executable and commit:

```bash
chmod +x make-installer.sh
git add make-installer.sh
git commit -m "Add installer script"
git push
```

---

## 4. Install `make` Anywhere

To install on any Git Bash machine:

```bash
curl -LO https://raw.githubusercontent.com/sanekits/git-bash-patch/main/make-installer.sh
bash make-installer.sh
```

You now have a working `make` in Git Bash, with no runtime dependencies or special shell path assumptions.

---

## Bonus: Rebuilding the ZIP Later

If a newer version of `make.exe` is released by EzWinPorts or another trusted MinGW source, you can repeat Step 2 to rebuild the zip.

---

## Notes

- The EzWinPorts version of `make.exe` used here is a 32-bit executable. Despite the architecture, it works reliably in Git Bash and is currently the best lightweight option for this use case.


- This setup creates a symlink at `/bin/make` pointing to the user's `$HOME/.local/bin/make`, ensuring that `make` can invoke shell scripts that expect `/bin/bash`.
- It avoids modifying Makefiles or relying on MSYS2's complex shell path resolution.
- The included `make.exe` uses native Windows system calls and does not rely on `msys-2.0.dll`.
- The installer places `make` in `$HOME/.local/bin`, requiring no administrative privileges for normal usage, except for creating the symlink at `/bin/make`.

---

## License

Use and adapt freely. This is a minimalist helper for patching Git Bash — no warranties.

---

## Author

**Stabledog** – [https://github.com/Stabledog](https://github.com/Stabledog)

