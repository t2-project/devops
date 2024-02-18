provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "t2project" {
  count    = var.create_module ? 1 : 0
  name     = var.resource_group_name
  location = var.azure_region
}

# The naming can be improved with random prefixes, see: https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks
resource "azurerm_kubernetes_cluster" "t2project" {
  count               = var.create_module ? 1 : 0
  name                = var.cluster_name
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.t2project[0].name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_b4ms"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

resource "null_resource" "merge_kubeconfig" {
  count = var.create_module && var.set_kubecfg ? 1 : 0

  depends_on = [azurerm_kubernetes_cluster.t2project, null_resource.az_cli_check]
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${azurerm_kubernetes_cluster.t2project[0].resource_group_name} --name ${azurerm_kubernetes_cluster.t2project[0].name}"
  }
}

resource "null_resource" "az_cli_check" {
  count = var.create_module && var.set_kubecfg ? 1 : 0

  provisioner "local-exec" {
    command    = "which az"
    on_failure = fail
  }
}
