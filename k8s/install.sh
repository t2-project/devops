#!/bin/bash

# Documentation: https://t2-documentation.readthedocs.io/en/latest/microservices/deploy.html

MY_DIR="$(dirname "$(readlink -f "$0")")"

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install mongo bitnami/mongodb --set auth.enabled=false
helm install kafka bitnami/kafka --version 18.5.0 --set replicaCount=3

kubectl create -f $MY_DIR/ --save-config

kubectl create configmap postgres-config --from-file $MY_DIR/postgresql.conf
