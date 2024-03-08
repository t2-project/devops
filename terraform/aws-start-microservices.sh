#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Use optional argument as the namespace for the T2-Project
if [ $# -gt 0 ]; then
    NAMESPACE_MICROSERVICES=$1
else
    NAMESPACE_MICROSERVICES="default"
fi

# Create cluster
$MY_DIR/aws-start.sh

# Install T2-Project
$K8S_DIR/start-microservices.sh $NAMESPACE_MICROSERVICES

# Use AWS Load Balancer to expose the UI
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-ui.yaml -n $NAMESPACE_MICROSERVICES
until kubectl get service/ui-nlb -n $NAMESPACE_MICROSERVICES --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
export UI_HOSTNAME=$(kubectl get service/ui-nlb -n $NAMESPACE_MICROSERVICES -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo -e "\nUI URL: http://${UI_HOSTNAME}\n"
