#!/bin/bash

helm install mongo-cart --set auth.enabled=false bitnami/mongodb
helm install mongo-order --set auth.enabled=false bitnami/mongodb
helm install kafka bitnami/kafka

kubectl create -f k8/.