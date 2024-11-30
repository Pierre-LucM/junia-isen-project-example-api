module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "container_registry" {
  source                  = "./modules/container_registry"
  name_prefix             = var.name_prefix
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "app_service" {
  source                  = "./modules/app_service"
  name_prefix             = var.name_prefix
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  acr_login_server        = module.container_registry.login_server
  image_name              = var.image_name
  image_tag               = var.image_tag
}