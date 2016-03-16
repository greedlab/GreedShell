#!/bin/bash
# Auth:bell@greedlab.com

# config
BLOG_MASTER_DIR=""
BLOG_GH_PAGES_DIR=""
CURRENT_DIR=${pwd}

function usage() {
  echo "Usage: gitbookPublish.sh [-m <local github master directory>] [-g <local github gh-pages directory>]"
  echo "publish gitbook to github"
  echo "Options:"
  echo "-m local github master directory"
  echo "-g local github gh-pages directory"
  echo "-h help"
  echo "Example: gitbookPublish.sh -m ~/ownCloud/blog -g ~/ownCloud/blog-gh-pages"
  exit 1
}

while getopts m:g:h opt; do
    case $opt in
        m)
        BLOG_MASTER_DIR=$OPTARG;;
        g)
        BLOG_GH_PAGES_DIR=$OPTARG;;
        h)
        usage;;
        \?)
        usage;;
    esac
done

if [[ ! -d ${BLOG_MASTER_DIR} ]]; then
  echo "BLOG_MASTER_DIR: ${BLOG_MASTER_DIR} is not existed"
  usage
  exit 2
fi

if [[ ! -d ${BLOG_GH_PAGES_DIR} ]]; then
  echo "BLOG_GH_PAGES_DIR: ${BLOG_GH_PAGES_DIR} is not existed"
  usage
  exit 2
fi

if [[ ${BLOG_MASTER_DIR} = ${BLOG_GH_PAGES_DIR} ]]; then
  echo "${BLOG_MASTER_DIR} is equal to ${BLOG_GH_PAGES_DIR}"
  exit 2
fi

# 删除_book
rm -rf ${BLOG_MASTER_DIR}/_book

# update SUMMARY.md
echo update SUMMARY.md
# book sm g -r ${BLOG_MASTER_DIR} -o ${BLOG_MASTER_DIR}/SUMMARY.md -n "By Blog" -i _book,Resource
cd ${BLOG_MASTER_DIR}
book sm g -n "By Blog" -i _book,Resource
cd ${CURRENT_DIR}

# copy SUMMARY.md to README.md
cat ${BLOG_MASTER_DIR}/SUMMARY.md > ${BLOG_MASTER_DIR}/README.md

# commit master branch
git -C ${BLOG_MASTER_DIR} fetch origin master || exit 1
git -C ${BLOG_MASTER_DIR} merge origin/master || exit 1
git -C ${BLOG_MASTER_DIR} add . --all || exit 1
git -C ${BLOG_MASTER_DIR} commit -a -m "update" || exit 1
git -C ${BLOG_MASTER_DIR} push || exit 1

cd ${BLOG_MASTER_DIR}

# update _book
echo update _book
gitbook build || exit 1

# update gh-pages branch
git -C ${BLOG_GH_PAGES_DIR} fetch origin gh-pages || exit 1
git -C ${BLOG_GH_PAGES_DIR} merge origin/gh-pages || exit 1

# 删除gh-pages下所有文件
rm -rf ${BLOG_GH_PAGES_DIR}/*

# 移动_book到-gh-pages分支
mv -v ${BLOG_MASTER_DIR}/_book/* ${BLOG_GH_PAGES_DIR}/

git -C ${BLOG_GH_PAGES_DIR} add . --all || exit 1
git -C ${BLOG_GH_PAGES_DIR} commit -a -m "update" || exit 1
git -C ${BLOG_GH_PAGES_DIR} push || exit 1

cd ${CURRENT_DIR}
