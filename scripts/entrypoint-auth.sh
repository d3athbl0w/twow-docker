#!/bin/bash
set -e

echo "=== Starting TurtleWoW Auth Server (realmd) ==="
cd /app

# Ensure logs folder exists
mkdir -p /app/logs

# Wait for MariaDB to be reachable on port 3306
echo "[AuthServer] Waiting for MariaDB at mariadb:3306..."
while ! nc -z mariadb 3306; do
  sleep 1
done
echo "[AuthServer] MariaDB is available!"

exec /app/bin/realmd -c /app/etc/realmd.conf
