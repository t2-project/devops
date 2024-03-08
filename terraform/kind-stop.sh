#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Always run from the location of this script
cd $MY_DIR

# Check if the cluster is a "kind" cluster
current_context=$(kubectl config current-context)
if ! [[ $current_context == *"kind"* ]]; then
  echo "You are currently not connected to a kind cluster!"
  exit 1
fi

# Delete kind cluster
terraform -chdir=./environments/kind/ destroy -auto-approve
