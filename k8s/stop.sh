#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"

kubectl delete -f $MYDIR/
kubectl delete configmap $MY_DIR/postgres-config

helm uninstall mongo-cart
helm uninstall mongo-order
helm uninstall kafka
