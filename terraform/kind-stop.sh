#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

current_context=$(kubectl config current-context)

# Check if the cluster name contains "kind"
if ! [[ $current_context == *"kind"* ]]; then
  echo "You are currently not connected to a kind cluster!"
  exit 1
fi

# Uninstall T2-Project
source $K8S_DIR/stop.sh

# Delete kind cluster
terraform -chdir=./ destroy -auto-approve
