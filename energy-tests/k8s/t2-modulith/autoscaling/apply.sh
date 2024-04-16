#!/bin/bash

NAMESPACE_MODULITH=t2-modulith

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl apply -k $MY_DIR/. -l t2-scenario=standard -n $NAMESPACE_MODULITH
