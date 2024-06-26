#!/bin/bash

NAMESPACE_MICROSERVICES=t2-microservices
NAMESPACE_MODULITH=t2-modulith
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

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

###############
# EKS Cluster #
###############

$TERRAFORM_DIR/aws-start.sh

##################
# T2 DEPLOYMENTS #
##################

# $K8S_DIR/start-microservices.sh $NAMESPACE_MICROSERVICES
# $K8S_DIR/start-modulith.sh $NAMESPACE_MODULITH

kubectl create namespace $NAMESPACE_MICROSERVICES --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace $NAMESPACE_MODULITH --dry-run=client -o yaml | kubectl apply -f -

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade -i mongo-cart -f $K8S_DIR/mongodb/mongo-values.yaml bitnami/mongodb -n $NAMESPACE_MICROSERVICES
helm upgrade -i mongo-order -f $K8S_DIR/mongodb/mongo-values.yaml bitnami/mongodb -n $NAMESPACE_MICROSERVICES
helm upgrade -i kafka bitnami/kafka --version 18.5.0 --set replicaCount=1 -n $NAMESPACE_MICROSERVICES

helm upgrade -i mongo -f $K8S_DIR/mongodb/mongo-values.yaml bitnami/mongodb -n $NAMESPACE_MODULITH

kubectl apply -k $MY_DIR/t2-microservices/standard/ -n $NAMESPACE_MICROSERVICES
kubectl apply -k $MY_DIR/t2-modulith/standard/ -n $NAMESPACE_MODULITH

##################
# LOAD BALANCERS #
##################

# Use AWS Load Balancers to expose Grafana, UIBackend (microservice) and Backend (modulith)
# We expose Grafana because there are issues with Grafana and port-forward.
# We expose UIBackend and Backend because port-forward does no load-balancing (it just picks one pod).

kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-uibackend.yaml -n $NAMESPACE_MICROSERVICES
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-modulith-backend.yaml -n $NAMESPACE_MODULITH

until kubectl get service/prometheus-grafana-nlb -n monitoring --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
GRAFANA_HOSTNAME=$(kubectl get service/prometheus-grafana-nlb -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

until kubectl get service/uibackend-nlb -n $NAMESPACE_MICROSERVICES --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
export UIBACKEND_HOSTNAME=$(kubectl get service/uibackend-nlb -n $NAMESPACE_MICROSERVICES -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

until kubectl get service/backend-nlb -n $NAMESPACE_MODULITH --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
export MODULITH_HOSTNAME=$(kubectl get service/backend-nlb -n $NAMESPACE_MODULITH -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

###############
# AUTOSCALING #
###############

# Wait until every backend app is ready to avoid unnecessary scaling during boot
kubectl wait pods -n $NAMESPACE_MICROSERVICES -l app.kubernetes.io/component=backend --for condition=Ready --timeout=60s
kubectl apply -k $MY_DIR/t2-microservices/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MICROSERVICES

kubectl wait pods -n $NAMESPACE_MODULITH -l app.kubernetes.io/component=backend --for condition=Ready --timeout=60s
kubectl apply -k $MY_DIR/t2-modulith/autoscaling/ -l t2-scenario=standard -n $NAMESPACE_MODULITH

#########################
# COMPUTATION SIMULATOR #
#########################

if [ $ENABLE_INTENSIVE_COMPUTATION_SCENARIO == true ]; then
    source $MY_DIR/enable-compute-intensive-scenario.sh
fi

####################
# URLs & HOSTNAMES #
####################

echo "---"

echo -e "Grafana:\nhttp://${GRAFANA_HOSTNAME}\n"
echo -e "T2-Microservices API:\nhttp://${UIBACKEND_HOSTNAME}/swagger-ui/index.html\n"
echo -e "T2-Modulith API:\nhttp://${MODULITH_HOSTNAME}/swagger-ui/index.html\n"

echo -e "UI Backend Hostname:\n${UIBACKEND_HOSTNAME}\n"
echo -e "Modulith Hostname:\n${MODULITH_HOSTNAME}\n"
