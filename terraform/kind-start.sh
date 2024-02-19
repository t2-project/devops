#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Always run from the location of this script
cd $MY_DIR

# Setup kind cluster
terraform -chdir=./environments/kind/ init -upgrade
terraform -chdir=./environments/kind/ apply -auto-approve

# Install T2-Project
source $K8S_DIR/start.sh

# Make Grafana available
kubectl -n monitoring expose service prometheus-grafana --type=NodePort --target-port=80 --name=prometheus-grafana-ext
kubectl -n monitoring patch service prometheus-grafana-ext --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":30000}]' # Set node port to 30000
GRAFANA_NODE_PORT=$(kubectl get service -n monitoring prometheus-grafana-ext -o jsonpath='{.spec.ports[0].nodePort}')
GRAFANA_EXTERNAL_IP=$(kubectl get nodes -o=jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
GRAFANA_URL="http://$GRAFANA_NODE_PORT:$GRAFANA_EXTERNAL_IP"
echo -e "\nGrafana URL: ${GRAFANA_URL}"
