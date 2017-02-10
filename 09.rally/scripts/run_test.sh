#!/bin/bash

set -e # fail fast
set -x # print commands

rally-manage db recreate
rally deployment create --fromenv --name=existing
rally deployment check

openstack image list
openstack flavor list

REMAIN_TEST_COUNT=$(find rally_test/ -type f -name '*.json' | wc -l)

CUR_TEST=$(find /home/godleon/Dropbox/Develop/CI-CD/concourse_ci_lab/09.rally/scripts/propagated_tests -type f -name '*.json' | sort | head -1)

env

# sudo rally task start --abort-on-sla-failure current_test.json
# sudo rally task report --out $(cat current_test_name | cut -d: -f1).html
# find .
# sudo rally task results | sudo tee rally_result.json

find .