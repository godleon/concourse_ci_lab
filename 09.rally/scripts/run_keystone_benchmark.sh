#!/bin/bash

set -e # fail fast
set -x # print commands

echo "In scripts/run_keystone_benchmark.sh"

rally-manage db recreate

rally deployment create --fromenv --name=existing

#source ~/.rally/openrc

#rally deployment check

openstack image list

openstack flavor list
