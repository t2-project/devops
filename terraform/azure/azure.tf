provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "t2project" {
  count    = var.create_module ? 1 : 0
  name     = var.resource_group_name
  location = var.azure_region
}

resource "azurerm_kubernetes_cluster" "t2project" {
  count               = var.create_module ? 1 : 0
  name                = "t2project-aks1"
  location            = var.azure_region
  resource_group_name = azurerm_resource_group.t2project.name
  dns_prefix          = "t2projectaks1"

  default_node_pool {
    name       = "default_node"
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
