# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = var.create_module ? module.eks[0].cluster_endpoint : ""
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = var.create_module ? module.eks[0].cluster_security_group_id : ""
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.create_module ? module.eks[0].cluster_name : ""
}

output "create_module" {
  description = "Whether this module was created"
  value       = var.create_module
}
