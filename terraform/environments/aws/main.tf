module "common" {
  source                = "../common"
  kube_config           = "~/.kube/config"
  set_kubecfg           = true
  measurement_namespace = "monitoring"
}

# eks module is based on: https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
# source code: https://github.com/hashicorp/learn-terraform-provision-eks-cluster
# Note that the following module expects an awscli properly configured to an AWS account.
# It takes about 10-20 minutes to start.
module "eks" {
  source              = "../../modules/eks"
  region              = "eu-north-1"
  cluster_name_prefix = "t2project-eks"
  set_kubecfg         = module.common.set_kubecfg
}

module "loadbalancer" {
  source       = "../../modules/aws_loadbalancer"
  region       = module.eks.region
  cluster_name = module.eks.cluster_name
  provider_arn = module.eks.provider_arn
  vpc_id       = module.eks.vpc_id
}

module "prometheus" {
  source    = "../../modules/prometheus"
  namespace = module.common.measurement_namespace
  # K8s cluster has to be created first
  depends_on = [module.eks]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = module.common.measurement_namespace
  // set to true on some system, not sure if it works as intended
  use_emulation = false
  # K8s cluster has to be created first and depends on Prometheus because of the ServiceMonitor CRD
  depends_on = [module.eks, module.prometheus]
}
