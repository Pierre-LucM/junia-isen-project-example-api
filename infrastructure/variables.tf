variable "subscription_id" {
    default = "" # write your subscription id here
}

variable "name_prefix" {
    description = "Prefix used to name every resources"
    default     = "ARTOLEPISA"
    type        = string
}

variable "resource_group_location" {
    default     = "francecentral"
    description = "Location of the resource group"
    type        = string
}

variable "resource_group_name" {
    default     = "ARTOLEPISA_resourcegroup"
    description = "Name of the resource group"
    type        = string
}

variable "image_name" {
    description = "The name of the docker image"
    default     = "app"
    type        = string
}

variable "image_tag" {
    description = "The tag of the docker image"
    default     = "latest"
    type        = string
}