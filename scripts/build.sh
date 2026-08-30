#!/bin/bash
# scripts/build.sh
# Automated build & setup script for TurtleWoW 1.17.2 Docker environment

set -e

REPO_URL="${1:-https://github.com/d3athbl0w/twow-1172.git}"
BRANCH="${2:-master}"
TARGET_FOLDER="${3:-../twow-1172}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== TurtleWoW 1.17.2 Docker Build Assistant ==="

# 1. Check & download game data if missing
if [ ! -d "$ROOT_DIR/data/dbc" ] || [ ! -d "$ROOT_DIR/data/maps" ]; then
    echo "[INFO] Game assets not found in ./data/. Launching data downloader..."
    bash "$SCRIPT_DIR/download_data.sh"
fi

# 2. Build Docker images
echo "[INFO] Building Docker images with Docker Compose..."
cd "$ROOT_DIR"
docker compose build

echo "=== Build Completed Successfully! ==="
echo "Start the server with: docker compose up -d"
