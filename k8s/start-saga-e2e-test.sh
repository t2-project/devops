#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"

source $MY_DIR/start.sh
kubectl delete -f $MY_DIR/creditinstitute.yaml
kubectl apply -f $MY_DIR/saga-e2e-test/
