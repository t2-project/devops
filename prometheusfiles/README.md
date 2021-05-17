# Prometheus Files

This folder contains the following files:

## [t2_prometheus.yml](t2_prometheus.yml)

This is the basic [prometheus configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/).

It configs prometheus to scrape the endpoint `/actuator/prometheus` at *The Cluster*.

## [t2_rule.yml](t2_rule.yml)

Defines [prometheus recording rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/).

Both `reditinstitute:success_failure_rate1m_v1` and `reditinstitute:success_failure_rate1m_v2` try to capture some kind availability, neither really works but `v2` sucks even more than `v1`.

## [t2_alert.yml](t2_alert.yml)

Defines [prometheus alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/).

The file contains an alert for when median request latency is too high and two more alerts based on the recording rules mentioned above that suck just as much as those.



