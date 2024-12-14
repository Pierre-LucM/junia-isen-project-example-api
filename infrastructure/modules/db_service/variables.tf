variable "resource_group_name" {
  description = "The name of the resource group where the Cosmos DB will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
}

variable "account_name" {
  description = "The name of the Cosmos DB account."
  type        = string
}

variable "database_name" {
  description = "The name of the Cosmos DB SQL database."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the private endpoint."
  type        = string
}