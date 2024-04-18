#!/bin/bash

NAMESPACE_MICROSERVICES=t2-microservices
NAMESPACE_MODULITH=t2-modulith

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Adapt deployments
kubectl apply -k $MY_DIR/t2-microservices/computation-simulation/ -n $NAMESPACE_MICROSERVICES
kubectl apply -k $MY_DIR/t2-modulith/computation-simulation/ -n $NAMESPACE_MODULITH

# Autoscaling
kubectl apply -k $MY_DIR/t2-microservices/autoscaling/ -l t2-scenario=intensive-computation -n $NAMESPACE_MICROSERVICES
