#!/bin/bash

NAMESPACE_MODULITH=t2-modulith

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl delete -k $MY_DIR/. -n $NAMESPACE_MODULITH
kubectl scale deploy -l app.kubernetes.io/part-of=t2-modulith --replicas=1 -n $NAMESPACE_MODULITH
