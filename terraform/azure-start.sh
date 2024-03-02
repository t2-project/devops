#!/bin/bash

# Exit immediately if a command returns an error code
set -e

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $MY_DIR

# Azure login
az account show &>/dev/null || az login

# Setup Azure environment
terraform -chdir=./environments/azure/ init -upgrade
terraform -chdir=./environments/azure/ apply -target="module.azure" -auto-approve
terraform -chdir=./environments/azure/ apply -auto-approve
