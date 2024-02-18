output "region" {
  description = "Azure region"
  value       = var.azure_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.create_module ? azurerm_kubernetes_cluster.t2project[0].name : ""
}

output "create_module" {
  description = "Whether this module was created"
  value       = var.create_module
}
