module "common" {
  source                = "../common"
  kube_config           = "~/.kube/config"
  set_kubecfg           = true
  measurement_namespace = "monitoring"
}

module "kind" {
  source      = "../../modules/kind"
  set_kubecfg = module.common.set_kubecfg
  kube_config = module.common.kube_config
}

module "prometheus" {
  source    = "../../modules/prometheus"
  namespace = module.common.measurement_namespace
  # K8s cluster has to be created first
  depends_on = [module.kind]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = module.common.measurement_namespace
  # K8s cluster has to be created first and depends on Prometheus because of the ServiceMonitor CRD
  depends_on = [module.kind, module.prometheus]
}
