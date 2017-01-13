#!/bin/bash

find /
source env_var.list

echo "REDHAT_USERNAME=${REDHAT_USERNAME}"
echo "REDHAT_USERPASSWORD=${REDHAT_USERPASSWORD}"
echo "OS_AUTH_URL=${OS_AUTH_URL}"