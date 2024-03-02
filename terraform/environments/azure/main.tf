module "azure" {
  source              = "../../modules/azure"
  region              = "North Europe"
  cluster_name        = "t2project-aks1"
  resource_group_name = "t2project-resources"
  dns_prefix          = "t2projectaks1"
  set_kubecfg         = var.set_kubecfg
}

module "prometheus" {
  source                   = "../../modules/prometheus"
  namespace                = var.measurement_namespace
  create_blackbox_exporter = false # namespace of target services is hardcoded to "default"
  create_adapter           = true  # adapter is required for HPA

  # K8s cluster has to be created first
  depends_on = [module.azure]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = var.measurement_namespace

  # Prometheus has to be created first because of the ServiceMonitor CRD
  depends_on = [module.prometheus]
}
