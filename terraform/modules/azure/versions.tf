terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.92.0"
    }
  }
}
