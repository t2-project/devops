#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"
K8S_DIR=$(builtin cd $MY_DIR/../../k8s; pwd)

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

# Uninstall T2-Project
source $K8S_DIR/uninstall.sh

helm uninstall aws-load-balancer-controller -n kube-system

# Delete EKS Cluster (disable nodegroup eviction is required because aws-ebs-csi-driver wouldn't allow the deletion otherwise)
eksctl delete cluster --config-file $MY_DIR/eks-cluster-config-basic.yaml --disable-nodegroup-eviction
