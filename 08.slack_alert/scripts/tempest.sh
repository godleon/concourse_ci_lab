#!/bin/bash

echo "================ in shell script ================"
echo "OS_AUTH_URL = ${OS_AUTH_URL}"
source $1
echo "OS_AUTH_URL = ${OS_AUTH_URL}"
echo "version = $(cat $2)"
echo "Hello Slack! $(date)" > $3
echo "finished"