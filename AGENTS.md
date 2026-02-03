# AGENTS.md - AIエージェント向けリポジトリガイド

このドキュメントはAIエージェント（Cursor, Claude, Windsurf等）がこのリポジトリを理解・操作するためのガイドです。

## リポジトリ概要

macOS向けの個人用dotfiles管理リポジトリ。シンボリックリンクでホームディレクトリに配置する構成。

## ディレクトリ構造

```
dotfiles/
├── AGENTS.md              # このファイル（AIエージェント向けガイド）
├── README.md              # 人間向けセットアップガイド
├── Makefile               # デプロイ・管理コマンド
├── .bashrc                # メインのシェル設定
├── .bash_profile          # ログインシェル設定
├── .gitconfig             # Git設定
├── .vimrc                 # Vim設定
├── .tmux.conf             # tmux設定
├── .wezterm.lua           # WezTermターミナル設定
├── .config/               # XDG設定ディレクトリ
│   └── starship/          # starshipプロンプト設定
├── .hammerspoon/          # macOS自動化（Lua）
├── .vim/                  # Vimプラグイン設定（dein）
├── bin/                   # カスタムスクリプト（PATHに追加される）
├── etc/
│   ├── install            # インストールスクリプト
│   ├── init/              # 初期化スクリプト
│   │   ├── init.sh        # メイン初期化
│   │   ├── osx/           # macOS固有の初期化
│   │   └── assets/        # Brewfile、カラースキーム等
│   └── lib/               # 共通ライブラリ
└── scripts/               # ユーティリティスクリプト
```

## 重要な設計パターン

### シンボリックリンク構造

このリポジトリのファイルはホームディレクトリにシンボリックリンクとして配置されます。

```bash
# 例: ~/.bashrc -> /path/to/dotfiles/.bashrc
```

**注意**: ファイルを追加・削除する場合は`Makefile`の`DOTFILES_EXCLUDES`と`DOTFILES_TARGET`を確認してください。

### AI IDE検出パターン

`.bashrc`には`is_ai_ide()`関数があり、AIツールの統合ターミナルを検出します。

```bash
is_ai_ide() {
    [[ -n "$VSCODE_PID" && -n "$CODEIUM_EDITOR_APP_ROOT" ]] && return 0  # Windsurf
    [[ "$TERM_PROGRAM" == "vscode" ]] && return 0  # VSCode/Cursor
    [[ -n "$CURSOR_PID" ]] && return 0  # Cursor
    [[ -n "$CLAUDE_CODE" ]] && return 0  # Claude Code
    return 1
}
```

AI IDE検出時にスキップされる設定:
- tmux自動起動
- starship初期化
- bash-completion読み込み
- hub/zoxide初期化

**この関数を変更する場合は、既存の検出パターンを維持してください。**

### AI開発ツールのインストール

| ツール | インストール方法 | 管理場所 |
|--------|------------------|----------|
| Cursor CLI | Homebrew | `etc/init/assets/brew/Brewfile` |
| Claude Code | curl | `etc/init/osx/claude-code.sh` |

**PATH設定** (`.bashrc`冒頭):
```bash
PATH="$HOME/.local/bin:$PATH:$HOME/bin"
```

- `~/.local/bin`: Claude Code等のユーザーローカルツール（curl installer使用時）
- `~/bin`: dotfilesのカスタムスクリプト

## Makefileコマンド

| コマンド | 説明 |
|----------|------|
| `make list` | デプロイ対象ファイル一覧表示 |
| `make deploy` | ホームディレクトリへシンボリックリンク作成 |
| `make init` | 環境設定の初期化 |
| `make install` | update + deploy + init を実行 |
| `make update` | リポジトリの更新（git pull） |
| `make clean` | dotfilesの削除 |
| `make lint` | shellcheckでスクリプトを検証 |
| `make validate` | シンボリックリンク整合性チェック |

## ファイル別ガイドライン

### シェルスクリプト（`.bashrc`, `bin/*`, `etc/**/*.sh`）

- **shebang**: `#!/usr/bin/env bash`（Homebrew bash前提）
- **エラーハンドリング**: `set -euo pipefail` を使用
- **変数展開**: 常にダブルクォート `"$var"`
- **条件分岐**: `[[ ]]` を使用（bash拡張）
- **リント**: `shellcheck` で検証

### Lua設定（`.wezterm.lua`, `.hammerspoon/*.lua`）

- **変数**: `local` を使用
- **モジュール**: 明示的な `require`

### 設定ファイル全般

- 新しい設定を追加する前に、既存のパターンを確認
- コメントで設定の目的を説明
- 外部依存がある場合は`README.md`または`etc/init/assets/brew/Brewfile`に記載

## 変更時のチェックリスト

- [ ] 既存のコードスタイルに従っているか
- [ ] shellcheckでエラーがないか（`make lint`）
- [ ] シンボリックリンク構造を壊していないか
- [ ] AI IDE検出パターンを維持しているか（該当する場合）
- [ ] README.mdの更新が必要か（新しい依存や設定追加時）
