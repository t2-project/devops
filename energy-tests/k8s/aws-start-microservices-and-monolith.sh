#!/bin/bash

NAMESPACE_MICROSERVICES=t2-microservices
NAMESPACE_MONOLITH=t2-monolith
ENABLE_INTENSIVE_COMPUTATION_SCENARIO=false

# Exit immediately if a command returns an error code
set -e

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

###############
# EKS Cluster #
###############

$TERRAFORM_DIR/aws-start.sh

##################
# T2 DEPLOYMENTS #
##################

$K8S_DIR/start-microservices.sh $NAMESPACE_MICROSERVICES
$K8S_DIR/start-monolith.sh $NAMESPACE_MONOLITH

##################
# LOAD BALANCERS #
##################

# Use AWS Load Balancers to expose Grafana, UIBackend (microservice) and Backend (monolith)
# We expose Grafana because there are issues with Grafana and port-forward.
# We expose UIBackend and Backend because port-forward does no load-balancing (it just picks one pod).

kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-uibackend.yaml -n $NAMESPACE_MICROSERVICES
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-monolith-backend.yaml -n $NAMESPACE_MONOLITH

until kubectl get service/prometheus-grafana-nlb -n monitoring --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
GRAFANA_HOSTNAME=$(kubectl get service/prometheus-grafana-nlb -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo -e "\nGrafana URL: http://${GRAFANA_HOSTNAME}\n"

until kubectl get service/uibackend-nlb -n $NAMESPACE_MICROSERVICES --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
export UIBACKEND_HOSTNAME=$(kubectl get service/uibackend-nlb -n $NAMESPACE_MICROSERVICES -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo -e "\nUIBackend URL: http://${UIBACKEND_HOSTNAME}\n"

until kubectl get service/backend-nlb -n $NAMESPACE_MONOLITH --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
export MONOLITH_BACKEND_HOSTNAME=$(kubectl get service/backend-nlb -n $NAMESPACE_MONOLITH -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo -e "\nMonolith Backend URL: http://${MONOLITH_BACKEND_HOSTNAME}\n"

###############
# AUTOSCALING #
###############

# Wait until every backend app is ready to avoid unnecessary scaling during boot
kubectl wait pods -n $NAMESPACE_MICROSERVICES -l app.kubernetes.io/component=backend --for condition=Ready --timeout=60s
kubectl apply -f $MY_DIR/t2-microservices/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MICROSERVICES

kubectl wait pods -n $NAMESPACE_MONOLITH -l app.kubernetes.io/component=backend --for condition=Ready --timeout=60s
kubectl apply -f $MY_DIR/t2-monolith/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MONOLITH

#########################
# COMPUTATION SIMULATOR #
#########################

if [ $ENABLE_INTENSIVE_COMPUTATION_SCENARIO == true]; then
    kubectl apply -f $K8S_DIR/t2-microservices/computation-simulation/ -n $NAMESPACE_MICROSERVICES
    kubectl set env deployment/uibackend T2_COMPUTATION_SIMULATOR_ENABLED=TRUE -n $NAMESPACE_MICROSERVICES
    kubectl set env deployment/backend T2_COMPUTATION_SIMULATOR_ENABLED=TRUE -n $NAMESPACE_MONOLITH
    kubectl apply -f $K8S_DIR/t2-microservices/autoscaling/ -l t2-scenario=intensive-computation -n $NAMESPACE_MICROSERVICES
fi
