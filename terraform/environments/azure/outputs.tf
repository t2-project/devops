output "region" {
  description = "Azure region"
  value       = module.azure.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.azure.cluster_name
}
