#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -gt 0 ]; then
    NAMESPACE=$1
else
    NAMESPACE="default"
fi

kubectl delete -k $MY_DIR/t2-monolith/base/ -n $NAMESPACE

helm uninstall mongo -n $NAMESPACE

if [ $NAMESPACE != "default" ]; then
  kubectl delete namespace $NAMESPACE
fi
