#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl delete -f $MY_DIR/

helm uninstall mongo-cart
helm uninstall mongo-order
helm uninstall kafka
