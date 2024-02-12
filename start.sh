#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongo-cart --set auth.enabled=false bitnami/mongodb
helm install mongo-order --set auth.enabled=false bitnami/mongodb
helm install kafka bitnami/kafka --version 18.5.0 --set replicaCount=3

kubectl create -f k8s/.  --save-config
