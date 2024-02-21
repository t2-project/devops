module "common" {
  source                = "../common"
  kube_config           = "~/.kube/config"
  set_kubecfg           = true
  measurement_namespace = "monitoring"
}

module "azure" {
  source              = "../../modules/azure"
  region              = "North Europe"
  cluster_name        = "t2project-aks1"
  resource_group_name = "t2project-resources"
  dns_prefix          = "t2projectaks1"
  set_kubecfg         = module.common.set_kubecfg
}

module "prometheus" {
  source    = "../../modules/prometheus"
  namespace = module.common.measurement_namespace
  # K8s cluster has to be created first
  depends_on = [module.azure]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = module.common.measurement_namespace
  // set to true on some system, not sure if it works as intended
  use_emulation = false
  # K8s cluster has to be created first and depends on Prometheus because of the ServiceMonitor CRD
  depends_on = [module.azure, module.prometheus]
}
