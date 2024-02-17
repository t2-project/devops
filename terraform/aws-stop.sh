#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

# Delete Grafana service
kubectl delete $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml

# Uninstall T2-Project
source $K8S_DIR/stop.sh

# Delete Cluster
terraform -chdir=./ destroy -auto-approve
