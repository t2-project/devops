variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_version" {
  description = "The Kubernetes version for the cluster"
  type        = string
  default     = "1.28"
}

variable "cluster_name_prefix" {
  description = "Prefix for cluster name"
  type        = string
  default     = "t2project-eks"
}

variable "kube_config" {
  description = "Path to kube_config"
  type        = string
  default     = "~/.kube/config"
}

variable "set_kubecfg" {
  description = "Update kube config with cluster information to be able to use kubectl"
  type        = bool
  default     = true
}

variable "measurement_namespace" {
  description = "Name of measurement namespace"
  type        = string
  default     = "monitoring"
}
