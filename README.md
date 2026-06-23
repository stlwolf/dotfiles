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

#### AI Tools

- refarence
  - [docs/AI_TOOLS.md](docs/AI_TOOLS.md)
- Cursor CLI
  - `brew install --cask cursor-cli`
- Claude Code
  - `curl -fsSL https://claude.ai/install.sh | bash`
- OpenAI Codex CLI
  - `brew install codex`
  - `codex login` (GPT-5.3搭載)
- Gemini CLI
  - `brew install gemini-cli`
  - Google OAuth認証（60 req/min, 1,000 req/day 無料枠）
- Worktrunk（git worktree の並列作業用 CLI）
  - `brew install worktrunk`（このリポジトリでは `Brewfile` 管理）
  - シェル連携: `.bashrc` に `eval "$(wt config shell init bash)"` を記載済み（`wt switch` が `cd` 可能になる）
  - 詳細は [docs/AI_TOOLS.md](docs/AI_TOOLS.md#worktrunk)

#### WezTerm

- クリッカブル md ビューア連携（`.wezterm.lua`）
  - ターミナル出力中に現れる ai-development-hub の生成 doc(md) の絶対パスを **Cmd+Click** でクリッカブルにし、ブラウザに飛ばさず hub の `oe-view`（glow ペイン表示）を起動する
  - 仕組み: `hyperlink_rules` で対象パスを `oeview://` スキームのリンクにし、`open-uri` ハンドラがクリックを横取りして `oe-view --from-link <絶対パス>` を起動する（種別/allowlist/存在チェックは `oe-view` 側の責務）
  - 対象パス: `~/.../ai-development-hub/projects/<name>/docs/{plans,episodes,decisions,discussions}/**.md`（過剰マッチ防止のため厳格に限定）
  - 前提:
    - Cmd（SUPER）+ Click。`bypass_mouse_reporting_modifiers = 'SUPER'` により tmux の mouse mode 下でも WezTerm がクリックを処理できる
    - tmux 下でも regex ベースの `hyperlink_rules` は描画テキストに対して効くため `terminal-features` の `hyperlinks` 有効化は不要（明示的な OSC 8 リンクを使う場合のみ必要）
    - `oe-view` は hub 側の CLI。GUI 起動の WezTerm は PATH に `~/bin`/homebrew を含まないことがあるため絶対パスで呼ぶ
  - 設定スニペットの出どころ: [stlwolf/ai-development-hub#210](https://github.com/stlwolf/ai-development-hub/issues/210)
