#!/bin/bash
set -e

# Start docker compose
function dockerStart {
  docker-compose -f "$initLocation/docker/docker-compose.yml" up
}

# Rebuild and start docker compose
function dockerRebuild() {
  docker builder prune && docker-compose -f "$initLocation/docker/docker-compose.yml" up -d --build
}

# Stop docker compose
function dockerStop() {
  docker-compose -f "$initLocation/docker/docker-compose.yml" stop
}

# Delete docker containers
function dockerContainersDelete() {
  docker-compose -f "$initLocation/docker/docker-compose.yml" rm
}

# Show containers status list
function dockerContainersStatus() {
  docker-compose -f "$initLocation/docker/docker-compose.yml" ps
}

