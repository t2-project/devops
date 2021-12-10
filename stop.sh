#!/bin/bash

kubectl delete -f k8/.

helm uninstall mongo
helm uninstall kafka 
