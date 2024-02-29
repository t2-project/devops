# Note that it is expected that the aws CLI is properly configured and you are logged in.
# It takes about 20 minutes to start everything.

module "eks" {
  source              = "../../modules/eks"
  region              = var.region
  cluster_version     = var.cluster_version
  cluster_name_prefix = var.cluster_name_prefix
  set_kubecfg         = var.set_kubecfg
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
  source         = "../../modules/prometheus"
  namespace      = var.measurement_namespace
  create_adapter = true # adapter is required for HPA

  # K8s cluster has to be created first
  depends_on = [module.eks]
}

module "kepler" {
  source    = "../../modules/kepler"
  namespace = var.measurement_namespace

  # Prometheus has to be created first because of the ServiceMonitor CRD
  depends_on = [module.prometheus]
}
