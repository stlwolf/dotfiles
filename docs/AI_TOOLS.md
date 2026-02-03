# AI Development Tools

AI関連の開発ツールのインストール状況と運用メモ。

> **Note**: 暫定運用中。ツールの更新頻度や安定性を見て調整予定。

## ツール一覧

| ツール | インストール方法 | 管理場所 | 備考 |
|--------|------------------|----------|------|
| Cursor CLI | Homebrew | `Brewfile` | 公式サポートあり、quarantine属性削除処理込み |
| Claude Code | curl (公式推奨) | `etc/init/osx/claude-code.sh` | Anthropic公式のネイティブインストール |

## Cursor CLI

```bash
brew install --cask cursor-cli
```

- Brewfile管理でバージョン管理・一括インストールのメリットを活用
- `bundle.sh`でquarantine属性を自動削除

## Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

- Homebrewでも入るが公式はcurl推奨
- `make init`で他のセットアップと一緒にインストールされる

### 手動インストール

```bash
DOTPATH=$(pwd) bash etc/init/osx/claude-code.sh
```

## PATH設定

`.bashrc` 冒頭:

```bash
PATH="$HOME/.local/bin:$PATH:$HOME/bin"
```

- `~/.local/bin`: Claude Code等のcurlインストーラーが使用
- `~/bin`: dotfilesのカスタムスクリプト

## 確認コマンド

```bash
cursor --version
claude --version
```

---

## AI IDE統合

`.bashrc`にはAI IDE検出機能があり、統合ターミナルでは一部設定をスキップします。

### 検出される環境変数

- `VSCODE_PID` + `CODEIUM_EDITOR_APP_ROOT` (Windsurf)
- `TERM_PROGRAM=vscode` (VSCode/Cursor系)
- `CURSOR_PID` (Cursor)
- `CLAUDE_CODE` (Claude Code)

### AI IDE検出時にスキップされる設定

- tmux自動起動
- starship初期化
- bash-completion読み込み
- hub/zoxide初期化
- OSC 133エスケープシーケンス

通常のターミナル（iTerm2、WezTerm等）では全ての設定が有効。

### デバッグ

```bash
# AIツールの統合ターミナルで実行
env | grep -iE '(vscode|cursor|windsurf|claude|term_program)'
```
