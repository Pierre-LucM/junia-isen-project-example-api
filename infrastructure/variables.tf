variable "subscription_id" {
  default = "" # write your subscription id here
}

variable "acr_password" {
  default = "" # write your acr password here
}

variable "acr_client_id" {
  default = "" # write your acr client id here
}

variable "name_prefix" {
  description = "Prefix used to name every resources"
  default     = "artolepisa"
  type        = string
}

variable "resource_group_location" {
  default     = "francecentral"
  description = "Location of the resource group"
  type        = string
}

variable "resource_group_name" {
  default     = "artolepisa-resourcegroup"
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

variable "subnet1_address_prefix" {
  description = "Address prefix for Subnet 1"
  default     = "10.0.1.0/24"
  type        = string
}


variable "new_relic_account_id" {
  description = "New Relic account ID"
  default     = ""
  type        = string
}

variable "emails" {
  description = "The list of emails to notify. has to be comma separated."
  default     = ""
  type        = string
}

variable "new_relic_api_key" {
  description = "The New Relic ingestion key."
  default     = ""
  type        = string
}

variable "new_relic_license_key" {
  description = "The New Relic license key."
  default     = ""
  type        = string
}

variable "new_relic_app_name" {
  description = "The New Relic app name."
  default     = ""
  type        = string
}


