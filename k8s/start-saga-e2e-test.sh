#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $MY_DIR/start.sh
kubectl apply -f $MY_DIR/saga-e2e-test/
