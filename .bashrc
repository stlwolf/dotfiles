PATH="$PATH":~/bin
export PATH="$HOME/.local/bin:$PATH"
export LANG=ja_JP.UTF-8
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth

shopt -u histappend   # .bash_history追記モードは不要なのでOFFに

# AI IDE検出関数
# Windsurf, VSCode, Cursor, Claude Codeなどの統合ターミナルかどうかを判定
is_ai_ide() {
    # Windsurfの検出（VSCODE_PIDとCodeiumの組み合わせ）
    [[ -n "$VSCODE_PID" && -n "$CODEIUM_EDITOR_APP_ROOT" ]] && return 0
    
    # VSCode/Cursor系の統合ターミナル検出
    [[ "$TERM_PROGRAM" == "vscode" ]] && return 0
    
    # その他のAI IDE固有の環境変数（必要に応じて追加）
    [[ -n "$CURSOR_PID" ]] && return 0
    [[ -n "$CLAUDE_CODE" ]] && return 0
    
    return 1
}

# Homebrew環境変数設定
# AI IDE環境では /bin/ps の実行が制限されているため、直接設定
if is_ai_ide; then
    # brew shellenvの出力を直接設定（/bin/psを使わない）
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
else
    # 通常のターミナルでは brew shellenv を実行
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

function share_history {  # 以下の内容を関数として定義
   history -a  # .bash_historyに前回コマンドを1行追記
   history -c  # 端末ローカルの履歴を一旦消去
   history -r  # .bash_historyから履歴を読み込み直す
}
export PROMPT_COMMAND='share_history'  # 上記関数をプロンプト毎に自動実施

# Homebrew bash-completion
# AIツールからの実行時はスキップ（遅延を防ぐ）
if ! is_ai_ide; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
    fi

    if [ -f `brew --prefix`/etc/hub.bash_completion ]; then
            . `brew --prefix`/etc/hub.bash_completion
    fi
fi

NAME='HOME'
# __git_ps1が実際に利用可能かどうかで判断（ファイルの存在ではなく関数の存在で判断）
if type -t __git_ps1 &>/dev/null; then
    PS1='\[\e[0;37m\]${NAME}\[\e[0;37m\][\t]\[\e[0;37m\]: \[\e[1;37m\]\w\n\[\e[0;36m\]$(__git_ps1) \[\e[0;34m\]\$\[\e[m\]'
else
    PS1='\[\e[0;37m\]${NAME}\[\e[0;37m\][\t]\[\e[0;37m\]: \[\e[1;37m\]\w\n\[\e[0;34m\]\$\[\e[m\]'
fi

# View aws profile
aws_prof() {
  local profile="${AWS_PROFILE:-default}"

  echo -e "\033[1;34maws:(\033[1;33m${profile}\033[1;34m)\033[0m"
}
remove_last_dollar() {
  local ps1_value="$1"
  local ps1_without_dollar="${ps1_value%\\\$*}"
  echo "$ps1_without_dollar"
}
PS1="$(remove_last_dollar "$PS1")$(aws_prof) \$ "

# OSC 133 エスケープシーケンス設定 - disabled in TMUX to prevent character corruption
# AIツールからの実行時は無効化
if [[ -z "$TMUX" && $- == *i* ]] && ! is_ai_ide; then
    _prompt_executing=""
    function __prompt_precmd() {
        local ret="$?"
        if [ "$_prompt_executing" != "0" ]; then
          _PROMPT_SAVE_PS1="$PS1"
          _PROMPT_SAVE_PS2="$PS2"
          PS1=$'\e]133;P;k=i\a'$PS1$'\e]133;B\a\e]122;> \a'
          PS2=$'\e]133;P;k=s\a'$PS2$'\e]133;B\a'
        fi
        if [ "$_prompt_executing" != "" ]; then
           printf "\033]133;D;%s;aid=%s\007" "$ret" "$$"
        fi
        printf "\033]133;A;cl=m;aid=%s\007" "$$"
        _prompt_executing=0
    }
    function __prompt_preexec() {
        PS1="$_PROMPT_SAVE_PS1"
        PS2="$_PROMPT_SAVE_PS2"
        printf "\033]133;C;\007"
        _prompt_executing=1
    }

    trap '__prompt_precmd' DEBUG
    PROMPT_COMMAND="__prompt_preexec"
fi

#### peco commands
## find 使って peco る
alias fvi='vi `find . | peco`'

## git リポジトリに登録されているファイルから peco る
function pvim {
    git ls-files | peco | xargs sh -c 'vim "$0" < /dev/tty'
}
alias gvi='pvim'

## peco を bash インクリメンタルサーチとして使う
## http://qiita.com/fortkle/items/52c1077a7963cb01c596
## の改良版
## http://qiita.com/comutt/items/f54e755f22508a6c7d78
if [[ $- == *i* ]]; then
    peco-select-history() {
        declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
        READLINE_LINE="$l"
        READLINE_POINT=${#l}
    }
    bind -x '"\C-r": peco-select-history'

    peco-branch-name() {
        declare l=$(git branch --sort=-authordate | grep -v -e '->' | perl -pe 's/\*//g' | perl -pe 's/^\h+//g' | perl -pe 's#^remotes/origin/###' | perl -nle 'print if !$c{$_}++' | peco)
        READLINE_LINE="$READLINE_LINE$l"
        READLINE_POINT=${#l}
    }
    bind -x '"\C-f": peco-branch-name'
fi

# リモートブランチの git checkout を peco で簡単にする
# https://qiita.com/ymm1x/items/a735e82244a877ac4d23
gcop() {
  git branch --sort=-authordate |
      grep -v -e '->' -e '*' |
      perl -pe 's/^\h+//g' |
      perl -pe 's#^remotes/origin/###' |
      perl -nle 'print if !$c{$_}++' |
      peco |
      xargs git checkout
}
alias gcp=gcop

# merge済みのブランチ削除
alias gitbd="git branch --merged | grep -vE '^\*|main$|master$|develop$' | xargs -I % git branch -d %"

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fzfでdockerコンテナに入る
# ref: https://momozo.tech/2021/03/10/fzf%E3%81%A7zsh%E3%82%BF%E3%83%BC%E3%83%9F%E3%83%8A%E3%83%AB%E4%BD%9C%E6%A5%AD%E3%82%92%E5%8A%B9%E7%8E%87%E5%8C%96/
fdcnte() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && docker exec -it "$cid" /bin/bash
}
alias fzfc=fdcnte

# fd - cd to selected directory
# https://qiita.com/kamykn/items/aa9920f07487559c0c7e
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
alias fcd=fcd

## os alias
alias cat='bat'
alias ls='eza'
alias eza='eza -la'
alias ll='eza -la'

# application alias
alias vi='vim'
alias py='python'
alias og='open_github'
alias awsp="source /Users/eddy/work/repos/github.com/stlwolf/awsp/run.sh"

# ghq alias
alias ghh='cd $(ghq root)/$(ghq list | peco)'
alias grh='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'

# git alias
alias gpm='git pull origin master'
alias gb='git branch'
alias gc='git checkout'
alias gf='git diff'
alias gs='git status'

# https://dev.classmethod.jp/articles/aws-cli-switch-role-script/
alias scr='source ~/bin/scr'

# ターミナルマルチプレクサ tmux をカスタマイズする
# http://qiita.com/b4b4r07/items/01359e8a3066d1c37edc
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]}Gott ist todt! Gott bleibt todt!${reset_color}"
            echo "${fg_bold[red]}Und wir haben ihn getödtet!${reset_color}"
            echo "${fg_bold[red]}Wie trösten wir uns, die Mörder aller Mörder?${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            if is_osx && is_exists 'reattach-to-user-namespace'; then
                # on OS X force tmux's default command
                # to spawn a shell in the user's namespace
                tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            else
                tmux new-session && echo "tmux created new session"
            fi
        fi
    fi
}
# AIツール（Windsurf等）からのコマンド実行時はtmux自動起動をスキップ
if [[ $- == *i* ]] && ! is_ai_ide; then
    tmux_automatically_attach_session
fi

# tmuxのウィンドウ名をsshで繋いでるときは接続先ホストにする
# http://qiita.com/shrkw/items/167be53796d4507c736b
function tmux_ssh() {
  if [[ -n $(printenv TMUX) ]]
  then
    local window_name=$(tmux display -p '#{window_name}')
    # tmux rename-window -- "$@[-1]" # zsh specified
    tmux rename-window -- "${!#}" # for bash
    command ssh $@
    tmux rename-window $window_name
  else
    command ssh $@
  fi
}
alias ssh=tmux_ssh

# starship
# AIツールからの実行時はスキップ（遅延を防ぐ）
if ! is_ai_ide; then
    eval "$(starship init bash)"
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
fi

# tool init
# AIツールからの実行時はスキップ（遅延を防ぐ）
if ! is_ai_ide; then
    eval "$(hub alias -s)"
    eval "$(zoxide init bash)"
fi

# ローカルファイルに分ける
if [ -e "${HOME}/.bashrc.local" ]; then
  source "${HOME}/.bashrc.local"
fi

export PATH="$PATH:/opt/homebrew/share/git-core/contrib/diff-highlight"

