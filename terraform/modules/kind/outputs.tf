output "cluster_name" {
  description = "Cluster Name"
  value       = kind_cluster.kind_cluster.name
}

output "cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = kind_cluster.kind_cluster.endpoint
}
