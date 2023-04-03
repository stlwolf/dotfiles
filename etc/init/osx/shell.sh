#!/bin/bash

trap 'echo Error: $0: stopped; exit 1' ERR INT
set -eu

. "$DOTPATH"/etc/lib/vital.sh

is_osx || die "osx only"

if [ "$(uname -m)" = "arm64" ] || [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
    # M1 Mac
    sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
    chsh -s /opt/homebrew/bin/brew
else
    # Intel Mac
    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
    chsh -s /usr/local/bin/bash
fi

