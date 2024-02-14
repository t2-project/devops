#!/bin/bash

MY_DIR="$(dirname "$(readlink -f "$0")")"

kubectl delete -f $MY_DIR/
kubectl delete configmap postgres-config

helm uninstall mongo-cart
helm uninstall mongo-order
helm uninstall kafka
