#!/bin/bash
# Auth:bell@greedlab.com

# config
TARGET_DIRECTORY=~/Library/MobileDevice/Provisioning\ Profiles/
TARGET_NAME=""
OUTPUT_PATH=""
CURRENT_DIRECTORY=${PWD}

function usage() {
  echo "Usage: args [-f] <TARGET_DIRECTORY> [-n] <TARGET_NAME> -o <OUTPUT_PATH>"
  echo "-d Provisioning Profile directory. default '~/Library/MobileDevice/Provisioning\ Profiles/*'"
  echo "-n Provisioning Profile name"
  echo "-o output file path. default ./<TARGET_NAME>.mobileprovision"
  echo "-h help"
  echo "Example: getProvisioningProfile.sh -n 'iOS Team Provisioning Profile: com.apple.example'"
  exit 1
}

while getopts d:n:o:h opt; do
    case $opt in
        d)
        TARGET_DIRECTORY=$OPTARG;;
        n)
        TARGET_NAME=$OPTARG;;
        o)
        OUTPUT_PATH=$OPTARG;;
        h)
        usage;;
        \?)
        usage;;
    esac
done

if [[ ! -d ${TARGET_DIRECTORY} ]]; then
  echo failed:${TARGET_DIRECTORY}
  usage
fi

if [[ -z ${TARGET_NAME} ]]; then
  echo failed:${TARGET_NAME}
  usage
fi

cd "${TARGET_DIRECTORY}"

# echo ${TARGET_NAME}
files=`ls -t |xargs -n 1 grep -l "${TARGET_NAME}" |head -1`
for file in ${files}
do
  # echo ${file}
  if [[ -z ${OUTPUT_PATH} ]]; then
    OUTPUT_PATH=${CURRENT_DIRECTORY}/${TARGET_NAME//\ /\_}.mobileprovision
  fi
  # echo ${OUTPUT_PATH}
  cp ${file} ${OUTPUT_PATH}
done

cd ${CURRENT_DIRECTORY}
