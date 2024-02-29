module "azure" {
  source              = "../../modules/azure"
  region              = "North Europe"
  cluster_name        = "t2project-aks1"
  resource_group_name = "t2project-resources"
  dns_prefix          = "t2projectaks1"
  set_kubecfg         = var.set_kubecfg
}

module "prometheus" {
  source         = "../../modules/prometheus"
  namespace      = var.measurement_namespace
  create_adapter = true # adapter is required for HPA

  # K8s cluster has to be created first
  depends_on = [module.azure]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = var.measurement_namespace
  # K8s cluster has to be created first and depends on Prometheus because of the ServiceMonitor CRD
  depends_on = [module.azure, module.prometheus]
}
