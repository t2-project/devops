#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $MY_DIR

# Setup kind environment
terraform -chdir=./environments/kind/ init -upgrade
terraform -chdir=./environments/kind/ apply -target="module.kind" -auto-approve
terraform -chdir=./environments/kind/ apply -auto-approve
