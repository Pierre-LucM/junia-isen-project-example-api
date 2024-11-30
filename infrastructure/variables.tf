variable "subscription_id" {
  default = "" # write your subscription id here
}

variable "name_prefix" {
  description = "Prefix used to name avery resources."
  default     = "ARTOLEPISA"
  type        = string
}

variable "resource_group_location" {
  default     = "francecentral"
  description = "Location of the resource group."
  type        = string
}

variable "resource_group_name" {
  default     = "ARTOLEPISA_ressourcegroup"
  description = "Name of the resource group."
  type        = string
}

variable "image_name" {
  description = "Image name"
  default     = "app"
  type        = string
}

variable "image_tag" {
  description = "Image tag"
  default     = "latest"
  type        = string
}