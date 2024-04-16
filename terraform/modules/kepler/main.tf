resource "helm_release" "kepler" {
  name             = "kepler"
  chart            = "kepler"
  repository       = "https://sustainable-computing-io.github.io/kepler-helm-chart"
  namespace        = var.namespace
  create_namespace = true
  version          = "0.5.5" # version "0.5.6" has issues (reports 0 values for the most services), chart version 0.5.5 -> kepler version: 0.7.2, releases: https://github.com/sustainable-computing-io/kepler-helm-chart/releases

  # for available values see https://github.com/sustainable-computing-io/kepler-helm-chart/blob/main/chart/kepler/values.yaml

  set {
    name  = "serviceMonitor.enabled"
    value = true
  }

  set {
    name  = "serviceMonitor.namespace"
    value = var.namespace
  }

  set {
    name  = "serviceMonitor.labels.release"
    value = "kube-prometheus-stack"
  }

  set {
    name  = "serviceMonitor.labels.app"
    value = "kube-prometheus-stack"
  }

  # Scrape interval determines how often Prometheus should scrape the metrics exposed by Kepler
  set {
    name  = "serviceMonitor.interval"
    value = "5s" # default: 30s
  }

  # --- Extra environment variables ---
  # For available extra environment variables see file https://github.com/sustainable-computing-io/kepler/blob/main/pkg/config/config.go

  # sample period determines the time in seconds that Kepler will wait before reading the metrics again (default: 3)
  set {
    name  = "extraEnvVars.SAMPLE_PERIOD_SEC"
    value = "1"
  }

  # expose hardware counter metrics as prometheus metrics (default: true)
  set {
    name  = "extraEnvVars.EXPOSE_HW_COUNTER_METRICS"
    value = true
  }

  # expose interrupt request counter metrics as prometheus metrics (default: true)
  # if false, container fails directly after start
  set {
    name  = "extraEnvVars.EXPOSE_IRQ_COUNTER_METRICS"
    value = true
  }

  # enable the GPU collector (default: true in Helm chart, false in source code)
  set {
    name  = "extraEnvVars.ENABLE_GPU"
    value = false
  }

  # enable the eBPF code to collect cgroup id if the system has kernel version >= 4.18 (default: true)
  # cgroup v2 is required and must be supported by the OS.
  # Amazon Linux 2 and Ubuntu 20.04 don't support cgroup v2, however Bottlerocket and Ubuntu 22.04 do.
  set {
    name  = "extraEnvVars.ENABLE_EBPF_CGROUPID"
    value = true
  }

  # enable process metrics (default: false)
  set {
    name  = "extraEnvVars.ENABLE_PROCESS_METRICS"
    value = false
  }

  # enable using the model server to auto select an appropriate power model (default: false).
  # See for more information: https://sustainable-computing.io/kepler_model_server/get_started/#dynamic-via-server-api
  # Required additional deployment files: https://github.com/sustainable-computing-io/kepler-model-server/tree/main/manifests
  set {
    name  = "extraEnvVars.MODEL_SERVER_ENABLE"
    value = false
  }

  # set log level (default: 1, possible values: 0 - 10, higher means more verbose)
  set {
    name  = "extraEnvVars.KEPLER_LOG_LEVEL"
    value = 5
  }
}

resource "kubernetes_config_map_v1" "kepler_grafana_dashboards" {
  metadata {
    name      = "kepler-grafana-dashboard"
    namespace = var.namespace
    labels = {
      grafana_dashboard : "1"
    }
  }

  data = {
    "Kepler-Exporter.json" = file("${abspath(path.module)}/dashboard/Kepler-Exporter.json")
  }

  depends_on = [helm_release.kepler]
}
