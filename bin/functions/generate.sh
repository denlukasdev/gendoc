#!/bin/bash
set -e

pathToDockerFolder="$initLocation/docker"
nodeDockerName="docker_nodejs"
beDockerName="docker_be"

function initDocker {
  # Generate NodeJS docker if configured
  if [ "$GEN_NODE" = 1 ]; then
    generateDocker "$initLocation/bin/docker_sample_nodejs" "$initLocation/$nodeDockerName"
  fi

  # Generate backend docker if configured
  if [ "$GEN_BACKEND" = 1 ]; then
    generateDocker "$initLocation/bin/docker_sample_be" "$initLocation/$beDockerName" &&
      # Copy database functions for backend
      cp "$initLocation/bin/functions/database.sh" "$initLocation/$beDockerName/functions"
  fi
}

function generateDocker {
  pathToDockerSampleFolder=$1
  pathToDockerFolder=$2
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
    read -p "Old generated docker $1 will be removed. Continue? (y/n) " yn
    case $yn in
    [yY])
      rm -rf $1
      break
      ;;
    [nN])
      echo Docker generate caneled.
      exit
      ;;
    *) echo invalid response ;;
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
  if [[ $(echo "${envVars["PHP_VERSION"]} < 8"| bc) = 1 ]]; then
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
}

function createAdditionalFiles {
  # Create .gitignore file
  echo "*" >"$pathToDockerFolder/.gitignore"
  cp "$pathToDockerEnvFile" "$pathToDockerFolder/.env"

}
