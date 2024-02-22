#!/bin/bash

MY_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# add repo for prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# install charts
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring -f $MY_DIR/prometheus-values.yaml
helm install blackbox-exporter prometheus-community/prometheus-blackbox-exporter -n monitoring -f $MY_DIR/blackbox-exporter-values.yaml

#Expose Prometheus
#kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
#PROM_URL=$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }');
#PROM_PORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-server-ext);
#echo "\n 🔥 Prometheus URL 🔥 \n http://${PROM_URL}:${PROM_PORT}";

#Expose Grafana
#kubectl -n monitoring expose service prometheus-grafana --type=NodePort --target-port=80 --name=prometheus-grafana-ext
#GRAFANA_URL=$(kubectl -n monitoring get -o jsonpath="{.spec.clusterIP}" services prometheus-grafana-ext);
#GRAFANA_PORT=$(kubectl -n monitoring get -o jsonpath="{.spec.ports[0].nodePort}" services prometheus-grafana-ext);
#echo "\n 🔥 Grafana URL 🔥 \n http://${GRAFANA_URL}:${GRAFANA_PORT}";
