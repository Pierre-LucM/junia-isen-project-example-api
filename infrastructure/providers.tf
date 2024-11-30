terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.3"
      }
      random = {
        source = "hashicorp/random"
        version = "~> 3.6"
      }
    }
    required_version = "~> 1.9"
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}