#!/bin/bash
# © 2023 Denys Lukashenko denlukasdev@gmail.com
set -e

# Start docker compose
function dockerStart {
  docker-compose -f "$initLocation/docker-compose.yml" up -d &&
    dockerContainersLog
}

# Rebuild and start docker compose
function dockerRebuild() {
  docker builder prune && docker-compose -f "$initLocation/docker-compose.yml" up -d --build &&
    dockerContainersLog
}

# Stop docker compose
function dockerStop() {
  docker-compose -f "$initLocation/docker-compose.yml" stop
}

# Delete docker containers
function dockerContainersDelete() {
  docker-compose -f "$initLocation/docker-compose.yml" rm
}

# Show containers status list
function dockerContainersStatus() {
  docker-compose -f "$initLocation/docker-compose.yml" ps
}

# Show containers log
function dockerContainersLog() {
  docker-compose -f "$initLocation/docker-compose.yml" logs -f
}
