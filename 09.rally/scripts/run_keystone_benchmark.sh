#!/bin/bash

set -e # fail fast
set -x # print commands

rally-manage db recreate
rally deployment create --fromenv --name=existing
rally deployment check

openstack image list
openstack flavor list


sudo apt-get -y install python3

cd git-osp/09.rally/scripts

touch current_test.json
touch current_test_name

touch consecutive_pass
cp rally_keystone_tests.json remain_tests.json

python3 git-osp/09.rally/scripts/rally_decide_test.py

rally task start --abort-on-sla-failure current_test.json
rally task report --out $(echo current_test_name).html
rally task results > rally_result.json

find .

python3 git-osp/09.rally/scripts/rally_process_result.py


cd -