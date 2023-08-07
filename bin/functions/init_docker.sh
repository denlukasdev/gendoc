#!/bin/bash
set -e

pathToDockerFolder="$initLocation/docker"
nodeDockerName="docker_nodejs"
beDockerName="docker_be"

function initDocker {
#exit
  # Generate NodeJS docker if configured
  if [ "$GEN_NODE" = 1 ]; then
    generateDocker "$initLocation/bin/docker_sample_nodejs" "$initLocation/$nodeDockerName"
  fi

  # Generate backend docker if configured
  if [ "$GEN_BACKEND" = 1 ]; then
    generateDocker "$initLocation/bin/docker_sample_be" "$initLocation/$beDockerName"
  fi
}

function generateDocker {
  pathToDockerSampleFolder=$1
  pathToDockerFolder=$2
  echo $pathToDockerFolder
  # Remove old docker if exist and copy new from sample
  removeOldDocker "$pathToDockerFolder"
  cp -rf "$pathToDockerSampleFolder" "$pathToDockerFolder"
  # Create .gitignore file
  echo "*" > "$pathToDockerFolder/.gitignore"
  # Copy bash functions
  cp "$initLocation/bin/gendoc" "$pathToDockerFolder/act"
  echo "INFO: New docker folder $pathToDockerFolder created."

  # Replace variables in file to env variables
  replaceVariables
}

function removeOldDocker {
  while true; do
    read -p "Old generated docker $1 will be removed. Continue? (Y/n) " yn
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

  # Check and set current Xdebug version, if not exists
  if [[ -z ${envVars["XDEBUG_VERSION"]} ]]; then
    # If XDEBUG_VERSION does not exist, add it to envVars with empty string value ""
    envVars["XDEBUG_VERSION"]=""
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
