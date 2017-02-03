#!/bin/bash

set -e # fail fast
set -x # print commands

echo "================ in shell script (parse_tempest_logs.sh) ================"

RESOURCE_VER=$(cat git-resource_semver/version)

env
find .

apt-get update
apt-get -y install git python3 python3-jinja2

cp git-resource_osp/08.tempest/scripts/{template.html,tempest_parser.py} ./
cp git-resource_build/${RESOURCE_VER}/ra-out.txt ./
python3 tempest_parser.py
mv tempest_output.html tempest.html

git clone git-resource_test-result tempest_parsed_result

if [ -d tempest_parsed_result/${RESOURCE_VER} ]; then
    rm -rf tempest_parsed_result/${RESOURCE_VER}
    cd tempest_parsed_result
    git config --global user.email "nobody@concourse.ci"
    git config --global user.name "Concourse"
    git add -A
    git commit -m "Clean garbage file version ${RESOURCE_VER}"
    cd -
fi

mkdir -p tempest_parsed_result/${RESOURCE_VER}
cp tempest.html ra-out.txt tempest_parsed_result/${RESOURCE_VER}/
cd tempest_parsed_result
git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"
git add .
git commit -m "Tempest output version ${RESOURCE_VER}"
cd -

# 移除 build branch 中所有的檔案 (不需要)
git clone git-resource_build git-resource_build_clean
cd git-resource_build_clean
rm -rf *
echo "new branch - build" > README.md
#rm -rf git-resource_build_clean/${RESOURCE_VER}
cd git-resource_build_clean
git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"
git add .
git commit -m "Clean Tempest Build version ${RESOURCE_VER}"
cd -

find .

echo "Parse Finished!"