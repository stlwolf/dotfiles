eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

export BASH_SILENCE_DEPRECATION_WARNING=1

. "/opt/homebrew/opt/asdf/libexec/asdf.sh"
. "/opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash"
