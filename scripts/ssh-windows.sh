#!/usr/bin/env bash
# Set up symlinks to Windows OpenSSH for SSH agent forwarding
set -euo pipefail

LOCAL_BIN="$HOME/.local/bin"
WIN_SSH="/mnt/c/Windows/System32/OpenSSH"

echo "==> Setting up Windows OpenSSH symlinks..."

# Create .local/bin if it doesn't exist
mkdir -p "$LOCAL_BIN"

# Create symlinks (remove existing if present)
for cmd in ssh ssh-add; do
    target="${WIN_SSH}/${cmd}.exe"
    link="${LOCAL_BIN}/${cmd}"
    
    if [[ ! -f "$target" ]]; then
        echo "Warning: $target not found, skipping"
        continue
    fi
    
    if [[ -L "$link" ]]; then
        rm "$link"
    elif [[ -e "$link" ]]; then
        echo "Warning: $link exists and is not a symlink, skipping"
        continue
    fi
    
    ln -s "$target" "$link"
    echo "  ✓ $link -> $target"
done

echo "==> Windows OpenSSH symlinks created!"
echo "    Make sure ~/.local/bin is in your PATH"
