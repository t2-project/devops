# module "t2project" {
#   source        = "./t2project"
#   namespace     = var.app-namespace
#   create_module = true
#   depends_on    = [kubernetes_namespace.app-namespace, module.eks, module.kind]
# }

module "prometheus" {
  source        = "./prometheus"
  create_module = var.create_prometheus
  namespace     = var.measurement-namespace
  depends_on    = [kubernetes_namespace.measurement-namespace, module.eks, module.kind]
}

module "kepler" {
  source        = "./kepler"
  create_module = var.create_kepler
  namespace     = var.measurement-namespace
  // set to true on some system, not sure if it works as intended
  use_emulation = false
  depends_on    = [module.prometheus, kubernetes_namespace.measurement-namespace, module.eks, module.kind]
}

module "kind" {
  source        = "./kind"
  create_module = var.create_kind
  set_kubecfg   = true
  kube_config   = var.kube_config
}

# eks module is based on: https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
# source code: https://github.com/hashicorp/learn-terraform-provision-eks-cluster
# Note that the following module expects an awscli properly configured to an AWS account.
# It takes about 10-20 minutes to start.
module "eks" {
  source        = "./eks"
  create_module = var.create_aws_eks
  aws_region    = "eu-north-1"
  set_kubecfg   = false
}

# module "azure" {
#   source        = "./azure"
#   create_module = var.create_azure_aks
#   set_kubecfg   = false
# }
