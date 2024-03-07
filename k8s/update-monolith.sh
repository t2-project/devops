#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -gt 0 ]; then
    NAMESPACE=$1
else
    NAMESPACE="default"
fi

helm upgrade mongo -f $MY_DIR/mongodb/mongo-values.yaml bitnami/mongodb -n $NAMESPACE

kubectl apply -k $MY_DIR/t2-monolith/base/ -n $NAMESPACE
