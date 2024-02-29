# Prometheus

## Kube Stack

The kube-prometheus-stack is a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

Source code: https://github.com/prometheus-operator/kube-prometheus
Helm Chart: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

## Blackbox Exporter

The blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.

Source code: https://github.com/prometheus/blackbox_exporter
Helm Chart: https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-blackbox-exporter

## Adapter for Kubernetes Metrics APIs

This adapter is suitable for use with the autoscaling/v2 Horizontal Pod Autoscaler.
It can also replace the metrics server on clusters that already run Prometheus and collect the appropriate metrics.

Source Code: https://github.com/kubernetes-sigs/prometheus-adapter
Helm Chart: https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-adapter
