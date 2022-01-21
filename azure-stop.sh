#!/bin/bash

kubectl delete -f k8/.

helm uninstall mongo-cart
helm uninstall mongo-order
helm uninstall kafka 

terraform -chdir=terraform/ destroy -auto-approve