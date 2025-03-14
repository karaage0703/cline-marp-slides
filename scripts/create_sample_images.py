#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
create_sample_images.py

このスクリプトは、サンプル画像を生成します。
- source/images/diagram.png - フォルダ構成図
- source/images/logo.png - サンプルロゴ
"""

import os
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont


def get_project_root():
    """プロジェクトのルートディレクトリを取得します。"""
    script_path = Path(os.path.abspath(__file__))
    return script_path.parent.parent


def create_folder_diagram(output_path, width=800, height=500):
    """
    フォルダ構成図を作成します。

    Args:
        output_path: 出力先のパス
        width: 画像の幅
        height: 画像の高さ
    """
    # 画像を作成
    img = Image.new("RGB", (width, height), color=(255, 255, 255))
    draw = ImageDraw.Draw(img)

    # フォントの設定（システムにインストールされているフォントを使用）
    try:
        # macOSの場合
        font_path = "/System/Library/Fonts/Helvetica.ttc"
        title_font = ImageFont.truetype(font_path, 24)
        folder_font = ImageFont.truetype(font_path, 18)
        file_font = ImageFont.truetype(font_path, 16)
    except IOError:
        # フォントが見つからない場合はデフォルトフォントを使用
        title_font = ImageFont.load_default()
        folder_font = ImageFont.load_default()
        file_font = ImageFont.load_default()

    # タイトルを描画
    title = "Cline-Marp-Slides フォルダ構成"
    draw.text((width // 2 - 200, 30), title, fill=(0, 0, 0), font=title_font)

    # フォルダ構成を描画
    x_start = 100
    y_start = 100
    y_spacing = 40

    # プロジェクトルート
    draw.text((x_start, y_start), "/project-root", fill=(0, 0, 150), font=folder_font)

    # source フォルダ
    draw.line(
        [(x_start + 10, y_start + 25), (x_start + 10, y_start + y_spacing)],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [(x_start + 10, y_start + y_spacing), (x_start + 30, y_start + y_spacing)],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 40, y_start + y_spacing),
        "/source",
        fill=(0, 0, 150),
        font=folder_font,
    )

    # source/outline.md
    draw.line(
        [
            (x_start + 50, y_start + y_spacing + 25),
            (x_start + 50, y_start + y_spacing * 2),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 2),
            (x_start + 70, y_start + y_spacing * 2),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 80, y_start + y_spacing * 2),
        "outline.md",
        fill=(150, 0, 0),
        font=file_font,
    )

    # source/images
    draw.line(
        [
            (x_start + 50, y_start + y_spacing + 25),
            (x_start + 50, y_start + y_spacing * 3),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 3),
            (x_start + 70, y_start + y_spacing * 3),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 80, y_start + y_spacing * 3),
        "/images",
        fill=(0, 0, 150),
        font=folder_font,
    )

    # source/images/diagram.png & logo.png
    draw.line(
        [
            (x_start + 90, y_start + y_spacing * 3 + 25),
            (x_start + 90, y_start + y_spacing * 4),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 90, y_start + y_spacing * 4),
            (x_start + 110, y_start + y_spacing * 4),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 120, y_start + y_spacing * 4),
        "diagram.png, logo.png",
        fill=(150, 0, 0),
        font=file_font,
    )

    # generated フォルダ
    draw.line(
        [(x_start + 10, y_start + 25), (x_start + 10, y_start + y_spacing * 5)],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 10, y_start + y_spacing * 5),
            (x_start + 30, y_start + y_spacing * 5),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 40, y_start + y_spacing * 5),
        "/generated",
        fill=(0, 0, 150),
        font=folder_font,
    )

    # generated/slides.md
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 5 + 25),
            (x_start + 50, y_start + y_spacing * 6),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 6),
            (x_start + 70, y_start + y_spacing * 6),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 80, y_start + y_spacing * 6),
        "slides.md",
        fill=(150, 0, 0),
        font=file_font,
    )

    # generated/theme.css
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 5 + 25),
            (x_start + 50, y_start + y_spacing * 7),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 7),
            (x_start + 70, y_start + y_spacing * 7),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 80, y_start + y_spacing * 7),
        "theme.css",
        fill=(150, 0, 0),
        font=file_font,
    )

    # scripts フォルダ
    draw.line(
        [(x_start + 10, y_start + 25), (x_start + 10, y_start + y_spacing * 8)],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 10, y_start + y_spacing * 8),
            (x_start + 30, y_start + y_spacing * 8),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 40, y_start + y_spacing * 8),
        "/scripts",
        fill=(0, 0, 150),
        font=folder_font,
    )

    # scripts/generate_slides.sh
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 8 + 25),
            (x_start + 50, y_start + y_spacing * 9),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 9),
            (x_start + 70, y_start + y_spacing * 9),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 80, y_start + y_spacing * 9),
        "generate_slides.sh",
        fill=(150, 0, 0),
        font=file_font,
    )

    # output フォルダ
    draw.line(
        [(x_start + 10, y_start + 25), (x_start + 10, y_start + y_spacing * 10)],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 10, y_start + y_spacing * 10),
            (x_start + 30, y_start + y_spacing * 10),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 40, y_start + y_spacing * 10),
        "/output",
        fill=(0, 0, 150),
        font=folder_font,
    )

    # output/presentation.pdf
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 10 + 25),
            (x_start + 50, y_start + y_spacing * 11),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.line(
        [
            (x_start + 50, y_start + y_spacing * 11),
            (x_start + 70, y_start + y_spacing * 11),
        ],
        fill=(0, 0, 0),
        width=2,
    )
    draw.text(
        (x_start + 80, y_start + y_spacing * 11),
        "presentation.pdf, .pptx, .html",
        fill=(150, 0, 0),
        font=file_font,
    )

    # 画像を保存
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path)
    print(f"フォルダ構成図を作成しました: {output_path}")


def create_logo(output_path, width=400, height=400):
    """
    サンプルロゴを作成します。

    Args:
        output_path: 出力先のパス
        width: 画像の幅
        height: 画像の高さ
    """
    # 画像を作成
    img = Image.new("RGBA", (width, height), color=(255, 255, 255, 0))
    draw = ImageDraw.Draw(img)

    # 円を描画
    center_x, center_y = width // 2, height // 2
    radius = min(width, height) // 3

    # グラデーション効果のある円を描画
    for r in range(radius, 0, -1):
        # 青から紫へのグラデーション
        blue = int(100 + (155 * (radius - r) / radius))
        red = int(50 + (200 * (radius - r) / radius))
        color = (red, 50, blue, 255)
        draw.ellipse((center_x - r, center_y - r, center_x + r, center_y + r), fill=color)

    # フォントの設定
    try:
        # macOSの場合
        font_path = "/System/Library/Fonts/Helvetica.ttc"
        logo_font = ImageFont.truetype(font_path, 60)
    except IOError:
        # フォントが見つからない場合はデフォルトフォントを使用
        logo_font = ImageFont.load_default()

    # テキストを描画
    text = "CM"  # Cline-Marp
    # 新しいバージョンのPILでは textsize の代わりに textbbox を使用
    left, top, right, bottom = draw.textbbox((0, 0), text, font=logo_font)
    text_width = right - left
    text_height = bottom - top
    draw.text(
        (center_x - text_width // 2, center_y - text_height // 2),
        text,
        fill=(255, 255, 255),
        font=logo_font,
    )

    # 画像を保存
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path)
    print(f"ロゴを作成しました: {output_path}")


def main():
    """メイン関数"""
    project_root = get_project_root()

    # 出力パス
    diagram_path = os.path.join(project_root, "source", "images", "diagram.png")
    logo_path = os.path.join(project_root, "source", "images", "logo.png")

    # 画像を作成
    create_folder_diagram(diagram_path)
    create_logo(logo_path)

    print("サンプル画像の作成が完了しました。")


if __name__ == "__main__":
    main()
