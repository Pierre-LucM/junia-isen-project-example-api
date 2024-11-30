resource "random_string" "random" {
  length           = 8
  special          = false
  upper            = false
}

module "resource_group" {
  source   =  "./modules/resource_group"
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "container_registry" {
  source                  = "./modules/container_registry"
  name_prefix             = var.name_prefix
  random_string           = random_string.random.result
  resource_group_name     = var.resource_group_name
  resource_group_location = var. resource_group_location
}

module "app_service" {
  source                  = "./modules/app_service"
  name_prefix             = var.name_prefix
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  acr_login_server        = module.container_registry.acr_login_server
  image_name              = var.image_name
  image_tag               = var.image_tag
}

module "network" {
  source = "./modules/network" 

  resource_group_name = "ARTOLEPISA_ressourcegroups"
  location            = "francecentral"
  vnet_name           = "ARTOLEPISA_vnet-secure"
  subnet_name_1       = "ARTOLEPISA-subnet_ip_gateway"
  ip_public_name      = "ARTOLEPISA-public-ip"
  nat_gateway_name    = "ARTOLEPISA-nat-gateway"
}
