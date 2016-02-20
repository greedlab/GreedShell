#!/bin/bash
# Auth:bell@greedlab.com

INPUT_STRING=""
OUTPUT_STRING=""
FILE_SUFFIX=""
TARGET_DIR=./

function usage() {
  echo "Usage: args [-i] <INPUT_STRING> [-o] <OUTPUT_STRING> -f <FILE_SUFFIX> [-t] <TARGET_DIR>"
  echo "-i input string"
  echo "-o output string"
  echo "-f file suffix。default all files"
  echo "-t target directory。default ./"
  echo "-h help"
  echo "EG: replace.sh -i 'input string' -o 'output string' -f 'm'"
  exit 1
}

function replace_files() {
    for target_file in $@
    do
      echo ${target_file}
      sed -i "" "s/${INPUT_STRING}/${OUTPUT_STRING}/g" ${target_file}
    done
}

while getopts i:o:f:t:h opt; do
    case $opt in
        i)
        INPUT_STRING=$OPTARG;;
        o)
        OUTPUT_STRING=$OPTARG;;
        f)
        FILE_SUFFIX=$OPTARG;;
        t)
        TARGET_DIR=$OPTARG;;
        h)
        usage;;
        \?)
        usage;;
    esac
done

if [[ -z ${INPUT_STRING} ]]; then
  usage
fi

if [[ -z ${OUTPUT_STRING} ]]; then
  usage
fi

if [[ ! -d ${TARGET_DIR} ]]; then
  usage
fi

target_files=""
if [[ -n ${FILE_SUFFIX} ]]; then
  target_files=`find ${TARGET_DIR} -name *.${FILE_SUFFIX}`
else
  target_files=`find ${TARGET_DIR} -name \*`
fi

replace_files ${target_files}
