#!/bin/bash

set -e # fail fast
set -x # print commands

echo "================ in shell script (parse_tempest_logs.sh) ================"
env
find .

apt-get update
apt-get -y install git python3 python3-jinja2

cp git-resource_osp/08.tempest/scripts/{template.html,tempest_parser.py} ./
cp git-resource_build/$(cat git-resource_semver/version)/ra-out.txt ./
python3 tempest_parser.py
git clone git-resource_test-result tempest_parsed_result
mkdir -p tempest_parsed_result/$(cat git-resource_semver/version)
cp tempest_output.html ra-out.txt tempest_parsed_result/$(cat git-resource_semver/version)/tempest.html

cd tempest_parsed_result
git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"
git add .
git commit -m "Tempest output version $(cat git-resource_semver/version)"
cd -

git clone git-resource_build git-resource_build_clean
rm -rf git-resource_build_clean/$(cat git-resource_semver/version)
cd git-resource_build_clean
git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"
git add .
git commit -m "Clean Tempest Build version $(cat git-resource_semver/version)"
cd -

find .

echo "Parse Finished!"