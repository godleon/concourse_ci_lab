#!/bin/bash

set -e # fail fast
set -x # print commands

rally-manage db recreate

rally deployment create --fromenv --name=existing

#source ~/.rally/openrc

#rally deployment check

openstack image list

openstack flavor list
