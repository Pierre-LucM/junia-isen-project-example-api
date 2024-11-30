variable "name_prefix" {
    description = "Prefix used to name every resources"
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

variable "acr_login_server" {
    description = "The url to access the container registry"
    type        = string
}

variable "image_name" {
    description = "Name of the docker image"
    type        = string
}

variable "image_tag" {
    description = "Tag of the docker image"
    type        = string
}

variable "subnet_app_id" {
    description = "The id of the subnet app"
    type        = string
}