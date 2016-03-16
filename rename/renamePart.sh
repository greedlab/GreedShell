#!/bin/bash
# Auth:bell@greedlab.com

# config
INPUT_PART_OF_FILE_NAME=""
OUTPUT_PART_OF_FILE_NAME=""
FILE_SUFFIX=""
TARGET_DIR=./

function usage() {
  echo "Usage: args [-i] <INPUT_PART_OF_FILE_NAME> [-o] <OUTPUT_PART_OF_FILE_NAME> -f <FILE_SUFFIX> [-t] <TARGET_DIR>"
  echo "-i input part of file name"
  echo "-o output part of file name"
  echo "-t target directory。default ./"
  echo "-f file suffixes,split with \",\" . eg \"h,m\" . default all files"
  echo "-h help"
  echo "Example: rename.sh -i input -o output -f h,m -t ./"
  exit 1
}

while getopts i:o:t:f:h opt; do
    case $opt in
        i)
        INPUT_PART_OF_FILE_NAME=$OPTARG;;
        o)
        OUTPUT_PART_OF_FILE_NAME=$OPTARG;;
        t)
        TARGET_DIR=$OPTARG;;
        f)
        FILE_SUFFIX=$OPTARG;;
        h)
        usage;;
        \?)
        usage;;
    esac
done

if [[ -z ${INPUT_PART_OF_FILE_NAME} ]]; then
  echo failed:$0 $*
  usage
fi

if [[ -z ${OUTPUT_PART_OF_FILE_NAME} ]]; then
  echo failed:$0 $*
  usage
fi

if [[ ! -d ${TARGET_DIR} ]]; then
  echo failed:$0 $*
  usage
fi

filter_name=\*
if [[ -n ${FILE_SUFFIX} ]]; then
  filter_name=\*.[${FILE_SUFFIX}]
fi

find ${TARGET_DIR} -name "${filter_name}" | xargs -n 1 -t rename -S "${INPUT_PART_OF_FILE_NAME}" "${OUTPUT_PART_OF_FILE_NAME}"
