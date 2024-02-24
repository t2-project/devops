#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

# Check if the current cluster is an EKS cluster
current_context=$(kubectl config current-context)
if ! [[ $current_context == *"eks"* ]]; then
  echo "You are currently not connected to an EKS cluster!"
  exit 1
fi

# Delete Grafana service
kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml

# Uninstall T2-Project
source $K8S_DIR/stop.sh

# Delete cluster with Terraform
# It's necessary to remove access entry from state to avoid removing Terraform's permissions too soon
# before its finished cleaning up the resources it deployed inside the cluster
terraform -chdir=./environments/aws/ state rm 'module.eks.module.eks.aws_eks_access_entry.this["cluster_creator"]' || true
terraform -chdir=./environments/aws/ destroy -auto-approve
