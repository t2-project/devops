variable "namespace" {
  description = "Namespace for Prometheus"
  type        = string
}

variable "create_blackbox_exporter" {
  description = "Create Blackbox Exporter"
  type = bool
  default = false
}

variable "create_adapter" {
  description = "Create Prometheus Adapter for Kubernetes Metrics APIs"
  type        = bool
  default     = false
}
