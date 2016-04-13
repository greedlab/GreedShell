#!/bin/bash
#Auth bell@greedlab.com

function usage() {
  echo "Usage: clangFormat.sh <target directory> default ./ "
  echo "-h help"
  echo "Example: clangFormat.sh ./"
  exit 1
}

function format() {
  clang-format $0 > .format_temp
  cat .format_temp > $0
}

while getopts h opt; do
    case $opt in
        h)
        usage;;
    esac
done

if [[ $# -gt 1 ]]; then
  usage
fi

# 脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

# 目标目录
TARGET_DIR=./

if [[ $# -eq 1 ]]; then
  TARGET_DIR=$1
fi

if [[ ! -d ${TARGET_DIR} ]]; then
  echo "TARGET_DIR:${PROJECT_DIR} is invalid"
  exit 1
fi

# 检测是否已经安装clang-format
command -v clang-format >/dev/null 2>&1 || brew install clang-format

export -f format
find ${TARGET_DIR} -name *.[h.m.mm] | xargs -n 1 -t  bash -c 'format "$@"'

rm -rf .format_temp
