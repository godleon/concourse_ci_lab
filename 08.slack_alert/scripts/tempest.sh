#!/bin/bash

set -e # fail fast
set -x # print commands

echo "================ in shell script ================"
env
find .
echo "ANSIBLE_HOST_KEY_CHECKING = ${ANSIBLE_HOST_KEY_CHECKING}"
echo "MyParam = ${MyParam}"
echo "Finished!"

git clone git-resource_test-result tempest_output
cat git-resource_semver/version
mkdir tempest_output/$(cat git-resource_semver/version)
cp git-resource_osp/08.slack_alert/scripts/tempest_output.html tempest_output/$(cat git-resource_semver/version)/tempest.html

git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"

git add .
git commit -m "Tempest output"

# echo "OS_AUTH_URL = ${OS_AUTH_URL}"
# source $1
# echo "OS_AUTH_URL = ${OS_AUTH_URL}"
# echo "version = $(cat $2)"
# echo "$(date) => Tempest Result Link: https://godleon.github.io/osp_test_results/$(cat $2)/tempest_output.html" > $3
# echo "finished"