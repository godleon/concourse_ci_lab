#!/bin/bash

set -e # fail fast
set -x # print commands

ENTRY_PATH=$(pwd)
RESOURCE_VER=$(cat git_semver/version)

whoami
env

sudo apt-get update
sudo apt-get -y install git
sudo git clone rally_test rally_remain_tests

cd ${HOME}

rally-manage db recreate
rally deployment create --fromenv --name=existing
rally deployment check

openstack image list
openstack flavor list

REMAIN_TEST_COUNT=$(find ${ENTRY_PATH}/rally_remain_tests/ -type f -name '*.json' | wc -l)
if [ ${REMAIN_TEST_COUNT} -gt 0 ]; then
    CUR_TEST=$(find ${ENTRY_PATH}/rally_remain_tests/ -type f -name '*.json' | sort | head -1)
    sudo rm ${CUR_TEST}
    cd ${ENTRY_PATH}/rally_remain_tests
    echo "${CUR_TEST}" | sudo tee -a finished_tests
    sudo git config --global user.email "nobody@concourse.ci"
    sudo git config --global user.name "Concourse"
    sudo git add .
    sudo git commit -m "Finished Rally test(${CUR_TEST##*/}) - version ${RESOURCE_VER}"
    cd -
fi

env

# sudo rally task start --abort-on-sla-failure current_test.json
# sudo rally task report --out $(cat current_test_name | cut -d: -f1).html
# find .
# sudo rally task results | sudo tee rally_result.json

find ${ENTRY_PATH}