#!/bin/bash

TEAM_NAME="lite"
PIPELINE_NAME="osp10_tempest"

echo -e "y" | fly -t ${TEAM_NAME} destroy-pipeline -p ${PIPELINE_NAME}
echo -e "y" | fly -t ${TEAM_NAME} set-pipeline -p ${PIPELINE_NAME} -c pipeline.yml
fly -t lite unpause-pipeline -p ${PIPELINE_NAME}