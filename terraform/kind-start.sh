#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Setup kind cluster with Prometheus
terraform workspace select -or-create kind
terraform -chdir=./ init
terraform -chdir=./ apply -auto-approve -var "create_kind=true" -var "create_prometheus=true"

# Install T2-Project
source $K8S_DIR/start.sh

# Make Grafana available
kubectl -n monitoring expose service prometheus-grafana --type=NodePort --target-port=80 --node-port=30000 --name=prometheus-grafana-ext
GRAFANA_HOSTNAME=$(kubectl -n monitoring get svc prometheus-grafana-ext -o jsonpath='{.spec.clusterIP}')
echo -e "\nGrafana URL: http://${GRAFANA_HOSTNAME}"
