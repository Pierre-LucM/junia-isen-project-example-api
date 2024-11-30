variable "name_prefix" {
    description = "Prefix used to name every resources"
    type        = string
}

variable "random_string" {
    description = "A random string to ensure that the resource name will be unique"
    type        = string
}

variable "resource_group_name" {
    description = "Name of the resource group"
    type        = string
}

variable "resource_group_location" {
    description = "Location of the resource group"
    type        = string
}