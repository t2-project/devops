#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"

kubectl delete -f $MY_DIR/saga-e2e-test/e2etest.yaml
source $MY_DIR/stop.sh
