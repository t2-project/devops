variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "create_prometheus" {
  type    = bool
  default = false
}

variable "create_kepler" {
  type    = bool
  default = false
}

variable "measurement-namespace" {
  type    = string
  default = "monitoring"
}

# variable "app-namespace" {
#   type    = string
#   default = "t2project"
# }
