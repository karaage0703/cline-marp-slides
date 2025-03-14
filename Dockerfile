FROM python:3.11-slim

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    chromium \
    fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*

# Node.jsをインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Pythonの依存関係をインストール
COPY requirements.txt .
RUN pip install -r requirements.txt
RUN pip install ruff==0.9.1

# Marp CLIをグローバルにインストール
RUN npm install -g @marp-team/marp-cli@4.1.2

# Chromiumのパスを環境変数に設定
ENV CHROME_PATH=/usr/bin/chromium