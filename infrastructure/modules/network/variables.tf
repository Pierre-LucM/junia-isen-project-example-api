variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure region for all resources."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "subnet_name_1" {
  description = "The name of the first subnet."
  type        = string
}

variable "ip_public_name" {
  description = "The name of the public IP."
  type        = string
}

variable "nat_gateway_name" {
  description = "The name of the NAT Gateway."
  type        = string
}
