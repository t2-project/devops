#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

source $K8S_DIR/stop.sh

terraform -chdir=../terraform/ destroy -auto-approve
