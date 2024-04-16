#!/bin/bash

NAMESPACE_MICROSERVICES=t2-microservices

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

kubectl apply -k $MY_DIR/. -l t2-scenario=standard -n $NAMESPACE_MICROSERVICES
