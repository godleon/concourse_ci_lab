#!/bin/bash

pwd
echo "Hello Slack! $(date)" > osp_test_resource/07.slack_notification/slack_message.txt
find .
cat osp_test_resource/07.slack_notification/slack_message.txt
echo "finished"