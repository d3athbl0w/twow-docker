#!/bin/bash
set -e

URL="https://github.com/d3athbl0w/twow-1172/releases/download/data/data.zip"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${SCRIPT_DIR}/../data"
ZIP_FILE="${SCRIPT_DIR}/../data.zip"

echo "=== TurtleWoW 1.17.2 Game Data Downloader ==="
echo "Target URL: ${URL}"
echo "Target Data Folder: ${DATA_DIR}"

mkdir -p "${DATA_DIR}"

if [ -d "${DATA_DIR}/dbc" ] && [ -d "${DATA_DIR}/maps" ]; then
    echo "Game data already exists in ${DATA_DIR}."
    read -p "Do you want to re-download and overwrite? (y/N): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Skipping download."
        exit 0
    fi
fi

echo "Downloading data.zip (~2.5GB)... Please wait..."
if command -v curl >/dev/null 2>&1; then
    curl -L -o "${ZIP_FILE}" "${URL}" --progress-bar
elif command -v wget >/dev/null 2>&1; then
    wget -O "${ZIP_FILE}" "${URL}"
else
    echo "Error: Neither curl nor wget is installed."
    exit 1
fi

echo "Extracting data.zip to ${DATA_DIR}..."
if command -v unzip >/dev/null 2>&1; then
    unzip -o "${ZIP_FILE}" -d "${DATA_DIR}"
elif command -v 7z >/dev/null 2>&1; then
    7z x "${ZIP_FILE}" -o"${DATA_DIR}" -y
else
    echo "Error: unzip is required to extract data.zip."
    exit 1
fi

rm -f "${ZIP_FILE}"
echo "=== All Game Data is ready in ${DATA_DIR} ==="
