resource "helm_release" "kepler" {
  name             = "kepler"
  chart            = "kepler"
  repository       = "https://sustainable-computing-io.github.io/kepler-helm-chart"
  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "serviceMonitor.enabled"
    value = true
  }

  set {
    name  = "serviceMonitor.labels.release"
    value = "kube-prometheus-stack"
  }

  set {
    name  = "serviceMonitor.labels.app"
    value = "kube-prometheus-stack"
  }

  # --- Extra environment variables ---
  # For available extra environment variables see file https://github.com/sustainable-computing-io/kepler/blob/main/pkg/config/config.go

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
  # access to OS required -> not possible in cloud VM
  set {
    name  = "extraEnvVars.ENABLE_EBPF_CGROUPID"
    value = false
  }

  # enable process metrics (default: false)
  set {
    name  = "extraEnvVars.ENABLE_PROCESS_METRICS"
    value = false
  }

  # enable using the model server to auto select an appropriate power model (default: false).
  # See for more information: https://sustainable-computing.io/kepler_model_server/get_started/#dynamic-via-server-api
  set {
    name  = "extraEnvVars.MODEL_SERVER_ENABLE"
    value = var.use_model_server
  }

  # set log level (default: 1, possible values: 0 - 10, higher means more verbose)
  set {
    name  = "extraEnvVars.KEPLER_LOG_LEVEL"
    value = 1
  }
}

# Source: https://github.com/sustainable-computing-io/kepler/blob/main/manifests/config/base/patch/patch-model-server-kepler-config.yaml
resource "kubernetes_config_map" "model_server" {
  metadata {
    name      = "kepler-model-server"
    namespace = var.namespace
  }
  count = var.use_model_server ? 1 : 0

  data = {
    MODEL_SERVER_ENABLE          = true
    MODEL_SERVER_ENDPOINT        = "http://kepler-model-server.${var.namespace}.svc.cluster.local:8099/model"
    MODEL_SERVER_PORT            = 8099
    MODEL_SERVER_URL             = "http://kepler-model-server.${var.namespace}.svc.cluster.local:8099"
    MODEL_SERVER_MODEL_REQ_PATH  = "/model"
    MODEL_SERVER_MODEL_LIST_PATH = "/best-models"
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
