#!/bin/bash
# Auth:bell@greedlab.com

INPUT_FILE_NAME=""
OUTPUT_FILE_NAME=""
TARGET_DIR=./

function usage() {
  echo "Usage: args [-i] <INPUT_FILE_NAME> [-o] <OUTPUT_FILE_NAME> -f <FILE_SUFFIX> [-t] <TARGET_DIR>"
  echo "-i input file name"
  echo "-o output file name"
  echo "-t target directory。default ./"
  echo "-h help"
  echo "EG: rename.sh -i 'input.h' -o 'output.h'"
  exit 1
}

function rename_files() {
    for target_file in $@
    do
      FILE_DIR=${target_file%/*}
      mv -v ${target_file} ${FILE_DIR}/${OUTPUT_FILE_NAME}
    done
}

while getopts i:o:t:h opt; do
    case $opt in
        i)
        INPUT_FILE_NAME=$OPTARG;;
        o)
        OUTPUT_FILE_NAME=$OPTARG;;
        t)
        TARGET_DIR=$OPTARG;;
        h)
        usage;;
        \?)
        usage;;
    esac
done

if [[ -z ${INPUT_FILE_NAME} ]]; then
  usage
fi

if [[ -z ${OUTPUT_FILE_NAME} ]]; then
  usage
fi

if [[ ! -d ${TARGET_DIR} ]]; then
  usage
fi

target_files=`find ${TARGET_DIR} -name ${INPUT_FILE_NAME}`
rename_files ${target_files}
