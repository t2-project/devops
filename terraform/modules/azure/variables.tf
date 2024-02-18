variable "resource_group_name" {
  description = "Azure resources name"
  default     = "t2project-resources"
}

variable "azure_region" {
  description = "Azure region"
  default     = "North Europe"
}

variable "cluster_name" {
  description = "Cluster name"
  default     = "t2project-aks1"
}

variable "dns_prefix" {
  description = "DNS prefix"
  default     = "t2projectaks1"
}

variable "namespace_name" {
  description = "Namespace for T2-Project in Kubernetes cluster"
  default     = "t2project"
}

variable "create_module" {
  type    = bool
  default = false
}

variable "set_kubecfg" {
  type    = bool
  default = false
}
