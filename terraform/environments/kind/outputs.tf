output "cluster_name" {
  description = "Cluster Name"
  value       = module.kind.cluster_name
}

output "cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = module.kind.cluster_endpoint
}
