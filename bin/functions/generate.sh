#!/bin/bash
# © 2023 Denys Lukashenko denlukasdev@gmail.com
set -e

pathToDockerFolder="$initLocation/docker"

function generateDocker {
  pathToDockerSampleFolder=$1
  pathToDockerFolder=$2
  type=$3
  # Remove old docker if exist and copy new from sample
  removeOldDocker "$pathToDockerFolder"
  cp -rf "$pathToDockerSampleFolder" "$pathToDockerFolder"

  echo "INFO: New docker folder $pathToDockerFolder created."

  # Replace variables in file to env variables
  replaceVariables

  # Create additional files
  createAdditionalFiles

  # Copy bash functions
  copyScripts
}

function removeOldDocker {
  while true; do
    read -p "Old generated docker $1 will be removed. Continue? (Y/n) " yn
    case $yn in
    [nN])
      echo "Docker generate canceled."
      exit
      ;;
    [yY] | "")
      if [ -z "$yn" ]; then
        echo "No input provided. Assuming Yes."
      fi
      rm -rf "$1"
      break
      ;;
    *)
      echo "Invalid input"
      ;;
    esac

  done
}

function replaceVariables {
  echo "INFO: Start replaceVariables"

  # Get all file paths in directory
  filePaths=$(find "$pathToDockerFolder" -type f)

  # Get env variables to array
  declare -A envVars=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Ignore comments and empty lines
    if [[ ! "$line" =~ ^\s*(#|$) ]]; then
      # Extract variable name and value
      varName="${line%%=*}"
      varValue="${line#*=}"
      # Add variable to associative array
      envVars["$varName"]="$varValue"
    fi
  done <"$pathToDockerEnvFile"

  # Check PHP version and set relevant Xdebug version
  envVars["XDEBUG_VERSION"]=""
  if [[ $(echo "${envVars["PHP_VERSION"]} < 8" | bc) = 1 ]]; then
    # If XDEBUG_VERSION does not exist, add it to envVars with empty string value ""
    envVars["XDEBUG_VERSION"]="-2.9.8"
  fi

  # Iterate through file paths
  for filePath in $filePaths; do
    # Iterate through env variables for replace in file
    for varKey in "${!envVars[@]}"; do
      oldWord="{~$varKey~}"
      newWord=${envVars[$varKey]}
      awk -v search="$oldWord" -v replace="$newWord" '{ gsub(search, replace) }1' "$filePath" >"${filePath}.tmp"
      mv "${filePath}.tmp" "$filePath"
    done
  done
  echo "INFO: Finish replaceVariables"
}

function copyScripts {
  cp -p "$initLocation/bin/docker_act" "$pathToDockerFolder/act" && chmod +x "$pathToDockerFolder/act"
  mkdir "$pathToDockerFolder/functions" &&
    cp "$initLocation/bin/functions/application.sh" "$pathToDockerFolder/functions" &&
    cp "$initLocation/bin/functions/docker.sh" "$pathToDockerFolder/functions"

  # Copy database functions for backend
  if [ "$type" = "be" ]; then
    cp "$initLocation/bin/functions/database.sh" "$pathToDockerFolder/functions"
  fi
}

function createAdditionalFiles {
  # Create .gitignore file
  echo "*" >"$pathToDockerFolder/.gitignore"

  # Create base env variables
  echo "PROJECT_NAME=$PROJECT_NAME" >"$pathToDockerFolder/.env"

  # Add env variables for nodejs
  if [ "$type" = "nodejs" ]; then
    echo "# Ports could be changed after generate
PORT_NODE_INT=$PORT_NODE_INT
PORT_NODE_EXT=$PORT_NODE_EXT" >>"$pathToDockerFolder/.env"
  fi

  # Add env variables for be
  if [ "$type" = "be" ]; then
    echo "BASE_BE_URL=$BASE_BE_URL
# Ports could be changed after generate
PHP_VERSION=$PHP_VERSION
PORT_NGINX=$PORT_NGINX
PORT_PHP_FPM=$PORT_PHP_FPM
PORT_DB=$PORT_DB
PORT_MYADMIN=$PORT_MYADMIN
# Database variables could be changed after generate
DB_ROOT_PASSWORD=$DB_ROOT_PASSWORD
DB_DATABASE=$DB_DATABASE
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD" >>"$pathToDockerFolder/.env"
  fi
}
