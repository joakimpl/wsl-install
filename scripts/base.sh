#!/usr/bin/env bash
# Base system setup for WSL Ubuntu
set -euo pipefail

echo "==> Installing base system packages..."

# Update package lists
sudo apt-get update

# Essential build tools and utilities
sudo apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    zip \
    jq \
    htop \
    tree \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

# Ruby/Rails build dependencies (postgresql for pg_restore, libpq-dev for pg gem)
sudo apt-get install -y \
    postgresql \
    libpq-dev \
    rustc \
    libssl-dev \
    libyaml-dev \
    zlib1g-dev \
    libgmp-dev \
    libvips

# Disable PostgreSQL server to avoid port 5432 conflict with Docker
sudo systemctl stop postgresql || true
sudo systemctl disable postgresql || true

# Git configuration (optional - uncomment and customize)
# git config --global user.name "Your Name"
# git config --global user.email "your.email@example.com"
# git config --global init.defaultBranch main
# git config --global pull.rebase true

echo "==> Base system packages installed successfully!"
