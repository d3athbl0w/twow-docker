#!/bin/bash
set -e

echo "[Docker Init] Initializing tw_logs database structure..."
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" tw_logs < /source_sql/_structure_logs.sql
echo "[Docker Init] tw_logs structure successfully initialized!"
