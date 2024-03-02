#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)
PROMETHEUS_DIR=$(builtin cd $MY_DIR/../prometheus; pwd)

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

# Uninstall T2-Project
$K8S_DIR/stop-microservices.sh

kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml
helm uninstall aws-load-balancer-controller -n kube-system

$PROMETHEUS_DIR/uninstall.sh

# Delete EKS Cluster (disable nodegroup eviction is required because aws-ebs-csi-driver wouldn't allow the deletion otherwise)
eksctl delete cluster --config-file eks-cluster-config-basic.yaml --disable-nodegroup-eviction
