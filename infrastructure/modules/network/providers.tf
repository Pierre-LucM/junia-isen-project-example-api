provider "azurerm" {
  subscription_id = "c939ded3-5664-48f6-8e57-ab76e52cfd58"
  
    features {}
}

terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}