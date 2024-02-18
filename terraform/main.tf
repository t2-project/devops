# module "t2project" {
#   source        = "./modules/t2project"
#   namespace     = var.app-namespace
#   create_module = true
#   depends_on    = [kubernetes_namespace.app-namespace, module.eks, module.kind]
# }

module "prometheus" {
  source        = "./modules/prometheus"
  create_module = var.create_prometheus
  namespace     = var.measurement-namespace
  depends_on    = [kubernetes_namespace.measurement-namespace, module.eks, module.kind]
}

module "kepler" {
  source        = "./modules/kepler"
  create_module = var.create_kepler
  namespace     = var.measurement-namespace
  // set to true on some system, not sure if it works as intended
  use_emulation = false
  depends_on    = [module.prometheus, kubernetes_namespace.measurement-namespace, module.eks, module.kind]
}

module "kind" {
  source        = "./modules/kind"
  create_module = var.create_kind
  set_kubecfg   = true
  kube_config   = var.kube_config
}

# eks module is based on: https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
# source code: https://github.com/hashicorp/learn-terraform-provision-eks-cluster
# Note that the following module expects an awscli properly configured to an AWS account.
# It takes about 10-20 minutes to start.
module "eks" {
  source        = "./modules/eks"
  create_module = var.create_aws_eks
  aws_region    = "eu-north-1"
  set_kubecfg   = true
  create_lb     = true
}

module "azure" {
  source        = "./modules/azure"
  create_module = var.create_azure_aks
  set_kubecfg   = true
}
