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
 }

