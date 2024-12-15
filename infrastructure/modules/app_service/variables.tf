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

variable "acr_password" {
    description = "The password to access the container registry"
    default = ""
    type        = string
}

variable "acr_username" {
    description = "The username to access the container registry"
    default = ""
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

variable "newrelic_license_key" {
    description = "The license key for new relic"
    type        = string
}

variable "newrelic_app_name" {
    description = "The name of the new relic app"
    type        = string
}