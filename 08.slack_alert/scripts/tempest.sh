#!/bin/bash

echo "================ in shell script ================"
source $1
echo ${OS_AUTH_URL}
# echo "Hello Slack! $(date)" > tempest_output/slack_message.txt
# echo "${BUILD_ID} => in shell script"
# find .
echo "finished"