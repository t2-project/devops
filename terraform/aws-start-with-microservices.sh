#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Use optional argument as the namespace for the T2-Project
if [ $# -gt 0 ]; then
    T2_NAMESPACE=$1
else
    T2_NAMESPACE="default"
fi

# Create cluster
source ./aws-start.sh

# Install T2-Project
source $K8S_DIR/start-microservices.sh $T2_NAMESPACE

# Use AWS Load Balancer to expose the UI
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-ui.yaml -n $T2_NAMESPACE
until kubectl get service/ui-nlb -n $T2_NAMESPACE --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
export UI_HOSTNAME=$(kubectl get service/ui-nlb -n $T2_NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo -e "\nUI URL: http://${UI_HOSTNAME}\n"
