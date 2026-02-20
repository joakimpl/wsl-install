# WSL Ubuntu Dev Environment Setup

Modular bash scripts to set up a development environment in WSL Ubuntu.

## Quick Start

```bash
# Install everything
./install.sh

# Or install specific components
./install.sh --base          # Base packages only
./install.sh --mise          # mise + dev tools only
./install.sh --docker        # Docker only
./install.sh --clever        # Clever Cloud CLI only
./install.sh --base --mise   # Combine options
```

## What's Included

### Base (`scripts/base.sh`)
- Build essentials (gcc, make, etc.)
- Common utilities (curl, wget, git, jq, htop, tree, unzip)
- CA certificates and GPG tools
- Ruby/Rails build dependencies (libpq-dev, libssl-dev, libyaml-dev, etc.)
- PostgreSQL client tools (pg_restore) - server disabled to avoid port conflicts

### mise (`scripts/mise.sh`)
- [mise](https://mise.jdx.dev/) - polyglot runtime manager
- Configured tools (from `config/mise.toml`):
  - `gh` - GitHub CLI (latest)
  - `node` - Node.js (v20)
  - `ruby` - Ruby (latest)
  - `rust` - Rust (latest)
  - `terraform` - Terraform (latest)

### Docker (`scripts/docker.sh`)
- Docker Engine (CE)
- Docker Compose plugin
- Docker Buildx plugin
- Adds user to docker group

### Clever Cloud CLI (`scripts/clever-cli.sh`)
- Installs/updates the [Clever Cloud CLI](https://www.clever-cloud.com/doc/cli/) to `~/.local/bin/`
- Run again to update to the latest version

## Structure

```
wsl-config/
├── install.sh          # Main orchestrator script
├── config/
│   └── mise.toml       # mise tool configuration
└── scripts/
    ├── base.sh         # Base system packages
    ├── clever-cli.sh   # Clever Cloud CLI
    ├── docker.sh       # Docker installation
    ├── git.sh          # Git configuration
    ├── mise.sh         # mise + dev tools
    └── ssh-windows.sh  # Windows OpenSSH symlinks
```

## Customization

### Adding mise tools
Edit `config/mise.toml`:
```toml
[tools]
gh = "latest"
node = "20"
python = "3.12"    # Add this
go = "latest"      # Add this
```

### Adding new install scripts
1. Create a new script in `scripts/` (e.g., `scripts/mytools.sh`)
2. Add a flag and handler in `install.sh`

## Post-Install

After running the install script:
1. Restart your terminal or run `source ~/.bashrc`
2. If Docker was installed, log out and back in for group membership
