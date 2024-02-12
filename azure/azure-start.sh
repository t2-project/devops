#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Azure login
az account show &>/dev/null || az login

# Setup Kubernetes Cluster
terraform -chdir=../terraform/ init
terraform -chdir=../terraform/ apply -auto-approve

# Set kubectl context
az aks get-credentials --resource-group t2project-resources --name t2project-aks1

# Install T2-Project
source $K8S_DIR/start.sh
