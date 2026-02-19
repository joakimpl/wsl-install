#!/usr/bin/env bash
# mise installation and tool setup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/../config"

echo "==> Installing mise..."

# Install mise
curl https://mise.run | sh

# Add mise to shell (detect shell and configure)
SHELL_NAME=$(basename "$SHELL")

case "$SHELL_NAME" in
    bash)
        SHELL_RC="$HOME/.bashrc"
        MISE_INIT='eval "$(~/.local/bin/mise activate bash)"'
        ;;
    zsh)
        SHELL_RC="$HOME/.zshrc"
        MISE_INIT='eval "$(~/.local/bin/mise activate zsh)"'
        ;;
    *)
        echo "Warning: Unknown shell $SHELL_NAME, you may need to manually configure mise"
        SHELL_RC=""
        ;;
esac

if [[ -n "$SHELL_RC" ]] && ! grep -q "mise activate" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# mise" >> "$SHELL_RC"
    echo "$MISE_INIT" >> "$SHELL_RC"
    echo "==> Added mise to $SHELL_RC"
fi

# Make mise available in current script
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

# Copy mise config if it exists
if [[ -f "${CONFIG_DIR}/mise.toml" ]]; then
    mkdir -p "$HOME/.config/mise"
    cp "${CONFIG_DIR}/mise.toml" "$HOME/.config/mise/config.toml"
    echo "==> Copied mise config to ~/.config/mise/config.toml"
fi

# Install mise tools from config
echo "==> Installing mise tools..."
mise install

# Set tools as global
echo "==> Setting tools as global..."
mise use -g gh@latest
mise use -g rust@latest

echo "==> mise setup complete!"
echo "    Restart your shell or run: source $SHELL_RC"
