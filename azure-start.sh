#!/bin/bash

# azure login

# Setup Kubernetes Cluster
terraform -chdir=terraform/ init
terraform -chdir=terraform/ apply -auto-approve

# Set kubectl context
az aks get-credentials --resource-group t2store-resources --name t2store-aks1

# Install t2-store
helm install mongo-cart --set auth.enabled=false bitnami/mongodb
helm install mongo-order --set auth.enabled=false bitnami/mongodb
helm install kafka bitnami/kafka

kubectl create -f k8/.