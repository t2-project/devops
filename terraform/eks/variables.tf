# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "create_module" {
  type    = bool
  default = false
}

variable "set_kubecfg" {
  type    = bool
  default = false
}
