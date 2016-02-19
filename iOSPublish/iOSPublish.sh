#!/bin/bash

function failed() {
    echo "Failed: $@" >&2
    exit 1
}

if [[ $# -ne 1 ]]; then
  echo USAGE:
  echo iOSPublish.sh [config file path]
  exit 1
fi

if [[ ! -f $1 ]]; then
  failed "wrong file $1"
fi

echo config file path is: $1

# 当前目录
CURRENT_DIR=${PWD}

SCRIPT_DIR_RELATIVE=`dirname $0`

# 脚本所在目录
SCRIPT_DIR=`cd ${SCRIPT_DIR_RELATIVE};pwd`

echo SCRIPT_DIR:${SCRIPT_DIR}

# 读取配置
source ${SCRIPT_DIR}/iOSPublish.default.config
source $1

if [[ ! -d ${PROJECT_DIR} ]]; then
  failed "PROJECT_DIR:${PROJECT_DIR}"
fi
echo "PROJECT_DIR:${PROJECT_DIR}"

mkdir -pv ${APP_DIR} || failed "mkdir ${APP_DIR}"
echo "APP_DIR:${APP_DIR}"

if [[ ! -f ${APP_PLIST_PATH} ]]; then
  failed "${APP_PLIST_PATH} is not existed"
fi

APP_BUILD=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${APP_PLIST_PATH}`
APP_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${APP_PLIST_PATH}`
echo "APP_VERSION:${APP_VERSION}"
echo "APP_BUILD:${APP_BUILD}"

# ipa和xcarchive文件最终存储路径
APP_SAVE_DIR=${APP_DIR}/${APP_NAME}_${CONFIGURATION}_V${APP_VERSION}_B${APP_BUILD}
if [[ -d ${APP_SAVE_DIR} ]]; then
  failed "${APP_SAVE_DIR} is existed,please modify build!"
fi

mkdir -pv ${APP_SAVE_DIR} || failed "mkdir ${APP_SAVE_DIR}"
echo "APP_SAVE_DIR:${APP_SAVE_DIR}"

cd ${PROJECT_DIR}

# clean
if [[ ${WILL_CLEAN} -gt 0 ]]; then
  xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace -scheme ${SCHEME_NAME} -sdk ${SDK_VERSION} -configuration ${CONFIGURATION} ONLY_ACTIVE_ARCH=NO clean || failed "xcodebuild clean"
fi

# archive
# .xcarchive 文件临时存储路径
TEMP_ARCHIVE_PATH=${APP_DIR}/${APP_NAME}.xcarchive
if [[ ${WILL_ARCHIVE} -gt 0 ]]; then
  rm -rf ${TEMP_ARCHIVE_PATH}
  xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace -scheme ${SCHEME_NAME} -sdk ${SDK_VERSION} -configuration ${CONFIGURATION} -destination ${ARCHIVE_DESTINATION} -archivePath ${TEMP_ARCHIVE_PATH} ONLY_ACTIVE_ARCH=NO archive || failed "xcodebuild archive"
fi

# export ipa
# .ipa 文件临时存储路径
TEMP_APP_PATH=${APP_DIR}/${APP_NAME}.ipa
if [[ ${WILL_EXPORT_IPA} -gt 0 ]]; then
  rm -rf ${TEMP_APP_PATH}
  xcodebuild -exportArchive -archivePath ${TEMP_ARCHIVE_PATH} -exportPath ${APP_DIR}/${APP_NAME} -exportProvisioningProfile "${PROFILE_NAME}" -exportFormat ipa -verbose || failed "xcodebuild export archive"
fi

# upload to fir.im
if [[ ${WILL_FIR_IM} -gt 0 ]]; then
  SCRIPT="fir publish ${TEMP_APP_PATH} -T ${FIR_TOKEN} -c ${FIR_UPDATE_LOG}"
  echo "${SCRIPT}"
  ${SCRIPT} || failed "fir publish"
fi

# save ipa and xcarchive
if [[ ${WILL_SAVE} -gt 0 ]]; then
    mkdir -pv ${APP_SAVE_DIR} || failed "mkdir ${APP_SAVE_DIR}"
    mv ${TEMP_ARCHIVE_PATH} ${APP_SAVE_DIR}/
    mv -v ${TEMP_APP_PATH} ${APP_SAVE_DIR}/
else
    WILL_BAIDU_SYMBOL=0
fi

# 百度统计工具目录
BAIDU_SYMBOL_TOOL_DIR=${SCRIPT_DIR}/BaiduSymbolTool

# 制作百度统计需要的文件
if [[ ${WILL_BAIDU_SYMBOL} -gt 0 ]]; then
    cp -rf ${BAIDU_SYMBOL_TOOL_DIR}/* ${APP_SAVE_DIR}/
    cd ${APP_SAVE_DIR}
    SCRIPT="BaiduSymbolTool ${APP_NAME}.xcarchive/dSYMs/${APP_NAME}.app.dSYM/Contents/Resources/DWARF/${APP_NAME}"
    echo "${SCRIPT}"
    ${SCRIPT} || failed "BaiduSymbolTool"
    echo "${PWD}/`ls *.zip|head -n 1`"
fi

cd ${CURRENT_DIR}
echo "done..."
