#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
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
