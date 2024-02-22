#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl delete -f $MY_DIR/saga-e2e-test/e2etest.yaml
source $MY_DIR/stop.sh
