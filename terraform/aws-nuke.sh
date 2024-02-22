#!/bin/bash

set -e

REGION=eu-north-1

export DISABLE_TELEMETRY=true

if ! which cloud-nuke
then
  echo "cloud-nuke is not installed!"
  exit 1
fi

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

# You get asked before it actually deletes everything
cloud-nuke aws --region $REGION
