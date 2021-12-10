#!/bin/bash

helm install mongo --set auth.enabled=false bitnami/mongodb
helm install kafka bitnami/kafka

kubectl create -f k8/.