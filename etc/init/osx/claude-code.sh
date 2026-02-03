#!/bin/bash

# Claude Code installer
# https://docs.anthropic.com/en/docs/claude-code/getting-started

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

# Claude Code is installed to ~/.local/bin
CLAUDE_BIN="$HOME/.local/bin/claude"

if [ -x "$CLAUDE_BIN" ]; then
    e_done "claude-code: already installed"
    "$CLAUDE_BIN" --version
    exit
fi

e_arrow "Installing Claude Code..."

# Native installation (recommended by Anthropic)
curl -fsSL https://claude.ai/install.sh | bash

if [ -x "$CLAUDE_BIN" ]; then
    e_done "Claude Code installed successfully"
    "$CLAUDE_BIN" --version

    # PATH設定の案内
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        e_arrow "Note: Add ~/.local/bin to PATH in your shell config"
    fi
else
    e_error "Claude Code installation failed"
    exit 1
fi
