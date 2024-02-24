terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
  }
}
