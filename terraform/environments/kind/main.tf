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

module "measurement_namespace" {
  source         = "../../modules/measurement_namespace"
  namespace_name = module.common.measurement_namespace
}

module "prometheus" {
  source    = "../../modules/prometheus"
  namespace = module.measurement_namespace.namespace_name
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = module.measurement_namespace.namespace_name
  // set to true on some system, not sure if it works as intended
  use_emulation = false
  depends_on    = [module.prometheus]
}
