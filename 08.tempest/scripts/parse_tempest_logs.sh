#!/bin/bash

set -e # fail fast
set -x # print commands

echo "================ in shell script (parse_tempest_logs.sh) ================"
env
find .

apt-get update
apt-get -y install git python3 python3-jinja2

git clone git-resource_build tempest_parsed_result

cp git-resource_osp/08.tempest/scripts/{template.html,tempest_parser.py} ./
cp tempest_parsed_result/$(cat git-resource_semver/version)/ra-out.txt ./
rm -rf tempest_parsed_result/$(cat git-resource_semver/version)
python3 tempest_parser.py

find .

git clone git-resource_test-result tempest_parsed_result
mkdir -p tempest_parsed_result/$(cat git-resource_semver/version)
cp tempest_output.html ra-out.txt tempest_parsed_result/$(cat git-resource_semver/version)/tempest.html

echo "Parse Finished!"