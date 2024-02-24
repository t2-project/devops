provider "helm" {
  kubernetes {
    config_path = pathexpand(module.common.kube_config)
  }
}

provider "kubernetes" {
  config_path = pathexpand(module.common.kube_config)
}