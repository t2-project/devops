#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

helm upgrade mongo-cart --set auth.enabled=false bitnami/mongodb
helm upgrade mongo-order --set auth.enabled=false bitnami/mongodb
helm upgrade kafka bitnami/kafka

kubectl apply -f $MY_DIR/
