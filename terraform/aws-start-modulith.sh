#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Use optional argument as the namespace for the T2-Project
if [ $# -gt 0 ]; then
    NAMESPACE_MODULITH=$1
else
    NAMESPACE_MODULITH="default"
fi

# Create cluster
$MY_DIR/aws-start.sh

# Install T2-Project
$K8S_DIR/start-monolith.sh $NAMESPACE_MODULITH
