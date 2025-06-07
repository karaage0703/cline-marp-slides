#!/bin/bash

# 新しいプロジェクト作成スクリプト
# projects/{project-name} ディレクトリ構造を作成します

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# ヘルプメッセージ
show_help() {
    echo "使用方法: $0 <プロジェクト名> [オプション]"
    echo ""
    echo "引数:"
    echo "  プロジェクト名        作成するプロジェクトの名前"
    echo ""
    echo "オプション:"
    echo "  -t, --template NAME   テンプレート名（デフォルト: basic）"
    echo "  -h, --help            このヘルプメッセージを表示"
    echo ""
    echo "例:"
    echo "  $0 my-presentation"
    echo "  $0 company-meeting --template business"
}

# デフォルト値
TEMPLATE="basic"

# 引数の解析
if [ $# -eq 0 ]; then
    echo "エラー: プロジェクト名を指定してください"
    show_help
    exit 1
fi

PROJECT_NAME="$1"
shift

# オプションの解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--template)
            TEMPLATE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "エラー: 不明なオプション: $1"
            show_help
            exit 1
            ;;
    esac
done

# プロジェクト名の検証
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "エラー: プロジェクト名には英数字、ハイフン、アンダースコアのみ使用できます"
    exit 1
fi

# プロジェクトディレクトリの設定
PROJECT_DIR="$PROJECT_ROOT/projects/$PROJECT_NAME"

# 既存のプロジェクトチェック
if [ -d "$PROJECT_DIR" ]; then
    echo "エラー: プロジェクト '$PROJECT_NAME' は既に存在します: $PROJECT_DIR"
    exit 1
fi

echo "新しいプロジェクト '$PROJECT_NAME' を作成しています..."

# ディレクトリ構造の作成
mkdir -p "$PROJECT_DIR/source/images"
mkdir -p "$PROJECT_DIR/generated"
mkdir -p "$PROJECT_DIR/output"

# テンプレートファイルの作成
create_outline_template() {
    cat > "$PROJECT_DIR/source/outline.md" << 'EOF'
# プレゼンテーションのアウトライン

## タイトル
My Presentation Title

## はじめに
- プレゼンテーションの目的
- 対象となる聞き手
- 主要なポイント

## メインコンテンツ
### セクション1
- ポイント1
- ポイント2
- ポイント3

### セクション2
- ポイント1
- ポイント2

## まとめ
- 要点の振り返り
- 次のアクション
- 質疑応答
EOF
}

create_theme_template() {
    cat > "$PROJECT_DIR/generated/theme.css" << 'EOF'
/* Marp カスタムテーマ */

section {
  background: #fafafa;
  color: #333;
  font-family: 'Helvetica Neue', Arial, sans-serif;
}

h1 {
  color: #2c3e50;
  border-bottom: 3px solid #3498db;
  padding-bottom: 0.3em;
}

h2 {
  color: #34495e;
  border-left: 4px solid #3498db;
  padding-left: 0.5em;
}

/* 箇条書きのスタイル */
ul {
  list-style-type: none;
  padding-left: 0;
}

li {
  margin: 0.5em 0;
  padding-left: 1.5em;
  position: relative;
}

li:before {
  content: "▶";
  color: #3498db;
  position: absolute;
  left: 0;
}

/* コードブロックのスタイル */
pre {
  background: #f8f8f8;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 1em;
}

code {
  background: #f1c40f;
  padding: 0.2em 0.4em;
  border-radius: 3px;
  font-size: 0.9em;
}
EOF
}

create_slides_template() {
    cat > "$PROJECT_DIR/generated/slides.md" << 'EOF'
---
marp: true
theme: default
paginate: true
---

# My Presentation Title

Your Name
Date

---

## はじめに

- プレゼンテーションの目的
- 対象となる聞き手
- 主要なポイント

---

## メインコンテンツ

### セクション1
- ポイント1
- ポイント2
- ポイント3

---

## セクション2

- ポイント1
- ポイント2

---

## まとめ

- 要点の振り返り
- 次のアクション
- **質疑応答**

---

# ご清聴ありがとうございました

質問はありますか？
EOF
}

# テンプレートファイルの作成
create_outline_template
create_theme_template
create_slides_template

echo "プロジェクト '$PROJECT_NAME' が正常に作成されました！"
echo ""
echo "プロジェクトディレクトリ: $PROJECT_DIR"
echo ""
echo "次のステップ:"
echo "1. $PROJECT_DIR/source/outline.md を編集してプレゼンテーションの内容を作成"
echo "2. Clineを使用してアウトラインから Marp用のMarkdownを生成"
echo "3. スライドを生成: ./scripts/generate_slides.sh -p $PROJECT_NAME -f html"
echo ""
echo "利用可能なコマンド:"
echo "  # HTMLスライドを生成"
echo "  ./scripts/generate_slides.sh -p $PROJECT_NAME -f html"
echo ""
echo "  # 編集可能なPowerPointを生成"
echo "  ./scripts/generate_slides.sh -p $PROJECT_NAME -f pptx --editable"
echo ""
echo "  # PDFを生成"
echo "  ./scripts/generate_slides.sh -p $PROJECT_NAME -f pdf"