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
sudo git clone rally_result rally_test_output

cd ${HOME}

rally-manage db recreate
rally deployment create --fromenv --name=existing
rally deployment check

openstack image list
openstack flavor list

REMAIN_TEST_COUNT=$(find ${ENTRY_PATH}/rally_remain_tests/ -type f -name '*.json' | wc -l)
if [ ${REMAIN_TEST_COUNT} -gt 0 ]; then
    CUR_TEST=$(find ${ENTRY_PATH}/rally_remain_tests/ -type f -name '*.json' | sort | head -1)
    TMP=${CUR_TEST%/*}
    CATE_NAME=${TMP##*/}
    TEST_NAME=${CUR_TEST##*/}

    # Run Rally test and generate output here!
    sudo mkdir -p ${ENTRY_PATH}/rally_test_output/${RESOURCE_VER}/${CATE_NAME}
    rally task start --abort-on-sla-failure ${CUR_TEST}
    sudo rally task report --out ${ENTRY_PATH}/rally_test_output/${RESOURCE_VER}/${CATE_NAME}/${TEST_NAME%.json}.html
    rally task results | tee ${ENTRY_PATH}/rally_test_output/${RESOURCE_VER}/${CATE_NAME}/${TEST_NAME}

    sudo rm ${CUR_TEST}
    cd ${ENTRY_PATH}/rally_remain_tests
    git status
    echo "${CUR_TEST}" | sudo tee -a finished_tests
    sudo git config --global user.email "nobody@concourse.ci"
    sudo git config --global user.name "Concourse"
    sudo git add .
    sudo git commit -m "Finished Rally test(${CATE_NAME}/${TEST_NAME}) - version ${RESOURCE_VER}"
    
    cd ${ENTRY_PATH}/rally_test_output
    git status
    sudo git config --global user.email "nobody@concourse.ci"
    sudo git config --global user.name "Concourse"
    sudo git add .
    sudo git commit -m "Rally test output(${CATE_NAME}/${TEST_NAME}) - version ${RESOURCE_VER}"
fi

env

# sudo rally task start --abort-on-sla-failure current_test.json
# sudo rally task report --out $(cat current_test_name | cut -d: -f1).html
# find .
# sudo rally task results | sudo tee rally_result.json

find ${ENTRY_PATH}