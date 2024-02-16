output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.create_module ? module.eks.cluster_endpoint : null
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.create_module ? module.eks.cluster_security_group_id : null
}

output "region" {
  description = "AWS region"
  value       = module.eks.create_module ? module.eks.region : null
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.create_module ? module.eks.cluster_name : "kind-kind"
}
