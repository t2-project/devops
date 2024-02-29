#!/bin/bash

helm uninstall prometheus
helm uninstall blackbox-exporter
helm uninstall prometheus-adapter
kubectl delete namespace monitoring
