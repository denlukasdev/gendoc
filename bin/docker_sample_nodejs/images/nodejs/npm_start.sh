#!/bin/bash
set -e

if [ -d "node_modules/" ]; then
  npm start
else
  npm install && npm start
fi
