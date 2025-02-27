#!/bin/bash
# © 2023 Denys Lukashenko denlukasdev@gmail.com
set -e

if [ -d "node_modules/" ]; then
  npm start
else
  npm install && npm start
fi
