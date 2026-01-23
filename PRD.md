# gamctx - GAM Configuration Context Switcher

## Overview

A simple bash script to manage multiple GAM (Google Apps Manager) configuration directories by managing a symlink at `~/.gam`.

## How It Works

GAM uses `~/.gam/` for its configuration. This tool manages multiple configurations by:
1. Storing configs in `~/.gam-configs/<name>/`
2. Making `~/.gam` a symlink pointing to the active config

## Directory Structure

```
~/.gam-configs/
├── default/
│   ├── client_secrets.json
│   ├── gam.cfg
│   ├── oauth2.txt
│   └── ...
├── work/
│   └── ...
└── personal/
    └── ...
~/.gam -> ~/.gam-configs/default/  (symlink)
```

## Commands

### `gamctx init [name]`
Adopt an existing `~/.gam` setup into the managed structure.

- `name` defaults to `default` if not provided
- Logic:
  - If `~/.gam` does not exist: create `~/.gam-configs/<name>/`, create symlink
  - If `~/.gam` is a regular directory: move to `~/.gam-configs/<name>/`, create symlink
  - If `~/.gam` is a symlink pointing into `~/.gam-configs/`: print "already initialized", exit 0
  - If `~/.gam` is a symlink pointing elsewhere: print error with current target, exit 1
- Create `~/.gam-configs/` if it doesn't exist

### `gamctx add <name>`
Create a new empty configuration directory.

- Required: `name` argument
- Fail if `~/.gam-configs/<name>/` already exists
- Create `~/.gam-configs/<name>/`
- Print instructions: "Run `gam select` to authenticate and set up this configuration"

### `gamctx use [name]`
Switch to a different configuration.

- If `name` provided: switch directly to that config
- If `name` not provided: show interactive menu using bash `select` builtin
- Fail if `~/.gam-configs/<name>/` doesn't exist
- Update symlink: `ln -sfn ~/.gam-configs/<name> ~/.gam`
- Print confirmation: "Switched to <name>"

### `gamctx list`
List all available configurations.

- List all directories in `~/.gam-configs/`
- Mark the currently active one (what `~/.gam` points to) with an asterisk or arrow
- Example output:
  ```
    default
  * work
    personal
  ```

### `gamctx current`
Print the name of the currently active configuration.

- Read the symlink target of `~/.gam`
- Extract and print just the config name
- If `~/.gam` is not a symlink or doesn't point into `~/.gam-configs/`, print error and exit 1

### `gamctx move <old-name> <new-name>`
Move/rename an existing configuration.

- Both arguments required
- Validate both old and new names
- Fail if old config doesn't exist
- Fail if new name already exists
- Move: `mv ~/.gam-configs/<old> ~/.gam-configs/<new>`
- If moved config is currently active, update symlink to point to new name
- Print: "Moved <old> → <new>"

### `gamctx copy <source> <dest>`
Copy an existing configuration.

- Both arguments required
- Validate both source and dest names
- Fail if source doesn't exist
- Fail if dest already exists
- Copy: `cp -r ~/.gam-configs/<source> ~/.gam-configs/<dest>`
- Does not affect currently active config
- Print: "Copied <source> → <dest>"

### `gamctx` (no arguments)
Same as `gamctx use` with no arguments - show interactive selector.

## Name Validation

Config names must be validated on `init`, `add`, and `use` commands.

**Rules:**
- Alphanumeric, hyphens, and underscores only: `^[a-zA-Z0-9_-]+$`
- Must not be empty
- Must not start with a hyphen (to avoid conflicts with flags)
- Must not be `.` or `..`
- Maximum length: 64 characters

**Error messages:**
```bash
$ gamctx add "my config"
Error: Invalid name 'my config'. Names may only contain letters, numbers, hyphens, and underscores.

$ gamctx add ../../../etc
Error: Invalid name '../../../etc'. Names may only contain letters, numbers, hyphens, and underscores.

$ gamctx add ""
Error: Name cannot be empty.

$ gamctx add -foo
Error: Invalid name '-foo'. Names may not start with a hyphen.
```

## Requirements

- Pure bash (no external dependencies beyond coreutils)
- POSIX-compatible where possible, bash-specific features allowed where needed (e.g., `select`)
- Single file script
- Executable, with shebang `#!/usr/bin/env bash`
- Use `set -euo pipefail` for safety
- Validate all inputs, fail gracefully with helpful error messages
- Use `$HOME` instead of `~` in the script for reliability

## Error Handling

- All error messages should go to stderr
- Exit codes: 0 for success, 1 for errors
- Check that `~/.gam-configs/` exists before `list`, `use`, `current` commands (suggest running `init` first)

## Installation

The script should be a single file that users can place anywhere in their `$PATH`.

## Example Session

```bash
# First time setup - adopt existing config
$ gamctx init
Moved ~/.gam to ~/.gam-configs/default/
Switched to default

# Add another config
$ gamctx add work
Created ~/.gam-configs/work/
Run 'gam select' to authenticate and set up this configuration

# Switch to it
$ gamctx use work
Switched to work

# Set up GAM for this workspace
$ gam select
# ... GAM authentication flow ...

# List configs
$ gamctx list
  default
* work

# Interactive switch
$ gamctx
1) default
2) work
#? 1
Switched to default

# Check current
$ gamctx current
default
```
