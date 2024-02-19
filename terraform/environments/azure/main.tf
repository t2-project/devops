module "azure" {
  source              = "../../modules/azure"
  region              = "North Europe"
  cluster_name        = "t2project-aks1"
  resource_group_name = "t2project-resources"
  dns_prefix          = "t2projectaks1"
  set_kubecfg         = module.common.set_kubecfg
}

module "loadbalancer" {
  source       = "../../modules/aws_loadbalancer"
  region       = module.eks.region
  cluster_name = module.eks.cluster_name
  provider_arn = module.eks.provider_arn
  vpc_id       = module.eks.vpc_id
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

module "common" {
  source = "../common"
}
