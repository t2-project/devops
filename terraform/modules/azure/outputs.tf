output "region" {
  description = "Azure region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = azurerm_kubernetes_cluster.t2project.name
}
