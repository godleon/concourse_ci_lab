#!/bin/bash

echo "================ in shell script ================"
echo "OS_AUTH_URL = ${OS_AUTH_URL}"
source $1
echo "OS_AUTH_URL = ${OS_AUTH_URL}"
echo "version number = $(cat $2)"
# echo "Hello Slack! $(date)" > tempest_output/slack_message.txt
# echo "${BUILD_ID} => in shell script"
# find .
echo "finished"