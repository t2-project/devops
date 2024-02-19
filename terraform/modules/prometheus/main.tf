resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.namespace
  create_namespace = true
  version          = "56.6.2"

  values = [
    "${file("${abspath(path.module)}/prometheus-values.yaml")}"
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
    "${file("${abspath(path.module)}/blackbox-exporter-values.yaml")}"
  ]

  # Prometheus ServiceMonitors must be created first
  depends_on = [helm_release.prometheus]
}
