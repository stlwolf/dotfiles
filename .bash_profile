eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

export BASH_SILENCE_DEPRECATION_WARNING=1
