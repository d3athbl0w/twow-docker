#!/bin/bash
set -e

echo "=== Starting TurtleWoW World Server (mangosd) ==="
cd /app

# Ensure logs, honor, and sql/unused folders exist
mkdir -p /app/logs /app/honor /app/sql/unused

# Wait for MariaDB to be reachable on port 3306
echo "[WorldServer] Waiting for MariaDB at mariadb:3306..."
while ! nc -z mariadb 3306; do
  sleep 1
done
echo "[WorldServer] MariaDB is available!"

# Validate presence of client game data (dbc, maps, vmaps, mmaps)
if [ ! -d "/app/data/maps" ] || [ ! -d "/app/data/dbc" ]; then
  echo "===================================================================="
  echo "[WorldServer ERROR] Game data assets not found in ./data/!"
  echo "Please download the game data assets by running in your host terminal:"
  echo "  PowerShell (Windows): .\\scripts\\download_data.ps1"
  echo "  Bash (Linux/Mac):     ./scripts/download_data.sh"
  echo "===================================================================="
  exit 1
fi

exec /app/bin/mangosd -c /app/etc/mangosd.conf

