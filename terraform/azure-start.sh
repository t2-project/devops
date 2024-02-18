#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Azure login
az account show &>/dev/null || az login

# Setup AKS cluster with Prometheus and Kepler
terraform workspace select -or-create azure
terraform -chdir=./ init
terraform -chdir=./ apply -auto-approve -var "create_prometheus=true" -var "create_kepler=true"

# Install T2-Project
source $K8S_DIR/start.sh
