# **要件・設計書**

## **1. 要件定義**

### **1.1 基本情報**
- **プロジェクト名称**: Cline を活用した Marp スライド生成システム
- **リポジトリ名**: cline-marp-slides

### **1.2 プロジェクト概要**
本プロジェクトは、**Cline（VS Code の AI コーディング支援拡張）を活用して、Markdown 形式のスライドを自動生成し、Marp でスライドを作成するシステム** を開発することを目的としています。
ユーザーは **自由なフォーマットでアウトライン（原稿）を作成** し、それを基に **Cline が Marp 用の Markdown を生成** し、最終的に Marp でスライドを出力します。

### **1.3 機能要件**

#### **1.3.1 基本機能**
- **アウトライン（原稿）を自由なフォーマットで記述可能**
- **Cline を活用してアウトラインから Marp 用の Markdown を自動生成**
- **Marp でスライドをプレビュー・出力**
- **スライドで使用する画像を管理**
- **フォルダ構成を整理し、原稿・画像と生成物を分離**
- **Docker環境でのスライド作成・編集をサポート**
- **VSCode Dev Containersによる開発環境の統一**

#### **1.3.2 スライド生成機能**
- **Cline に指示を出して Markdown を生成**
- **スライドのデザイン（テーマ・レイアウト）を指定可能**
- **画像をスライドに挿入**
- **スライドの区切りや見出しを適切に変換**

### **1.4 非機能要件**

#### **1.4.1 性能要件**
- **Cline による Markdown 生成を 5 秒以内に完了**
- **Marp でのスライドプレビューをリアルタイムで反映**

#### **1.4.2 セキュリティ要件**
- **原稿データ（アウトライン）は編集可能だが、生成された Markdown は編集しない**
- **スライドのデータはローカル環境で管理**

#### **1.4.3 運用・保守要件**
- **Cline の指示テンプレートを用意し、スライド作成を効率化**
- **Marp のカスタムテーマを作成し、デザインを統一**
- **スライドのバージョン管理を Git で行う**
- **Docker環境を提供し、環境依存を解消**

### **1.5 制約条件**
- **Cline（VS Code 拡張）を利用**
- **Marp でスライドを出力**
- **Markdown 形式でスライドを管理**
- **Python またはシェルスクリプトで自動化スクリプトを作成**
- **Docker環境でも動作すること**

### **1.6 開発環境**
- **エディタ**: VS Code
- **言語**: Markdown, Python, Shell Script
- **ツール**: Cline, Marp, Git, Docker, Docker Compose
- **VSCode拡張**: Marp for VSCode, Remote - Containers

### **1.7 成果物**
- **スライドの原稿（アウトライン）**
- **Cline による Markdown 生成スクリプト**
- **Marp 用の Markdown スライド**
- **スライドの画像**
- **README（セットアップ手順含む）**
- **要件・設計書**
- **Dockerfile・docker-compose.yml**
- **VSCode Dev Containers設定**

---

## **2. システム設計**

### **2.1 システム概要設計**

#### **2.1.1 フォルダ構成**
```
/project-root
│── /source          # 人間が管理する原稿・画像
│   │── outline.md   # スライドの原稿（編集する）
│   │── images/      # スライドで使用する画像
│       │── diagram.png
│       │── logo.png
│── /generated       # Cline が生成するスライド用 Markdown
│   │── slides.md    # Marp 用の Markdown スライド（編集しない）
│   │── theme.css    # Marp のカスタムテーマ
│── /scripts         # 自動化スクリプト
│   │── generate_slides.sh  # スライド生成スクリプト
│   │── create_sample_images.py  # サンプル画像生成スクリプト
│── /output          # 生成されたスライド（PDF, PPTX, HTML）
│   │── presentation.pdf
│   │── presentation.pptx
│   │── presentation.html
│── /docs            # ドキュメント
│   │── design.md    # 要件・設計書
│── /.devcontainer   # VSCode Dev Containers設定
│   │── devcontainer.json  # Dev Container設定ファイル
│── README.md        # プロジェクトの説明
│── Dockerfile       # Dockerイメージ定義
│── docker-compose.yml # Docker Compose設定
│── package.json     # Node.js依存関係
│── requirements.txt # Python依存関係
```

#### **2.1.2 データフロー**
1. **ユーザーが `/source/outline.md` にスライドの原稿を作成**
2. **Cline に指示を出し、`/generated/slides.md` を生成**
3. **画像を `/source/images/` に保存し、Markdown に追加**
4. **Marp でスライドをプレビューし、必要に応じて修正**
5. **スライドを PDF/PPTX/HTML 形式で出力**

---

### **2.2 詳細設計**

#### **2.2.1 Cline の指示テンプレート**
| 指示 | 生成される Markdown |
|------|------------------|
| 「タイトルスライドを作成」 | `# プレゼンのタイトル` |
| 「新しいスライドを追加」 | `---` |
| 「見出しを追加」 | `## 見出し` |
| 「箇条書きを追加」 | `- 項目1` `- 項目2` |
| 「画像を追加」 | `![画像](../source/images/diagram.png)` |

#### **2.2.2 スライド生成スクリプト**
```sh
#!/bin/bash
# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# 入力と出力のパス
SLIDES_PATH="$PROJECT_ROOT/generated/slides.md"
OUTPUT_DIR="$PROJECT_ROOT/output"
THEME_PATH="$PROJECT_ROOT/generated/theme.css"

# 出力ディレクトリに画像フォルダを作成し、画像をコピー
mkdir -p "$OUTPUT_DIR/images"
cp -r "$PROJECT_ROOT/source/images/"* "$OUTPUT_DIR/images/"

# 一時ファイルを作成して画像パスを修正
TMP_SLIDES_PATH="$OUTPUT_DIR/tmp_slides.md"
cp "$SLIDES_PATH" "$TMP_SLIDES_PATH"

# 画像パスを修正（../source/images/ → ./images/）
sed -i 's|../source/images/|./images/|g' "$TMP_SLIDES_PATH"

# Marpを使用してスライドを変換
npx @marp-team/marp-cli@latest "$TMP_SLIDES_PATH" --html --allow-local-files -o "$OUTPUT_DIR/presentation.html"

# 一時ファイルを削除
rm -f "$TMP_SLIDES_PATH"

echo "スライドの変換が完了しました: $OUTPUT_DIR/presentation.html"
```

#### **2.2.3 Docker環境設計**
- **Dockerfile**: Python、Node.js、Marp CLI、Chromiumブラウザをインストール
- **docker-compose.yml**: ポートマッピング、ボリュームマウントを設定
- **VSCode Dev Containers**: 開発環境の統一、拡張機能の自動インストール

---

### **2.3 インターフェース設計**
- **Cline の指示を VS Code から実行**
- **Marp のプレビュー機能を利用**
- **スライドのデザインを `theme.css` でカスタマイズ**
- **Docker環境でのプレビューサーバー**
- **VSCode Dev Containersによる統合開発環境**

---

### **2.4 セキュリティ設計**
- **原稿（アウトライン）は編集可能だが、生成された Markdown は編集しない**
- **スライドデータはローカル環境で管理**
- **Git でバージョン管理し、変更履歴を追跡**
- **Docker環境による実行環境の分離**

---

### **2.5 テスト設計**
- **Cline の指示が適切に Markdown を生成するか**
- **Marp でスライドが正しく表示されるか**
- **画像が正しくスライドに挿入されるか**
- **スクリプトが正常に動作するか**
- **Docker環境でのスライド生成が正常に動作するか**
- **VSCode Dev Containersでの開発環境が正常に動作するか**

---

### **2.6 開発環境・依存関係**
- **VS Code**
- **Cline（VS Code 拡張）**
- **Marp CLI（Node.jsパッケージ）**
- **Git**
- **Node.js（Marp CLIの実行環境）**
- **Shell Script（スライド生成スクリプト用）**
- **Python 3.x（サンプル画像生成用）**
- **Pillow, NumPy（Pythonライブラリ）**
- **Chromium/Chrome（PDF/PPTX生成用）**
- **Docker, Docker Compose（コンテナ環境）**
- **VSCode Remote - Containers拡張（Dev Containers用）**
- **Marp for VSCode拡張（Markdownプレビュー用）**
- **package.json（Node.js依存関係管理）**
- **requirements.txt（Python依存関係管理）**

---

### **2.7 開発工程**
| フェーズ | 期間 | 内容 |
|---------|------|------|
| 要件定義 | 1週目 | 機能要件・非機能要件の整理 |
| 設計 | 2週目 | フォルダ構成・データフローの設計 |
| 実装 | 3-4週目 | Cline の指示テンプレート作成、スクリプト開発、Docker環境構築 |
| テスト | 5週目 | Markdown 生成・スライド表示の確認、Docker環境のテスト |
| ドキュメント作成 | 6週目 | README・マニュアル作成 |

---

## **3. まとめ**
この設計に基づき、Cline を活用したスライド作成を効率化します。Docker環境とVSCode Dev Containersを活用することで、環境構築の手間を省き、チーム全体で一貫した開発環境を提供します。

次のステップとして、**Cline の指示テンプレートを試し、スライド生成の精度を確認** していきましょう！ 🚀