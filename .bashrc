export LANG=ja_JP.UTF-8
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export HISTCONTROL=ignoreboth
export VAGRANT_DEFAULT_PROVIDER=parallels
 
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
 
NAME='HOME'
if [ -f ~/git-completion.bash ]; then
    PS1='\[\e[0;37m\]${NAME}\[\e[0;37m\][\t]\[\e[0;37m\]: \[\e[1;37m\]\w\n\[\e[1;33m\]h:\! j:\j\[\e[0;36m\]$(__git_ps1) \[\e[0;34m\]\$\[\e[m\] '
else
    PS1='\[\e[0;37m\]${NAME}\[\e[0;37m\][\t]\[\e[0;37m\]: \[\e[1;37m\]\w\n\[\e[1;33m\]h:\! j:\j \[\e[0;34m\]\$\[\e[m\] '
fi

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

## node.js
if [[ -s ~/.nvm/nvm.sh ]];
 then source ~/.nvm/nvm.sh
fi

### Virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    source /usr/local/bin/virtualenvwrapper.sh
fi

## alias
alias vi='vim'
alias py='python'
alias gl='git pull origin master'
alias ll='ls -la'

# ローカルファイルに分ける
if [ -e "${HOME}/.bashrc.local" ]; then
  source "${HOME}/.bashrc.local"
fi
