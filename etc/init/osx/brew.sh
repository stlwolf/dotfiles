#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

if has "brew"; then
    exit
else
    # Check if the system is running on Apple Silicon (M1) or using Rosetta 2
    if [ "$(uname -m)" = "arm64" ] || [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        # M1 Mac
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        # Intel Mac
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

brew doctor
