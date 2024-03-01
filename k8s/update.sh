#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -gt 0 ]; then
    NAMESPACE=$1
else
    NAMESPACE="default"
fi

helm upgrade mongo-cart --set auth.enabled=false bitnami/mongodb -n $NAMESPACE
helm upgrade mongo-order --set auth.enabled=false bitnami/mongodb -n $NAMESPACE
helm upgrade kafka bitnami/kafka -n $NAMESPACE

kubectl apply -f $MY_DIR/ -n $NAMESPACE
