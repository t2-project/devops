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
