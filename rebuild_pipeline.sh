#!/bin/bash

TEAM_NAME="lite"
PIPELINE_NAME=${1}
PIPELINE_FILE=${2}

echo -e "y" | fly -t ${TEAM_NAME} destroy-pipeline -p ${PIPELINE_NAME}
echo -e "y" | fly -t ${TEAM_NAME} set-pipeline -p ${PIPELINE_NAME} -c ${PIPELINE_FILE}
fly -t lite unpause-pipeline -p ${PIPELINE_NAME}