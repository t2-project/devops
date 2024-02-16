terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.1"
    }

    kind = {
      source  = "justenwalker/kind"
      version = "~> 0.17.0"
    }
  }
}
