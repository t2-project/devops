#!/bin/bash

helm uninstall prometheus
helm uninstall blackbox-exporter
kubectl delete namespace monitoring
