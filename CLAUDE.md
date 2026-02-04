# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

macOS personal dotfiles repository. Symlinks managed via Makefile.

See AGENTS.md for detailed directory structure and guidelines (Japanese).

## Quick Reference

```bash
make deploy     # Create symlinks to home directory
make lint       # Run shellcheck on all scripts
make validate   # Check symlink integrity
make list       # Show files that will be deployed
make init       # Initialize environment
make clean      # Remove symlinks
```

## Workflow

After making changes:
1. `make lint` - **Must pass before committing**
2. `make validate` - Check symlink integrity
3. Test affected functionality manually

## Language

Japanese responses are acceptable.

## Symlink Structure

- Root dotfiles (`.bashrc`, `.vimrc`, etc.) → `~/`
- `bin/*` → `~/bin/` (added to PATH)
- `.config/*` → `~/.config/` (files linked individually)

## Coding Standards

### Shell Scripts

- Shebang: `#!/usr/bin/env bash`
- Error handling: `set -euo pipefail` (not in `.bashrc`/`.bash_profile`)
- Always quote variables: `"$var"`
- Use `[[ ]]` for conditionals

### Lua (`.wezterm.lua`, `.hammerspoon/*.lua`)

- Use `local` for all variables
- Explicit `require` for modules

## Gotchas

- **IMPORTANT**: Never modify AI IDE detection patterns in `.bashrc` without preserving existing ones
- `.config` directory itself is excluded from deployment; only its contents are linked individually
- Makefile excludes: `.idea`, `.DS_Store`, `.git`, `.gitmodules`, `.gitignore`

## Adding New Makefile Targets

1. Add to `.PHONY` declaration
2. Add description to `help` target
3. Use lowercase with hyphens for naming
