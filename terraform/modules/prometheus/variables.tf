variable "namespace" {
  description = "Namespace for Prometheus"
  type        = string
}

variable "create_adapter" {
  description = "Create Prometheus Adapter for Kubernetes Metrics APIs"
  type        = bool
  default     = false
}
