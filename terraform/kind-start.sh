#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Setup kind cluster with Prometheus and Kepler
terraform workspace select -or-create kind
terraform -chdir=./ init
terraform -chdir=./ apply -auto-approve -var "create_prometheus=true"  -var "create_kepler=true"

# Install T2-Project
source $K8S_DIR/start.sh

# Make Grafana available
kubectl -n monitoring expose service prometheus-grafana --type=NodePort --target-port=80 --node-port=30000 --name=prometheus-grafana-ext
GRAFANA_NODE_PORT=$(kubectl get service -n monitoring prometheus-grafana-ext -o jsonpath='{.spec.ports[0].nodePort}')
GRAFANA_EXTERNAL_IP=$(kubectl get nodes -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
GRAFANA_URL="http://$GRAFANA_NODE_PORT:$GRAFANA_EXTERNAL_IP"
echo -e "\nGrafana URL: ${GRAFANA_URL}"
