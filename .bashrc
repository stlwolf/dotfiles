PATH="$PATH":~/bin
export LANG=ja_JP.UTF-8
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth

shopt -u histappend   # .bash_history追記モードは不要なのでOFFに

function share_history {  # 以下の内容を関数として定義
   history -a  # .bash_historyに前回コマンドを1行追記
   history -c  # 端末ローカルの履歴を一旦消去
   history -r  # .bash_historyから履歴を読み込み直す
}
export PROMPT_COMMAND='share_history'  # 上記関数をプロンプト毎に自動実施

# Homebrew bash-completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
fi

if [ -f `brew --prefix`/etc/hub.bash_completion ]; then
        . `brew --prefix`/etc/hub.bash_completion
fi

NAME='HOME'
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
    PS1='\[\e[0;37m\]${NAME}\[\e[0;37m\][\t]\[\e[0;37m\]: \[\e[1;37m\]\w\n\[\e[1;33m\]h:\! j:\j\[\e[0;36m\]$(__git_ps1) \[\e[0;34m\]\$\[\e[m\]'
else
    PS1='\[\e[0;37m\]${NAME}\[\e[0;37m\][\t]\[\e[0;37m\]: \[\e[1;37m\]\w\n\[\e[1;33m\]h:\! j:\j \[\e[0;34m\]\$\[\e[m\]'
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

## os alias
alias ll='ls -la'
alias exa='exa -la'

# application alias
alias vi='vim'
alias py='python'
alias og='open_github'

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
tmux_automatically_attach_session

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

eval "$(hub alias -s)"

# ローカルファイルに分ける
if [ -e "${HOME}/.bashrc.local" ]; then
  source "${HOME}/.bashrc.local"
fi

eval "$(anyenv init -)"
export PATH="$HOME/.anyenv/bin:$PATH"

alias awsp="source /Users/eddy/work/repos/github.com/stlwolf/awsp/run.sh"
