# AI Development Tools

AI関連の開発ツールのインストール状況と運用メモ。

> **Note**: 暫定運用中。ツールの更新頻度や安定性を見て調整予定。

## ツール一覧

| ツール | インストール方法 | 管理場所 | 備考 |
|--------|------------------|----------|------|
| Cursor CLI | Homebrew (cask) | `Brewfile` | 公式サポートあり、quarantine属性削除処理込み |
| Claude Code | curl (公式推奨) | `etc/init/osx/claude-code.sh` | Anthropic公式のネイティブインストール |
| OpenAI Codex CLI | Homebrew (cask) | `Brewfile` | GPT-5.3搭載、Homebrew推奨 |
| Gemini CLI | Homebrew (formula) | `Brewfile` | Google製、Gemini 3モデル対応、Node.js依存 |
| Worktrunk | Homebrew (formula) | `Brewfile` + `.bashrc` | [git worktree](https://git-scm.com/docs/git-worktree) 並列作業用 CLI、[公式サイト](https://worktrunk.dev/) |

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

## OpenAI Codex CLI

```bash
brew install codex
```

- macOSではHomebrewインストールが推奨（npmより管理が容易）
- GPT-5.3搭載のコーディングエージェント

### 認証

```bash
codex login
```

- ブラウザが開きChatGPTアカウントでログイン

## Gemini CLI

```bash
brew install gemini-cli
```

- Google製のオープンソースAIエージェント（Apache 2.0）
- Gemini 3モデル、1Mトークンコンテキストウィンドウ
- Homebrew管理（Node.js依存は自動解決）

### 認証

```bash
gemini
```

- 初回起動時にGoogle OAuthでブラウザ認証
- 無料枠: 60 req/min, 1,000 req/day（個人Googleアカウント）
- APIキー利用も可能: `export GEMINI_API_KEY="YOUR_KEY"`

## Worktrunk

[Worktrunk](https://worktrunk.dev/) は AI エージェント向けに git worktree を扱いやすくする CLI（`wt`）。`wt switch` で作業ディレクトリを切り替えるには**シェル連携**が必須。

### インストール

- `Brewfile` に `brew 'worktrunk'` あり。`etc/init/osx/bundle.sh` 経由の `brew bundle` で導入。
- 手動: `brew install worktrunk`

### シェル連携（このリポジトリ）

`.bashrc` の `tool init` 付近で次を実行している（[公式マニュアル](https://worktrunk.dev/config/#shell-integration) と同じ形）。

```bash
if command -v wt >/dev/null 2>&1; then
    eval "$(wt config shell init bash)"
fi
```

- `wt config shell install` は **ホームの rc に追記する対話型**のため、dotfiles 管理では使わず上記の `eval` で宣言的に反映する。
- 新しいターミナルを開くか `source ~/.bashrc` の後、`type wt` が **shell function** になっていれば OK。

### 確認

```bash
wt --version
type wt
wt config show
```

## 確認コマンド

```bash
cursor --version
claude --version
codex --version
gemini --version
wt --version
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

Worktrunk のシェル連携は **スキップしない**（統合ターミナルでも `wt switch` の `cd` を有効にするため）。

通常のターミナル（iTerm2、WezTerm等）では全ての設定が有効。

### デバッグ

```bash
# AIツールの統合ターミナルで実行
env | grep -iE '(vscode|cursor|windsurf|claude|term_program)'
```
