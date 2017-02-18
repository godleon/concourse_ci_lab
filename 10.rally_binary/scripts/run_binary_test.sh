#!/bin/bash

set -e # fail fast
set -x # print commands

sudo apt-get update >/dev/null
sudo apt-get -y install git >/dev/null
sudo git clone rally_test rally_remain_tests
sudo git clone github_page rally_test_output

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
    PATH_OUTPUT="${ENTRY_PATH}/rally_test_output/${RESOURCE_VER}/${CATE_NAME}"
    sudo mkdir -p ${PATH_OUTPUT}
    cat ${CUR_TEST}
    echo ""
    rally task start --abort-on-sla-failure ${CUR_TEST}
    #sudo rally task report --out ${PATH_OUTPUT}/${TEST_NAME%.json}.html
    #rally task results | sudo tee ${PATH_OUTPUT}/${TEST_NAME} >/dev/null
fi