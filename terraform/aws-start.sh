#!/bin/bash

# Exit immediately if a command returns an error code
set -e

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

# Setup AWS environment
terraform -chdir=./environments/aws/ init -upgrade
terraform -chdir=./environments/aws/ apply -target="module.eks" -auto-approve
terraform -chdir=./environments/aws/ apply -auto-approve

# Install T2-Project
source $K8S_DIR/start.sh

# Expose Grafana and UIBackend and wait for the hostnames
# We expose Grafana because there are issues with Grafana and port-forward.
# We expose UIBackend because port-forward does no load-balancing (it just picks one pod).
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-grafana.yaml
kubectl apply -f $K8S_DIR/load-balancer/aws-loadbalancer-uibackend.yaml
until kubectl get service/prometheus-grafana-nlb -n monitoring --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
GRAFANA_HOSTNAME=$(kubectl get service/prometheus-grafana-nlb -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo -e "\nGrafana URL: http://${GRAFANA_HOSTNAME}"
until kubectl get service/uibackend-nlb -n default --output=jsonpath='{.status.loadBalancer}' | grep "ingress"; do : ; done
UIBACKEND_HOSTNAME=$(kubectl get service/uibackend-nlb -n default -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo -e "\UIBackend URL: http://${UIBACKEND_HOSTNAME}"

# Enable autoscaling (requires that the prometheus-adapter is enabled)
# Wait until every backend app is ready to avoid unnecessary scaling during boot
kubectl wait pods -n default -l app.kubernetes.io/component=backend --for condition=Ready --timeout=60s
kubectl apply -f $K8S_DIR/autoscaling/ -l t2-scenario=standard
