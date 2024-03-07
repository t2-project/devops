#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -gt 0 ]; then
    NAMESPACE=$1
else
    NAMESPACE="default"
fi

source $MY_DIR/start-microservices.sh $NAMESPACE
kubectl apply -k $MY_DIR/t2-microservices/saga-e2e-test/ -n $NAMESPACE
