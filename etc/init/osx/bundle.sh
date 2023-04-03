#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

# Check if the system is running on Apple Silicon (M1) or using Rosetta 2
if [ "$(uname -m)" = "arm64" ] || [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
    # M1 Mac
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel Mac
    eval "$(/usr/local/bin/brew shellenv)"
fi

if has "brew"; then
    brew tap Homebrew/bundle 2>/dev/null

    cd "$DOTPATH"/etc/init/assets/brew
    if [ ! -f Brewfile ]; then
        brew bundle dump
    fi

    brew bundle
else
    die "you should install brew"
fi
