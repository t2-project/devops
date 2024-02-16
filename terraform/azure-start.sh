#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Azure login
az account show &>/dev/null || az login

# Setup AKS cluster with Prometheus and Kepler
terraform -chdir=./ init
terraform -chdir=./ apply -auto-approve -var "create_azure_aks=true" -var "create_prometheus=true" -var "create_kepler=true"

# Set kubectl context
az aks get-credentials --resource-group t2project-resources --name t2project-aks1

# Install T2-Project
source $K8S_DIR/start.sh
