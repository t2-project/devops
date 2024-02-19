variable "resource_group_name" {
  description = "Azure resources name"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix"
  type        = string
}

variable "set_kubecfg" {
  type    = bool
  default = false
}
