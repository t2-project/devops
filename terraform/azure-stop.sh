#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

# Delete cluster
terraform -chdir=./environments/azure/ destroy -auto-approve
