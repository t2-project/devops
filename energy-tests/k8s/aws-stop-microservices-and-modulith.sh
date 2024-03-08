#!/bin/bash

NAMESPACE_MICROSERVICES=t2-microservices
NAMESPACE_MODULITH=t2-modulith

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TERRAFORM_DIR=$(builtin cd $MY_DIR/../../terraform; pwd)
K8S_DIR=$(builtin cd $MY_DIR/../../k8s; pwd)

if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "Terraform directory '$TERRAFORM_DIR' does not exist!"
    exit 1
fi
if [ ! -d "$K8S_DIR" ]; then
    echo "K8s directory '$K8S_DIR' does not exist!"
    exit 1
fi

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

# Delete load balancers
kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml
kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-uibackend.yaml -n $NAMESPACE_MICROSERVICES
kubectl delete -f $K8S_DIR/load-balancer/aws-loadbalancer-modulith-backend.yaml -n $NAMESPACE_MODULITH

# Uninstall T2-Microservices
kubectl delete -k $MY_DIR/t2-microservices/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MICROSERVICES
kubectl delete -k $MY_DIR/t2-microservices/ -n $NAMESPACE_MICROSERVICES
helm uninstall mongo-cart -n $NAMESPACE_MICROSERVICES
helm uninstall mongo-order -n $NAMESPACE_MICROSERVICES
helm uninstall kafka -n $NAMESPACE_MICROSERVICES
kubectl delete namespace $NAMESPACE_MICROSERVICES

# Uninstall T2-Modulith
kubectl delete -k $MY_DIR/t2-modulith/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MODULITH
kubectl delete -k $MY_DIR/t2-modulith/ -n $NAMESPACE_MODULITH
helm uninstall mongo -n $NAMESPACE_MODULITH
kubectl delete namespace $NAMESPACE_MODULITH

# Delete cluster with Terraform
$TERRAFORM_DIR/aws-stop.sh
