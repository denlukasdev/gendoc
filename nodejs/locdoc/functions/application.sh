#!/bin/bash
# © 2023 Denys Lukashenko denlukasdev@gmail.com
set -e

# Go into frontend-end nodeJS container to application folder or execute command from outside
function intoFrontend {
  if [ -z "$*" ]; then
    docker exec -it "$PROJECT_TAG""_nodejs" /bin/sh
  else
    docker exec -it "$PROJECT_TAG""_nodejs"  sh -c "$*"
  fi
}

