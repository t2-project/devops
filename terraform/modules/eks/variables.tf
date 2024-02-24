variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
}

variable "cluster_name_prefix" {
  description = "Prefix of cluster name"
  type        = string
}

variable "set_kubecfg" {
  type = bool
}
