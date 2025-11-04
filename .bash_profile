# .bashrcを読み込む（Homebrew環境変数設定を含む）
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi

export BASH_SILENCE_DEPRECATION_WARNING=1

#. "/opt/homebrew/opt/asdf/libexec/asdf.sh"
#. "/opt/homebrew/opt/asdf/etc/bash_completion.d/asdf.bash"

# --- asdf for Bash ---
# asdf のシムが先に解決されるように shims を先頭に追加
export PATH="${HOME}/.asdf/shims:${PATH}"
# Homebrew 版 asdf のバイナリも PATH に
export PATH="$(brew --prefix asdf)/bin:${PATH}"
# （オプション）bash 補完を有効にする場合
if [ -f "$(brew --prefix asdf)/etc/bash_completion.d/asdf" ]; then
  . "$(brew --prefix asdf)/etc/bash_completion.d/asdf"
fi

# Added by Windsurf
export PATH="/Users/eddy/.codeium/windsurf/bin:$PATH"

export PHP_CONFIGURE_OPTIONS="--with-iconv=/usr"

