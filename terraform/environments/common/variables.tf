variable "kube_config" {
  description = "Path to kube_config"
  type        = string
  default     = "~/.kube/config"
}

variable "set_kubecfg" {
  description = "Set kube config yes or no"
  type        = bool
  default     = false
}

variable "measurement_namespace" {
  description = "Name of measurement namespace"
  type        = string
  default     = "monitoring"
}
