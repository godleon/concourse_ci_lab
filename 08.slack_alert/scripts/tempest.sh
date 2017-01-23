#!/bin/bash

set -e # fail fast
set -x # print commands

echo "================ in shell script ================"
find .
echo "ANSIBLE_HOST_KEY_CHECKING = ${ANSIBLE_HOST_KEY_CHECKING}"
echo "Finished!"
# echo "OS_AUTH_URL = ${OS_AUTH_URL}"
# source $1
# echo "OS_AUTH_URL = ${OS_AUTH_URL}"
# echo "version = $(cat $2)"
# echo "$(date) => Tempest Result Link: https://godleon.github.io/osp_test_results/$(cat $2)/tempest_output.html" > $3
# echo "finished"