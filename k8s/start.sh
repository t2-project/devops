#!/bin/bash

# Documentation: https://t2-documentation.readthedocs.io/en/latest/microservices/deploy.html

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install mongo-cart --set auth.enabled=false bitnami/mongodb
helm install mongo-order --set auth.enabled=false bitnami/mongodb
helm install kafka bitnami/kafka --version 18.5.0 --set replicaCount=3

kubectl create -f $MY_DIR/ --save-config
