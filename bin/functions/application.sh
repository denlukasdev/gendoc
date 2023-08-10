#!/bin/bash
set -e

# Go into back-end PHP container to application folder or execute command from outside
function intoBackend {
  if [ -z "$*" ]; then
    docker exec -it "$PROJECT_NAME""_php_fpm" bash
  else
    docker exec -it "$PROJECT_NAME""_php_fpm" sh -c "$*"
  fi
}

# Go into frontend-end nodeJS container to application folder or execute command from outside
function intoFrontend {
  if [ -z "$*" ]; then
    docker exec -it "$PROJECT_NAME""_nodejs" /bin/sh
  else
    docker exec -it "$PROJECT_NAME""_nodejs"  sh -c "$*"
  fi
}

