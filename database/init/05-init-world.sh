#!/bin/bash
set -e

echo "[Docker Init] Importing tw_world database from tw_world.sql..."
echo "[Docker Init] Note: Importing 191MB SQL dump may take 15-30 seconds on initial startup..."
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" tw_world < /source_sql/tw_world.sql

echo "[Docker Init] Ensuring player_premade_item_template exists..."
mysql -u root -p"${MARIADB_ROOT_PASSWORD}" tw_world -e "
CREATE TABLE IF NOT EXISTS player_premade_item_template (
  entry INT(10) UNSIGNED NOT NULL DEFAULT 0,
  class TINYINT(3) UNSIGNED NOT NULL DEFAULT 0,
  level TINYINT(3) UNSIGNED NOT NULL DEFAULT 0,
  role TINYINT(3) UNSIGNED NOT NULL DEFAULT 0,
  name VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (entry)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
"
echo "[Docker Init] tw_world database import completed successfully!"
