module "kind" {
  source      = "../../modules/kind"
  set_kubecfg = var.set_kubecfg
  kube_config = var.kube_config
}

module "prometheus" {
  source    = "../../modules/prometheus"
  namespace = var.measurement_namespace
  # K8s cluster has to be created first
  depends_on = [module.kind]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = var.measurement_namespace
  # K8s cluster has to be created first and depends on Prometheus because of the ServiceMonitor CRD
  depends_on = [module.kind, module.prometheus]
}
