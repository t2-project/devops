#!/bin/bash

# Documentation: https://t2-documentation.readthedocs.io/en/latest/modulith/deploy.html

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# If an argument is given, use it as the namespace
if [ $# -gt 0 ]; then
    NAMESPACE=$1
else
    NAMESPACE="default"
fi

if [ $NAMESPACE != "default" ]; then
  kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
fi

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install mongo -f $MY_DIR/mongodb/mongo-values.yaml bitnami/mongodb -n $NAMESPACE

kubectl apply -k $MY_DIR/t2-modulith/base/ -n $NAMESPACE

# Optional: Autoscaling
# kubectl apply -f $MY_DIR/t2-modulith/autoscaling/ -n $NAMESPACE
