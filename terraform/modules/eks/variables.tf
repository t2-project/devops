# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name_prefix" {
  description = "Prefix of cluster name"
  type        = string
}

variable "set_kubecfg" {
  type = bool
}
