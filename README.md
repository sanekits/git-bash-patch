# Portable Make Installer for Git Bash on Windows

## Overview

This guide walks you through setting up a portable version of `make` for Git Bash on Windows 10/11. It avoids full MSYS2 installation, works with Unix-style paths, and is easy to maintain or replicate using GitHub Pages.

---

## Goals

- Add `make` to Git Bash (Unix-compatible)
- No path conflicts or global environment changes
- Scriptable, repeatable install process
- Lightweight ZIP-based distribution

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
  ```

[https://sanekits.github.io/git-bash-patch/make-portable.zip](https://sanekits.github.io/git-bash-patch/make-portable.zip)

````

---

## 2. Build `make-portable.zip`

### Requirements:
- MSYS2 installed in `C:\msys64` on a machine **not behind a corporate proxy or MITM firewall**, as the keyring setup may hang in such environments
- Git Bash or any Bash shell

### Steps:
1. Open MSYS2 and install `make`:
   ```bash
   pacman -Syu
   pacman -S make
````

2. In Git Bash, run the following script:

```bash
#!/bin/bash
set -ueo pipefail
mkdir -p make-portable
cp /c/msys64/usr/bin/make.exe make-portable/
cp /c/msys64/usr/bin/msys-2.0.dll make-portable/
cp /c/msys64/usr/bin/msys-iconv-2.dll make-portable/
cp /c/msys64/usr/bin/msys-intl-8.dll make-portable/
cd make-portable
zip ../docs/make-portable.zip *
```

3. Commit and push:

```bash
git add docs/make-portable.zip
git commit -m "Add portable make zip"
git push
```

---

## 3. Write the Installer Script

In the root of your repo, create `make-installer.sh`:

```bash
#!/bin/bash
set -ueo pipefail

# Portable make installer for Git Bash
ZIP_URL="https://sanekits.github.io/git-bash-patch/make-portable.zip"
TARGET="/usr/bin"
TMPDIR=$(mktemp -d)

echo "Downloading make-portable.zip..."
curl -L "$ZIP_URL" -o "$TMPDIR/make.zip" || { echo "Download failed"; exit 1; }

echo "Extracting..."
unzip "$TMPDIR/make.zip" -d "$TMPDIR/make"

echo "Installing to $TARGET..."
cp "$TMPDIR/make/"* "$TARGET" || { echo "Install failed"; exit 1; }

echo "Cleaning up..."
rm -rf "$TMPDIR"

echo "Done. Test with: make --version"
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

You now have a Unix-style `make` installed in Git Bash, with no extra packages or global changes.

---

## Bonus: Rebuilding the ZIP Later

If MSYS2 updates or you want to rebuild `make-portable.zip`, rerun the script in Step 2. You can automate this via CI/CD if desired.

---

## Notes

- `make.exe` and DLLs come from MSYS2 and use POSIX path conventions
- Safe to use in Git Bash scripts, Makefiles, etc.
- GitHub Pages allows serving `.zip` files directly

---

## License

Use and adapt freely. This is a minimalist helper for patching Git Bash — no warranties.

---

## Author

**Stabledog** – [https://github.com/Stabledog](https://github.com/Stabledog)

