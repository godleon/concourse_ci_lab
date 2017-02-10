#!/bin/bash

set -e # fail fast
set -x # print commands

ENTRY_PATH=$(pwd)
RESOURCE_VER=$(cat git_semver/version)

whoami
env

sudo apt-get update
sudo apt-get -y install git

cd ${HOME}

rally-manage db recreate
rally deployment create --fromenv --name=existing
rally deployment check

openstack image list
openstack flavor list

REMAIN_TEST_COUNT=$(find ${ENTRY_PATH}/rally_test/ -type f -name '*.json' | wc -l)

CUR_TEST=$(find ${ENTRY_PATH}/rally_test/ -type f -name '*.json' | sort | head -1)

env

# sudo rally task start --abort-on-sla-failure current_test.json
# sudo rally task report --out $(cat current_test_name | cut -d: -f1).html
# find .
# sudo rally task results | sudo tee rally_result.json

find ${ENTRY_PATH}