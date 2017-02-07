#!/bin/bash

echo "In scripts/run_keystone_benchmark.sh"

rally-manage db recreate

rally deployment create --fromenv --name=existing

rally deployment check

openstack image list

openstack flavor list
