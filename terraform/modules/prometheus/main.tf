locals {
  prometheus_values_path         = abspath(format("%s/../../../prometheus/prometheus-values.yaml", path.module))
  blackbox_exporter_values_path  = abspath(format("%s/../../../prometheus/blackbox-exporter-values.yaml", path.module))
  prometheus_adapter_values_path = abspath(format("%s/../../../prometheus/prometheus-adapter-values.yaml", path.module))
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true
  version          = "56.6.2"

  values = [
    "${file("${local.prometheus_values_path}")}"
  ]
  timeout = 2000

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = false
  }

  # You can provide a map of value using yamlencode. Don't forget to escape the last element after point in the name
  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}

resource "helm_release" "blackbox-exporter" {
  name             = "blackbox-exporter"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus-blackbox-exporter"
  namespace        = var.namespace
  create_namespace = true
  version          = "8.10.1"

  values = [
    "${file("${local.blackbox_exporter_values_path}")}"
  ]

  # Prometheus ServiceMonitors must be created first
  depends_on = [helm_release.prometheus]
}

resource "helm_release" "prometheus-adapter" {

  count = var.create_adapter ? 1 : 0

  name       = "prometheus-adapter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-adapter"
  version    = "4.9.0"
  namespace  = var.namespace

  set {
    name  = "prometheus.url"
    value = "http://prometheus-kube-prometheus-prometheus.${var.namespace}.svc"
  }

  set {
    name  = "prometheus.port"
    value = 9090
  }

  # Use default resource metrics that can be used for HPA
  values = [
    "${file("${local.prometheus_adapter_values_path}")}"
  ]

  # Prometheus ServiceMonitors must be created first
  depends_on = [helm_release.prometheus]
}
