#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Azure login
az account show &>/dev/null || az login

# Check if the current cluster is an AKS cluster
current_context=$(kubectl config current-context)
if ! [[ $current_context == *"aks"* ]]; then
  echo "You are currently not connected to an AKS cluster!"
  exit 1
fi

# Uninstall T2-Project
source $K8S_DIR/stop.sh

# Delete cluster
terraform -chdir=./environments/azure/ destroy -auto-approve
