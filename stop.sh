#!/bin/bash

kubectl delete -f k8s/.

helm uninstall mongo-cart
helm uninstall mongo-order
helm uninstall kafka 
