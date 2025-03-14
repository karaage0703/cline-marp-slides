# Cline-Marp-Slides

Cline（VS Code の AI コーディング支援拡張）を活用して、Markdown 形式のスライドを自動生成し、Marp でスライドを作成するシステムです。

## 概要

本プロジェクトは、**Cline（VS Code の AI コーディング支援拡張）を活用して、Markdown 形式のスライドを自動生成し、Marp でスライドを作成するシステム** を提供します。
ユーザーは **自由なフォーマットでアウトライン（原稿）を作成** し、それを基に **Cline が Marp 用の Markdown を生成** し、最終的に Marp でスライドを出力します。

## フォルダ構成

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
│── /docs            # ドキュメント
│   │── design.md    # 要件・設計書
│── /.devcontainer   # VSCode Dev Containers設定
│── README.md        # プロジェクトの説明
│── Dockerfile       # Dockerイメージ定義
│── docker-compose.yml # Docker Compose設定
```

## 使い方

### 1. アウトラインの作成

`source/outline.md` にスライドの原稿（アウトライン）を自由なフォーマットで作成します。

### 2. Clineを使用してMarkdownを生成

VS Code内でCline拡張機能を使用して、アウトラインからMarp用のMarkdownを生成します。

1. VS Codeで `source/outline.md` を開きます
2. Clineに以下のような指示を出します：

```
このアウトラインを元に、Marp用のMarkdownスライドを生成してください。
スライドには以下の要素を含めてください：
- marpのヘッダー（marp: true, theme: default, paginate: true）
- スライドの区切り（---）
- 適切な見出しレベル（#, ##, ###）
- 箇条書きリスト
- コードブロック（必要に応じて）
- 画像の挿入（../source/images/から相対パスで）
```

3. 生成されたMarkdownを `generated/slides.md` に保存します

### 3. スライドの生成

`scripts/generate_slides.sh` を使用して、Markdownからスライドを生成します。

```bash
# PDFを生成
./scripts/generate_slides.sh --format pdf --output presentation

# PowerPointを生成
./scripts/generate_slides.sh --format pptx --output presentation

# HTMLを生成
./scripts/generate_slides.sh --format html --output presentation
```

生成されたスライドは `output` ディレクトリに保存されます。

## カスタマイズ

### テーマのカスタマイズ

`generated/theme.css` を編集することで、スライドのデザインをカスタマイズできます。

### 画像の追加

スライドで使用する画像は `source/images/` ディレクトリに保存します。
Markdownからは相対パスで参照します：

```markdown
![画像の説明](../source/images/diagram.png)
```

## 必要なツール

### ローカル環境での実行
- VS Code
- Cline拡張機能
- Marp CLI（`npm install -g @marp-team/marp-cli`）
- Python 3.x（サンプル画像生成用）
- Chromium/Chrome（PDF/PPTX生成用）

### Docker環境での実行
- Docker
- Docker Compose

## Docker環境での使用方法

Docker環境を使用すると、依存関係のインストールなしにMarpスライドの作成・編集が可能です。

### 1. Dockerコンテナの起動

```bash
# コンテナをビルドして起動
docker-compose up -d

# コンテナ内でシェルを実行
docker-compose exec app bash
```

### 2. Marpプレビューサーバーの起動

コンテナ内で以下のコマンドを実行して、Marpのプレビューサーバーを起動します：

```bash
# コンテナ内で実行
marp -s -I source
```

ブラウザで http://localhost:8080 にアクセスすると、スライドのプレビューが表示されます。
`source/outline.md` を編集すると、プレビューが自動的に更新されます。

### 3. スライドの生成

コンテナ内で以下のコマンドを実行して、スライドを生成します：

```bash
# PDFを生成
./scripts/generate_slides.sh --format pdf --output presentation

# PowerPointを生成
./scripts/generate_slides.sh --format pptx --output presentation

# HTMLを生成
./scripts/generate_slides.sh --format html --output presentation
```

生成されたスライドは `output` ディレクトリに保存され、ホストマシンからも確認できます。

## VSCode Dev Containers での使用方法

VSCode Dev Containersを使用すると、VSCode内でDockerコンテナを開発環境として使用できます。

### 1. Dev Containerの起動

1. VSCodeで「Remote-Containers: Reopen in Container」コマンドを実行
2. コンテナ内のVSCode環境が自動的に設定され、以下の機能が利用可能になります：
   - Marp for VSCode拡張機能によるプレビュー
   - Markdown編集の強化機能
   - ターミナルからの直接コマンド実行
   - 自動フォーマット

### 2. Marpプレビューサーバーの起動

VSCode内のターミナルで以下のコマンドを実行します：

```bash
marp -s -I source
```

### 3. スライドの生成

VSCode内のターミナルで以下のコマンドを実行します：

```bash
./scripts/generate_slides.sh --format html --output presentation
```

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。
