#!/bin/bash

set -e # fail fast
set -x # print commands

echo "================ in shell script (run_tempest.sh) ================"

subscription-manager register --username ${REDHAT_USER_NAME} --password ${REDHAT_USER_PWD} --autosubscribe
subscription-manager attach --pool=${REDHAT_REG_POOLID}
subscription-manager repos --disable=*
subscription-manager repos --enable=${REDHAT_REPO_ENABLED}

env
find .
echo "ANSIBLE_HOST_KEY_CHECKING = ${ANSIBLE_HOST_KEY_CHECKING}"
echo "REDHAT_USER_NAME = ${REDHAT_USER_NAME}"

yum -y install git
git clone git-resource_build tempest_output
cat git-resource_semver/version
mkdir -p tempest_output/$(cat git-resource_semver/version)
cp git-resource_osp/08.tempest/raw_logs/ra-out.txt tempest_output/$(cat git-resource_semver/version)/
#cp git-resource_osp/08.tempest/scripts/tempest.xz tempest_output/$(cat git-resource_semver/version)/

cd tempest_output
git config --global user.email "nobody@concourse.ci"
git config --global user.name "Concourse"
git add .
git commit -m "Tempest raw output version $(cat git-resource_semver/version)"

echo "OS_AUTH_URL = ${OS_AUTH_URL}"
source $1
echo "OS_AUTH_URL = ${OS_AUTH_URL}"
echo "version = $(cat $2)"
echo "$(date) => Tempest Result Link: https://godleon.github.io/osp_test_results/$(cat $2)/tempest_output.html" > $3
echo "finished"