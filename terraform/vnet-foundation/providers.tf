terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.116"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "avm-bicep-rg"
  #   storage_account_name = "avmbicepstgacc"
  #   container_name       = "tfstate"
  #   key                  = "vnet-foundation.tfstate"
  # }
}

provider "azurerm" {
  features {}
}
