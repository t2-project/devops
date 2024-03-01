#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ $# -gt 0 ]; then
    NAMESPACE=$1
else
    NAMESPACE="default"
fi

kubectl delete -f $MY_DIR/saga-e2e-test/e2etest.yaml -n $NAMESPACE
source $MY_DIR/stop.sh -n $NAMESPACE
