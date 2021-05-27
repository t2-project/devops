# Prometheus Files

This folder contains the following files:

## [t2_prometheus.yml](t2_prometheus.yml)

This is the basic [prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/).

Makes prometheus scrape the endpoint `/actuator/prometheus` at *The Cluster*.
And Makes prometheus scrape for the black box exporter on the *The Cluster*. 
It assumes, that the exporters `/probe` endpoint is available from outside *The Cluster*. 

TODO : remember to change this, if i ever manage to put prometheus entirely onto *The Cluster*.

## [t2_rule.yml](t2_rule.yml)

Defines [prometheus recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/).

Currently empty.

## [t2_alert.yml](t2_alert.yml)

Defines [prometheus alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/).

The availability alerts rely on the `probe_success` metric of some (the?) black box exporter.

The response time alerts rely on quantiles provided by the application under observation. 



