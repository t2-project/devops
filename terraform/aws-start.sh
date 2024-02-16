#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"
K8S_DIR=$(builtin cd $MY_DIR/../k8s; pwd)

# Ensure that you are logged-in
if ! aws sts get-caller-identity &> /dev/null
then
  echo "You have to login first!"
  exit 1
fi

# Setup EKS cluster with Prometheus and Kepler
terraform -chdir=./ init
terraform -chdir=./ apply -auto-approve -var "create_aws_eks=true" -var "create_prometheus=true" -var "create_kepler=true"

# Install T2-Project
echo -e "\nInstalling T2-Project"
source $K8S_DIR/start.sh
