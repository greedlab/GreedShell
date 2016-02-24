#!/bin/bash
# Auth:bell@greedlab.com

# config
INPUT_STRING=""
OUTPUT_STRING=""
FILE_SUFFIX=""
TARGET_DIR=./

function usage() {
  echo "Usage: args [-i] <INPUT_STRING> [-o] <OUTPUT_STRING> -f <FILE_SUFFIX> [-t] <TARGET_DIR>"
  echo "-i input string"
  echo "-o output string"
  echo "-f file suffixes,split with \",\" . eg \"h,m\" . default all files"
  echo "-t target directory。default \"./\""
  echo "-h help"
  echo "Example: replace.sh -i \"input string\" -o \"output string\" -f \"h,m\""
  exit 1
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
  echo failed:$0 $*
  usage
fi

if [[ -z ${OUTPUT_STRING} ]]; then
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

find ${TARGET_DIR} -name "${filter_name}" | xargs -n 1 -t sed -i "" "s/${INPUT_STRING}/${OUTPUT_STRING}/g"
