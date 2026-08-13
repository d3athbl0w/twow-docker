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

exec /app/bin/mangosd -c /app/etc/mangosd.conf
