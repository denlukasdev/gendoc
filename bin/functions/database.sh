#!/bin/bash
set -e

# Setup list of database dumps to database
function setupDump {
  echo "INFO: Start setup database dump"
  docker exec -i "${PROJECT_NAME}_mysql" mysql -u"${DB_USER}" -p"${DB_PASSWORD}" "${DB_DATABASE}" <"$1" &&
    echo "INFO: Finish setup database dump"
}

# Create dump of database
function createDump {
  echo "INFO: Start database dump creating"
  echo "$1${DB_DATABASE}.sql"
  id=$(date +'%d_%m_%Y_%H_%M_%S')
  docker exec "${PROJECT_NAME}_mysql" mysqldump -u"${DB_USER}" -p"${DB_PASSWORD}" -h "${PROJECT_NAME}"_mysql "${DB_DATABASE}" >"$1${DB_DATABASE}_$id.sql"  &&
    echo "INFO: Finish database dump"
}