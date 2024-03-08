#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Use optional argument as the namespace for the T2-Project
if [ $# -gt 0 ]; then
    NAMESPACE_MICROSERVICES=$1
    NAMESPACE_MODULITH=$2
else
    NAMESPACE_MICROSERVICES="default"
    NAMESPACE_MODULITH="default"
fi

# Check if the cluster is a "kind" cluster
current_context=$(kubectl config current-context)
if ! [[ $current_context == *"kind"* ]]; then
  echo "You are currently not connected to a kind cluster!"
  exit 1
fi

# Uninstall T2-Microservices
$K8S_DIR/stop-microservices.sh $NAMESPACE_MICROSERVICES

# Uninstall T2-Modulith
$K8S_DIR/stop-modulith.sh $NAMESPACE_MODULITH

# Delete kind cluster
$MY_DIR/kind-stop.sh
