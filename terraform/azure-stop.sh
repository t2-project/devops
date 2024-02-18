#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

source $K8S_DIR/stop.sh

# Delete cluster
terraform workspace select azure
terraform -chdir=./ destroy -auto-approve
