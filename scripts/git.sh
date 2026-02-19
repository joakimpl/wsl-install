#!/usr/bin/env bash
# Set up Git configuration
set -euo pipefail

GITCONFIG="$HOME/.gitconfig"

echo "==> Setting up Git configuration..."

# Get existing values as defaults
CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

# Prompt for name
read -rp "Git user name [$CURRENT_NAME]: " GIT_NAME
GIT_NAME="${GIT_NAME:-$CURRENT_NAME}"

# Prompt for email
read -rp "Git user email [$CURRENT_EMAIL]: " GIT_EMAIL
GIT_EMAIL="${GIT_EMAIL:-$CURRENT_EMAIL}"

if [[ -z "$GIT_NAME" || -z "$GIT_EMAIL" ]]; then
    echo "Error: Git name and email are required"
    exit 1
fi

# Backup existing .gitconfig if present
if [[ -f "$GITCONFIG" ]]; then
    cp "$GITCONFIG" "${GITCONFIG}.backup.$(date +%Y%m%d%H%M%S)"
    echo "  Backed up existing .gitconfig"
fi

cat > "$GITCONFIG" << EOF
[user]
	name = $GIT_NAME
	email = $GIT_EMAIL
[color]
	ui = true
[core]
	sshCommand = ssh.exe
EOF

echo "==> Git configuration written to $GITCONFIG"
