#!/bin/bash
# © 2023 Denys Lukashenko denlukasdev@gmail.com
set -e

# Setup list of database dumps to database
function setupDump {
  echo "INFO: Start setup database dump"
  docker exec -i "${PROJECT_TAG}_mysql" mysql -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_DATABASE}" <"$1" &&
    echo "INFO: Finish setup database dump"
}

# Create dump of database
function createDump {
  echo "INFO: Start database dump creating"
  if [ -n "$1" ]; then
    path="$1"
  else
    path="$initLocation"
  fi
  echo "$path/${DB_DATABASE}.sql"
  id=$(date +'%d_%m_%Y_%H_%M_%S')
  docker exec "${PROJECT_TAG}_mysql" mysqldump -u"${DB_USER}" -p"${DB_PASSWORD}" -h "${PROJECT_TAG}"_mysql "${DB_DATABASE}" >"$path/${DB_DATABASE}_$id.sql" &&
    echo "INFO: Finish database dump"
}

# Go into mysql database of application
function intoDatabase {
  docker exec -it "$PROJECT_TAG""_mysql" mysql -u"$DB_USER" -p"$DB_PASSWORD" "$DB_DATABASE"
}
