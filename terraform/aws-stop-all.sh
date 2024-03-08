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

# Check if the current cluster is an EKS cluster
current_context=$(kubectl config current-context)
if ! [[ $current_context == *"eks"* ]]; then
  echo "You are currently not connected to an EKS cluster!"
  exit 1
fi

# Delete load balancers
kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml
kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-uibackend.yaml -n $NAMESPACE_MICROSERVICES
kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-modulith-backend.yaml -n $NAMESPACE_MODULITH

# Uninstall T2-Microservices
kubectl delete -k $K8S_DIR/t2-microservices/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MICROSERVICES
$K8S_DIR/stop-microservices.sh $NAMESPACE_MICROSERVICES

# Uninstall T2-Modulith
kubectl delete -k $MY_DIR/t2-modulith/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MODULITH
$K8S_DIR/stop-modulith.sh $NAMESPACE_MODULITH

# Delete cluster
$MY_DIR/aws-stop.sh
