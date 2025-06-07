#!/bin/bash

# Marpスライド変換スクリプト（多プロジェクト対応）
# projects/{project}/generated/slides.mdからPDF、PPTX、HTMLなどの最終成果物を生成します

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# デフォルト値
PROJECT_NAME=""

# プロジェクト名が指定されていない場合の処理
get_default_project() {
    local projects_dir="$PROJECT_ROOT/projects"
    if [ -d "$projects_dir" ]; then
        local project_count=$(ls -1 "$projects_dir" | wc -l)
        if [ "$project_count" -eq 1 ]; then
            # プロジェクトが1つだけの場合は自動選択
            PROJECT_NAME=$(ls -1 "$projects_dir" | head -1)
            echo "プロジェクト '$PROJECT_NAME' を自動選択しました"
        else
            # 複数プロジェクトがある場合はリスト表示
            echo "利用可能なプロジェクト:"
            ls -1 "$projects_dir"
            echo ""
            echo "エラー: プロジェクト名を指定してください (-p オプション)"
            exit 1
        fi
    else
        echo "エラー: projectsディレクトリが見つかりません"
        exit 1
    fi
}


# ヘルプメッセージ
show_help() {
    echo "使用方法: $0 [オプション]"
    echo "オプション:"
    echo "  -p, --project NAME    プロジェクト名（省略時は自動選択）"
    echo "  -f, --format FORMAT   出力フォーマット（pdf, pptx, html）"
    echo "  -o, --output FILE     出力ファイル名（拡張子なし）"
    echo "  -t, --theme FILE      カスタムテーマファイル"
    echo "  -e, --editable        編集可能なPPTXを生成（pptxフォーマット時のみ有効）"
    echo "  -h, --help            このヘルプメッセージを表示"
    echo ""
    echo "例:"
    echo "  $0 -p sample-project --format pdf --output presentation"
    echo "  $0 -p my-slides -f pptx -o presentation -t custom-theme.css"
    echo "  $0 -f pptx -o presentation --editable  # プロジェクト自動選択"
}

# デフォルト値
FORMAT="pdf"
OUTPUT_NAME="presentation"
THEME_FILE=""
EDITABLE=false

# コマンドライン引数の解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--project)
            PROJECT_NAME="$2"
            shift 2
            ;;
        -f|--format)
            FORMAT="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_NAME="$2"
            shift 2
            ;;
        -t|--theme)
            THEME_FILE="$2"
            shift 2
            ;;
        -e|--editable)
            EDITABLE=true
            shift
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

# プロジェクト名が指定されていない場合は自動選択
if [ -z "$PROJECT_NAME" ]; then
    get_default_project
fi

# プロジェクトディレクトリの設定
PROJECT_DIR="$PROJECT_ROOT/projects/$PROJECT_NAME"
if [ ! -d "$PROJECT_DIR" ]; then
    echo "エラー: プロジェクト '$PROJECT_NAME' が見つかりません: $PROJECT_DIR"
    echo "利用可能なプロジェクト:"
    ls -1 "$PROJECT_ROOT/projects" 2>/dev/null || echo "  (プロジェクトが見つかりません)"
    exit 1
fi

# 入力と出力のパス
SLIDES_PATH="$PROJECT_DIR/generated/slides.md"
OUTPUT_DIR="$PROJECT_DIR/output"
DEFAULT_THEME_PATH="$PROJECT_DIR/generated/theme.css"

# テーマファイルの設定
if [ -z "$THEME_FILE" ]; then
    THEME_FILE="$DEFAULT_THEME_PATH"
fi

# 出力ディレクトリが存在しない場合は作成
mkdir -p "$OUTPUT_DIR"

# 必要なファイルが存在するか確認
if [ ! -f "$SLIDES_PATH" ]; then
    echo "エラー: スライドファイルが見つかりません: $SLIDES_PATH"
    echo "プロジェクト '$PROJECT_NAME' の generated/slides.md を作成してください"
    exit 1
fi

# テーマファイルの確認
if [ -n "$THEME_FILE" ] && [ ! -f "$THEME_FILE" ]; then
    echo "警告: 指定されたテーマファイルが見つかりません: $THEME_FILE"
    echo "デフォルトのテーマを使用します"
    THEME_OPTION=""
else
    THEME_OPTION="--theme-set $THEME_FILE"
fi

# 出力ファイルパスの設定
OUTPUT_FILE="$OUTPUT_DIR/${OUTPUT_NAME}.${FORMAT}"

echo "スライドを変換しています..."
echo "プロジェクト: $PROJECT_NAME"
echo "入力: $SLIDES_PATH"
echo "出力: $OUTPUT_FILE"
echo "フォーマット: $FORMAT"

# 出力ディレクトリに画像フォルダを作成し、画像をコピー
mkdir -p "$OUTPUT_DIR/images"
if [ -d "$PROJECT_DIR/source/images" ]; then
    cp -r "$PROJECT_DIR/source/images/"* "$OUTPUT_DIR/images/" 2>/dev/null || true
fi

# 一時ファイルを作成して画像パスを修正
TMP_SLIDES_PATH="$OUTPUT_DIR/tmp_slides.md"
cp "$SLIDES_PATH" "$TMP_SLIDES_PATH"

# 画像パスを修正（../source/images/ → ./images/）
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' 's|\.\./source/images/|\./images/|g' "$TMP_SLIDES_PATH"
else
    # Linux/その他
    sed -i 's|\.\./source/images/|\./images/|g' "$TMP_SLIDES_PATH"
fi

# Marpを使用してスライドを変換
case $FORMAT in
    pdf)
        echo "PDFに変換しています..."
        npx @marp-team/marp-cli@latest "$TMP_SLIDES_PATH" --pdf --allow-local-files $THEME_OPTION -o "$OUTPUT_FILE"
        ;;
    pptx)
        if [ "$EDITABLE" = true ]; then
            echo "編集可能なPowerPointに変換しています..."
            npx @marp-team/marp-cli@latest "$TMP_SLIDES_PATH" --pptx --pptx-editable --allow-local-files $THEME_OPTION -o "$OUTPUT_FILE"
        else
            echo "PowerPointに変換しています..."
            npx @marp-team/marp-cli@latest "$TMP_SLIDES_PATH" --pptx --allow-local-files $THEME_OPTION -o "$OUTPUT_FILE"
        fi
        ;;
    html)
        echo "HTMLに変換しています..."
        npx @marp-team/marp-cli@latest "$TMP_SLIDES_PATH" --html --allow-local-files $THEME_OPTION -o "$OUTPUT_FILE"
        ;;
    *)
        echo "エラー: サポートされていないフォーマット: $FORMAT"
        echo "サポートされているフォーマット: pdf, pptx, html"
        exit 1
        ;;
esac

# 一時ファイルを削除
rm -f "$TMP_SLIDES_PATH"

# 変換結果の確認
if [ $? -eq 0 ]; then
    echo "変換が完了しました: $OUTPUT_FILE"

    # 出力ファイルを開く（オプション）
    case "$(uname)" in
        Darwin*)
            # macOS
            open "$OUTPUT_FILE"
            ;;
        Linux*)
            # Linux
            if command -v xdg-open &> /dev/null; then
                xdg-open "$OUTPUT_FILE"
            else
                echo "ファイルを開くには: $OUTPUT_FILE"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            # Windows
            start "$OUTPUT_FILE"
            ;;
        *)
            echo "ファイルを開くには: $OUTPUT_FILE"
            ;;
    esac
else
    echo "エラー: 変換に失敗しました"
    exit 1
fi

echo "完了しました"