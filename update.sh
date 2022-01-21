#!/bin/bash

helm upgrade mongo-cart --set auth.enabled=false bitnami/mongodb
helm upgrade mongo-order --set auth.enabled=false bitnami/mongodb
helm upgrade kafka bitnami/kafka

kubectl apply -f k8/.