provider "azurerm" {
  features {}
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}


provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}
