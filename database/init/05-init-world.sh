#!/bin/bash
set -e

echo "[Docker Init] Importing tw_world database from tw_world.sql..."
echo "[Docker Init] Note: Importing 191MB SQL dump may take 15-30 seconds on initial startup..."
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" tw_world < /docker-entrypoint-initdb.d/source_sql/tw_world.sql
echo "[Docker Init] tw_world database import completed successfully!"
