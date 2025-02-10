
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "2.20.0"
    }
  }

  backend "azurerm" {}
}