resource "azurerm_resource_group" "t2project" {
  name     = var.resource_group_name
  location = var.region
}

# The naming can be improved with random prefixes, see: https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks
resource "azurerm_kubernetes_cluster" "t2project" {
  name                = var.cluster_name
  location            = var.region
  resource_group_name = azurerm_resource_group.t2project.name
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
    Environment = "azure"
    Terraform   = "true"
  }
}

resource "null_resource" "merge_kubeconfig" {
  count = var.set_kubecfg ? 1 : 0

  # Check first if az exists
  depends_on = [null_resource.az_cli_check]

  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${azurerm_kubernetes_cluster.t2project.resource_group_name} --name ${azurerm_kubernetes_cluster.t2project.name}"
  }
}

resource "null_resource" "az_cli_check" {
  count = var.set_kubecfg ? 1 : 0

  provisioner "local-exec" {
    command    = "which az"
    on_failure = fail
  }
}
