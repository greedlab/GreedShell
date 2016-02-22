#!/bin/bash
# Auth:bell@greedlab.com

function usage() {
  echo "Usage: getAppBuild.sh [-p <plist file path>]"
  echo "Options:"
  echo "-p plist file path"
  echo "-h help"
  echo "Example:"
  echo "replace.sh -i 'input string' -o 'output string' -f 'm'"
  exit 1
}

PLIST_FILE_PATH=""
while getopts p:h opt; do
    case $opt in
        p)
        PLIST_FILE_PATH=$OPTARG;;
        h)
        usage;;
        \?)
        usage;;
    esac
done

if [[ -f ${PLIST_FILE_PATH} ]]; then
  app_build=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${PLIST_FILE_PATH}`
  if [[ -n ${app_build} ]]; then
    echo ${app_build}
  else
    exit 1
  fi
else
  exit 2
fi
