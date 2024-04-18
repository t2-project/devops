#!/bin/bash

NAMESPACE_MICROSERVICES=t2-microservices
NAMESPACE_MODULITH=t2-modulith

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Adapt deployments
kubectl delete -k $MY_DIR/t2-microservices/computation-simulation/ -n $NAMESPACE_MICROSERVICES
kubectl delete -k $MY_DIR/t2-modulith/computation-simulation/ -n $NAMESPACE_MODULITH

# Reset to standard scenario
kubectl apply -k $MY_DIR/t2-microservices/standard/ -n $NAMESPACE_MICROSERVICES
kubectl apply -k $MY_DIR/t2-modulith/standard/ -n $NAMESPACE_MODULITH

# Autoscaling
kubectl delete -k $MY_DIR/t2-microservices/autoscaling/ -l t2-scenario=intensive-computation -n $NAMESPACE_MICROSERVICES
