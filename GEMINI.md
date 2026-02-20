# Gemini Context: Dotfiles Project

This project is a personal dotfiles repository designed to manage and synchronize development environments, specifically optimized for macOS and modern AI-enhanced workflows.

## Project Overview

*   **Purpose:** Centralized configuration for shell (Bash), editor (Vim), terminal multiplexer (Tmux), and macOS automation (Hammerspoon).
*   **Target OS:** macOS (Darwin).
*   **Key Integrations:**
    *   **Shell:** Bash with `starship` prompt, `zoxide` for navigation, and `fzf`/`peco` for interactive searching.
    *   **AI Tools:** Optimized for AI IDEs (Windsurf, Cursor, Claude Code) with specific shell environment detection (`is_ai_ide`).
    *   **Version Management:** `asdf` for Node.js, Go, Python, etc.
    *   **Package Management:** Homebrew (via `Brewfile`).

## Key Commands (Makefile)

The project uses a `Makefile` for management:

*   `make install`: Runs `update`, `deploy`, and `init` in sequence.
*   `make deploy`: Creates symlinks from the repository to the home directory (including `.config` subdirectories).
*   `make init`: Executes initialization scripts in `etc/init/`, including macOS system defaults and Homebrew setup.
*   `make update`: Fetches the latest changes and updates git submodules.
*   `make lint`: Runs `shellcheck` on all scripts in `bin/`, `etc/`, and shell config files.
*   `make validate`: Verifies the integrity of symlinks in the home directory.

## Directory Structure

*   `bin/`: Custom utility scripts (e.g., `git-cleanup-merged`, `claude-safe`, `battery`).
*   `.config/`: Tool-specific configurations (e.g., `starship/starship.toml`).
*   `etc/init/`: Initialization logic organized by OS. `init.sh` is the main entry point.
*   `etc/lib/`: Shared library scripts for initialization.
*   `.hammerspoon/`: Lua scripts for macOS window management and automation.
*   `.vim/rc/`: Vim plugin management using `dein.toml` and `dein_lazy.toml`.

## Development Conventions

*   **Shell Scripting:** Use `shellcheck` for validation. Prefer portable Bash practices.
*   **AI IDE Optimization:** The `.bashrc` contains an `is_ai_ide` function. Use this to skip heavy terminal UI initialization (like `starship` or `tmux` auto-attach) when running inside AI tool environments to ensure speed and compatibility.
*   **Local Overrides:** Use `~/.bashrc.local` for machine-specific configurations that should not be committed.
*   **Adding Tools:** New command-line tools should be added to `etc/init/osx/brew.sh` or the `Brewfile` if they are available via Homebrew.

## Usage in AI Workflows

When operating within this repository:
*   **Scripts:** Look in `bin/` for existing automations before creating new ones.
*   **Environment:** Be aware that the shell environment might be modified for AI tools to bypass certain interactive features.
*   **Deployment:** After modifying configuration files, they may need to be redeployed using `make deploy` if they are new or if symlinks were broken.
