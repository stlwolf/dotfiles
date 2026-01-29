# GitHub Copilot カスタム指示

このリポジトリで作業する際は、まず `AGENTS.md` を読んでリポジトリの構造と設計パターンを理解してください。

## 重要なポイント

- macOS専用のdotfiles管理リポジトリ
- Homebrew前提の環境構築
- シンボリックリンクでホームディレクトリに配置

## コーディング規約

### シェルスクリプト
- shebang: `#!/usr/bin/env bash`
- エラーハンドリング: `set -euo pipefail`
- 変数展開: 常にダブルクォート `"$var"`
- 条件分岐: `[[ ]]` を使用
- shellcheckでリント

### Lua設定
- 変数は `local` を使用
- モジュールは明示的に `require`

## 変更時の注意

- 既存のコードスタイルに従う
- AI IDE検出パターン（`.bashrc`の`is_ai_ide()`）を維持
- 新しい依存追加時はREADME.mdを更新
