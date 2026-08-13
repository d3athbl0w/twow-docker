#!/bin/bash
set -e

echo "[Docker Init] Initializing tw_logon database structure..."
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" tw_logon < /docker-entrypoint-initdb.d/source_sql/_structure_logon.sql

echo "[Docker Init] Configuring default realmlist entry in tw_logon..."
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" tw_logon -e "
DELETE FROM realmlist WHERE id = 1;
INSERT INTO realmlist (id, name, address, port, icon, realmflags, timezone, allowedSecurityLevel, population, realmbuilds)
VALUES (1, 'TurtleWoW', '127.0.0.1', 8091, 1, 0, 1, 0, 0, '5875');
"
echo "[Docker Init] tw_logon structure and realmlist successfully initialized!"
