module "kind" {
  source      = "../../modules/kind"
  set_kubecfg = var.set_kubecfg
  kube_config = var.kube_config
}

module "prometheus" {
  source                   = "../../modules/prometheus"
  namespace                = var.measurement_namespace
  create_blackbox_exporter = false # namespace of target services is hardcoded to "default"
  create_adapter           = true  # adapter is required for HPA

  # K8s cluster has to be created first
  depends_on = [module.kind]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = var.measurement_namespace

  # Prometheus has to be created first because of the ServiceMonitor CRD
  depends_on = [module.prometheus]
}
