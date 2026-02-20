#!/usr/bin/env bash
# Main WSL Ubuntu dev environment setup script
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  $1${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
}

print_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
}

print_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

# Usage information
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Sets up a WSL Ubuntu development environment.

Options:
    --all           Install everything (default if no options specified)
    --base          Install base system packages only
    --mise          Install mise and dev tools only
    --docker        Install Docker only
    --ssh           Set up Windows OpenSSH symlinks
    --git           Set up Git configuration
    --clever        Install Clever Cloud CLI
    -h, --help      Show this help message

Examples:
    $0              # Install everything
    $0 --all        # Install everything
    $0 --base       # Only base packages
    $0 --mise       # Only mise + dev tools
    $0 --docker     # Only Docker
    $0 --ssh        # Only Windows SSH symlinks
    $0 --git        # Only Git config
    $0 --base --mise # Base + mise (no Docker)
EOF
}

# Parse arguments
INSTALL_BASE=false
INSTALL_MISE=false
INSTALL_DOCKER=false
INSTALL_SSH=false
INSTALL_GIT=false
INSTALL_CLEVER=false
INSTALL_ALL=false

if [[ $# -eq 0 ]]; then
    INSTALL_ALL=true
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            INSTALL_ALL=true
            shift
            ;;
        --base)
            INSTALL_BASE=true
            shift
            ;;
        --mise)
            INSTALL_MISE=true
            shift
            ;;
        --docker)
            INSTALL_DOCKER=true
            shift
            ;;
        --ssh)
            INSTALL_SSH=true
            shift
            ;;
        --git)
            INSTALL_GIT=true
            shift
            ;;
        --clever)
            INSTALL_CLEVER=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

if [[ "$INSTALL_ALL" == true ]]; then
    INSTALL_BASE=true
    INSTALL_MISE=true
    INSTALL_DOCKER=true
    INSTALL_SSH=true
    INSTALL_GIT=true
    INSTALL_CLEVER=true
fi

# Run selected installers
if [[ "$INSTALL_BASE" == true ]]; then
    print_header "Installing Base Packages"
    bash "${SCRIPT_DIR}/scripts/base.sh"
fi

if [[ "$INSTALL_MISE" == true ]]; then
    print_header "Installing mise + Dev Tools"
    bash "${SCRIPT_DIR}/scripts/mise.sh"
fi

if [[ "$INSTALL_DOCKER" == true ]]; then
    print_header "Installing Docker"
    bash "${SCRIPT_DIR}/scripts/docker.sh"
fi

if [[ "$INSTALL_SSH" == true ]]; then
    print_header "Setting up Windows OpenSSH"
    bash "${SCRIPT_DIR}/scripts/ssh-windows.sh"
fi

if [[ "$INSTALL_GIT" == true ]]; then
    print_header "Setting up Git Configuration"
    bash "${SCRIPT_DIR}/scripts/git.sh"
fi

if [[ "$INSTALL_CLEVER" == true ]]; then
    print_header "Installing Clever Cloud CLI"
    bash "${SCRIPT_DIR}/scripts/clever-cli.sh"
fi

print_header "Setup Complete!"

echo "Installed components:"
[[ "$INSTALL_BASE" == true ]] && echo "  ✓ Base system packages"
[[ "$INSTALL_MISE" == true ]] && echo "  ✓ mise + dev tools (gh, node, ruby, rust, terraform)"
[[ "$INSTALL_DOCKER" == true ]] && echo "  ✓ Docker"
[[ "$INSTALL_SSH" == true ]] && echo "  ✓ Windows OpenSSH symlinks"
[[ "$INSTALL_GIT" == true ]] && echo "  ✓ Git configuration"
[[ "$INSTALL_CLEVER" == true ]] && echo "  ✓ Clever Cloud CLI"

echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: source ~/.bashrc)"
[[ "$INSTALL_DOCKER" == true ]] && echo "  2. Log out and back in for Docker group membership"
echo ""
echo "Happy coding! 🚀"
