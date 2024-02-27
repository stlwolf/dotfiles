#!/bin/bash

# ディレクトリパスが指定されていない場合、カレントディレクトリを使用
if [ -z "$1" ]; then
  target_directory="."
else
  target_directory="$1"
fi

cd "$target_directory" || exit

# スクリプトファイル名を取得し、リネーム対象から除外
script_name=$(basename "$0")

# リネーム対象のファイル数をカウント（スクリプトファイル除外）
total_files=$(find . -maxdepth 1 -type f ! -name "$script_name" | wc -l | xargs)

# ファイル数の桁数を計算してパディング長を決定
padding_length=$(echo $total_files | awk '{print length($0)}')

# ファイルを変更日時の昇順で並べ、連番でリネーム
counter=1
find . -maxdepth 1 -type f ! -name "$script_name" -print0 | xargs -0 stat -f "%m %N" | sort -n | cut -d' ' -f2- | while IFS= read -r filename; do
  new_name=$(printf "%0*d" $padding_length $counter)
  extension="${filename##*.}"
  # 拡張子が存在する場合としない場合で処理を分ける
  if [ -n "$extension" ] && [ "$filename" != "$extension" ]; then
    mv "$filename" "${new_name}.${extension}"
  else
    mv "$filename" "$new_name"
  fi
  ((counter++))
done

echo "Renaming completed."

