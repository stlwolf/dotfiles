## dotfiles

#### Settings
- KeyRepeat
  - `defaults write -g KeyRepeat 1`

#### Shell

- Set brew path
```
  eval "$(/opt/homebrew/bin/brew shellenv)"
```

- Change brew bash

  - M1X ~
  ```
    sudo bash -c 'echo /opt/homebrew/bin/bash >> /etc/shells'
    chsh -s /opt/homebrew/bin/brew
  ```

  - IntelCPU
  ```
    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
    chsh -s /usr/local/bin/bash
  ```

#### Repository

- AWSP - AWS Profile Switcher
  - [fork/awsp](https://github.com/stlwolf/awsp)

#### Editor

- Vim
  - [dein](https://github.com/Shougo/dein.vim)

- Color scheme
  - [iceberg](https://github.com/cocopon/iceberg.vim)
  - [lucario](https://github.com/raphamorim/lucario)
  - [tender](https://github.com/jacoborus/tender.vim)
  - [gruvbox](https://github.com/morhetz/gruvbox)

- Fonts
  - [Rounded Mgen+](http://jikasei.me/font/rounded-mgenplus/)

#### Env

- [asdf](https://asdf-vm.com/)
```shell
  # plugin install example
  
  # nodejs
  asdf plugin-add nodejs
  asdf install nodejs latest
  asdf install nodejs 16.15.0
  asdf global nodejs 16.15.0

  # golang
  asdf plugin-add golang
  asdf install golang 1.18.1
  asdf global golang 1.18.1
  
  # python
  asdf plugin-add python
  asdf install python latest
  asdf global python 3.10.4
```

- [fzf](https://github.com/junegunn/fzf)
```shell
  # If it doesn't work, it needs to be initialized
  # https://github.com/junegunn/fzf?tab=readme-ov-file#using-homebrew
  $(brew --prefix)/opt/fzf/install
```

#### AI Development Tools

AI関連の開発ツールのインストール状況と運用メモ。

| ツール | インストール方法 | 管理場所 | 備考 |
|--------|------------------|----------|------|
| Cursor CLI | Homebrew | `Brewfile` | 公式サポートあり、quarantine属性削除処理込み |
| Claude Code | curl (公式推奨) | `etc/init/osx/claude-code.sh` | Anthropic公式のネイティブインストール |

- **Cursor CLI**: `brew install --cask cursor-cli`
  - Brewfile管理でバージョン管理・一括インストールのメリットを活用
  - `bundle.sh`でquarantine属性を自動削除

- **Claude Code**: `curl -fsSL https://claude.ai/install.sh | bash`
  - Homebrewでも入るが公式はcurl推奨
  - `make init`で他のセットアップと一緒にインストールされる

**PATH設定** (`.bashrc`):
```bash
PATH="$HOME/.local/bin:$PATH:$HOME/bin"
```
- `~/.local/bin`: Claude Code等のcurlインストーラーが使用
- `~/bin`: dotfilesのカスタムスクリプト

```bash
# 手動でClaude Codeをインストールする場合
DOTPATH=$(pwd) bash etc/init/osx/claude-code.sh

# インストール確認
cursor --version
claude --version
```

> **Note**: 暫定運用中。ツールの更新頻度や安定性を見て調整予定。

---

#### AI Tool Integration

- **Windsurf / VSCode / Cursor / その他AIツール**
  - `.bashrc`にはtmuxの自動起動設定が含まれていますが、AIツールからのコマンド実行時には自動的にスキップされます
  - 以下の環境変数でAI IDEを自動検出します：
    - `VSCODE_PID` + `CODEIUM_EDITOR_APP_ROOT` (Windsurf)
    - `TERM_PROGRAM=vscode` (VSCode/Cursor系)
    - `CURSOR_PID` (Cursor)
    - `CLAUDE_CODE` (Claude Code)
  - AI IDE検出時にスキップされる設定：
    - tmux自動起動
    - starship初期化
    - bash-completion読み込み
    - hub/zoxide初期化
    - OSC 133エスケープシーケンス
  - **通常のターミナル（iTerm2、WezTerm等）では全ての設定が有効**
  
- **環境変数を確認する場合**:
  ```bash
  # AIツールの統合ターミナルで実行
  env | grep -iE '(vscode|cursor|windsurf|claude|term_program)'
  ```
