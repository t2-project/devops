#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Setup kind cluster
terraform -chdir=./environments/kind/ init -upgrade
terraform -chdir=./environments/kind/ apply -auto-approve

# Install T2-Project
source $K8S_DIR/start.sh
