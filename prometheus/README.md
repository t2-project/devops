# Prometheus Files

This folder contains Prometheus configurations (Helm values) and alerts in case you want to monitor the T2-Project with Prometheus. 

Prometheus configurations:

- `prometheus-values.yaml` ([kube-prometheus-stack/values.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml))
- `prometheus-adapter-values.yaml` ([prometheus-adapter/values.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-adapter/values.yaml))
- `blackbox-exporter-values.yaml` ([prometheus-blackbox-exporter/values.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-blackbox-exporter/values.yaml))

The Prometheus Adapter is used for the Horizontal Pod Autoscaler as an alternative to the default Metrics Server. See [Configuration](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-adapter#configuration) for more information about how to configure the rules.

Alerts:

- [t2_alert.yml](t2_alert.yml) : Prometheus alerting rules.
- [t2_prometheus_blackbox_alert.yml](t2_prometheus_blackbox_alert.yml) : Prometheus configuration.
- [t2_alertmanager_test.yml](t2_alertmanager_test.yml) : alert manager configuration.

(Actually they are only here, because i cannot get Solomon to work...)
