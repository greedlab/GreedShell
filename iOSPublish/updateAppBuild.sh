#!/bin/bash
# Auth:bell@greedlab.com
# 更新传入`app build`,`plist文件路径`，返回+1的app build

function usage() {
  echo "Introduction: get +1 app build"
  echo "Usage: updateAppBuild.sh [-p <plist file path>] [-b <app build>]"
  echo "Options:"
  echo "-b app build"
  echo "-p plist file path"
  echo "-h help"
  echo "Example:"
  echo "replace.sh -i 'input string' -o 'output string' -f 'm'"
  exit 1
}

function failed() {
  echo "Failed: $@" >&2
  exit 1
}

function checkInt(){
  expr $1 + 0 &>/dev/null
  [ $? -ne 0 ] && { echo "$1 must be integer!";exit 1; }
}

APP_BUILD=""
PLIST_FILE_PATH=""
while getopts b:p:h opt; do
    case $opt in
        b)
        APP_BUILD=$OPTARG;;
        p)
        PLIST_FILE_PATH=$OPTARG;;
        h)
        usage;;
        \?)
        usage;;
    esac
done

if [[ -z ${APP_BUILD} ]]; then
  echo "failed:$0 $*"
  exit 2
fi

if [[ ! -f ${PLIST_FILE_PATH} ]]; then
  echo "failed:$0 $*"
  exit 2
fi

APP_BUILD_NEW=""
if [[ ${APP_BUILD} =~ "." ]]; then
  echo "app build have ."
  app_build_tail=${APP_BUILD##*.}
  app_build_head=${APP_BUILD%.*}
  checkInt ${app_build_tail}
  app_build_tail_new=`expr ${app_build_tail} + 1 || failed ""`
  APP_BUILD_NEW=${app_build_head}.${app_build_tail_new}
else
  echo "app build do not have ."
  checkInt ${APP_BUILD}
  APP_BUILD_NEW=`expr ${APP_BUILD} + 1`
fi
/usr/libexec/plistbuddy -c "Set CFBundleVersion ${APP_BUILD_NEW}" ${PLIST_FILE_PATH}
echo "new build: ${APP_BUILD_NEW}"
