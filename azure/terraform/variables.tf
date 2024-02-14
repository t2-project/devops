# Azure
variable "resource_group_name" {
  default = "t2project-resources"
}

variable "region" {
  default = "West Europe"
}

# Kubernetes Cluster
variable "namespace_name" {
  default = "t2project"
}