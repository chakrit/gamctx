# gamctx

Context switcher for [GAM](https://github.com/GAM-team/GAM) configurations. Manage multiple Google Workspace accounts by switching `~/.gam` between config directories.

## Installation

```bash
# Download
curl -fsSL https://raw.githubusercontent.com/chakrit/gamctx/main/gamctx -o ~/.local/bin/gamctx
chmod +x ~/.local/bin/gamctx

# Or clone and symlink
git clone https://github.com/chakrit/gamctx.git
ln -s "$(pwd)/gamctx/gamctx" ~/.local/bin/gamctx
```

Ensure `~/.local/bin` is in your `$PATH`.

## Quick Start

```bash
# Adopt existing ~/.gam setup
gamctx init

# Add another config
gamctx add work
gam select  # authenticate the new config

# Switch between configs
gamctx use work
gamctx use default

# Or use interactive selector
gamctx
```

## Commands

| Command | Description |
|---------|-------------|
| `gamctx init [name]` | Adopt existing `~/.gam` (default name: `default`) |
| `gamctx add <name>` | Create new empty configuration |
| `gamctx use [name]` | Switch config (interactive if no name) |
| `gamctx list` | List all configurations |
| `gamctx current` | Print active configuration name |
| `gamctx` | Same as `gamctx use` (interactive) |

## How It Works

```
~/.gam-configs/
├── default/
├── work/
└── personal/
~/.gam -> ~/.gam-configs/default/  (symlink)
```

GAM reads from `~/.gam`. This tool stores multiple configs in `~/.gam-configs/` and manages a symlink at `~/.gam` pointing to the active one.

## Requirements

- Bash 4+
- Standard coreutils (ln, readlink, find, mkdir, mv)

## License

MIT
