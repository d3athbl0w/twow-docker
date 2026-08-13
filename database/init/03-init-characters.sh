#!/bin/bash
set -e

echo "[Docker Init] Initializing tw_char database structure..."
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" tw_char < /source_sql/_structure_characters.sql
echo "[Docker Init] tw_char structure successfully initialized!"
