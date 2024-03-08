#!/bin/bash

#####################
# RESTOCK INVENTORY #
#####################

# Before executing load testing, restock the inventory

NAMESPACE_MICROSERVICES=t2-microservices
NAMESPACE_MONOLITH=t2-monolith

# Monolith
MONOLITH_BACKEND_HOSTNAME=$(kubectl get service/backend-nlb -n $NAMESPACE_MONOLITH -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
curl "http://${MONOLITH_BACKEND_HOSTNAME}/restock"

# Microservices
# UIBackend has no restock endpoint yet, call inventory service manually
kubectl -n $NAMESPACE_MICROSERVICES port-forward svc/inventory 8082:80
# curl http://localhost:8082/restock
