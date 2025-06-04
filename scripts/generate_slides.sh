#!/bin/bash

# Marpスライド変換スクリプト
# generated/slides.mdからPDF、PPTX、HTMLなどの最終成果物を生成します

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 入力と出力のパス
SLIDES_PATH="$PROJECT_ROOT/generated/slides.md"
OUTPUT_DIR="$PROJECT_ROOT/output"
THEME_PATH="$PROJECT_ROOT/generated/theme.css"

# 出力ディレクトリが存在しない場合は作成
mkdir -p "$OUTPUT_DIR"

# 必要なファイルが存在するか確認
if [ ! -f "$SLIDES_PATH" ]; then
    echo "エラー: スライドファイルが見つかりません: $SLIDES_PATH"
    exit 1
fi

# ヘルプメッセージ
show_help() {
    echo "使用方法: $0 [オプション]"
    echo "オプション:"
    echo "  -f, --format FORMAT   出力フォーマット（pdf, pptx, html）"
    echo "  -o, --output FILE     出力ファイル名（拡張子なし）"
    echo "  -t, --theme FILE      カスタムテーマファイル"
    echo "  -e, --editable        編集可能なPPTXを生成（pptxフォーマット時のみ有効）"
    echo "  -h, --help            このヘルプメッセージを表示"
    echo ""
    echo "例:"
    echo "  $0 --format pdf --output presentation"
    echo "  $0 -f pptx -o presentation -t custom-theme.css"
    echo "  $0 -f pptx -o presentation --editable"
}

# デフォルト値
FORMAT="pdf"
OUTPUT_NAME="presentation"
THEME_FILE="$THEME_PATH"
EDITABLE=false

# コマンドライン引数の解析
while [[ $# -gt 0 ]]; do
    case $1 in
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
echo "入力: $SLIDES_PATH"
echo "出力: $OUTPUT_FILE"
echo "フォーマット: $FORMAT"

# 出力ディレクトリに画像フォルダを作成し、画像をコピー
mkdir -p "$OUTPUT_DIR/images"
cp -r "$PROJECT_ROOT/source/images/"* "$OUTPUT_DIR/images/"

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