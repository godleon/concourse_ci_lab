#!/bin/bash

PIPELINE_NAME="osp10_tempest"

echo -e "y" | fly -t lite destroy-pipeline -p osp10_tempest
echo -e "y" | fly -t lite set-pipeline -p osp10_tempest -c pipeline.yml
fly -t lite unpause-pipeline -p osp10_tempest