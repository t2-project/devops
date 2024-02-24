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
  region              = var.region
  cluster_name_prefix = var.cluster_name_prefix
  set_kubecfg         = module.common.set_kubecfg
}

module "loadbalancer" {
  source       = "../../modules/aws-loadbalancer"
  region       = module.eks.region
  cluster_name = module.eks.cluster_name
  provider_arn = module.eks.oidc_provider_arn
  vpc_id       = module.eks.vpc_id
}

module "container-insights" {
  source              = "../../modules/eks-container-insights"
  eks_cluster_id      = module.eks.cluster_id
  eks_cluster_version = module.eks.cluster_version
  # Addon amazon_cloudwatch_observability needs the AWS Load Balancer webhook service
  depends_on = [module.loadbalancer]
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
  # Prometheus has to be created first because of the ServiceMonitor CRD
  depends_on = [module.prometheus]
}
