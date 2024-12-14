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

module "network" {
  source              = "./modules/network" 
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  vnet_name           = "${var.name_prefix}_vnet-secure"
  subnet_name_1       = "${var.name_prefix}-subnet_ip_gateway"
  subnet_name_2       = "${var.name_prefix}-subnet_app"
  ip_public_name      = "${var.name_prefix}-public-ip"
  nat_gateway_name    = "${var.name_prefix}-nat-gateway"
  subnet3_name        = "${var.name_prefix}-subnet3"
}

module "container_registry" {
  source                  = "./modules/container_registry"
  name_prefix             = var.name_prefix
  random_string           = random_string.random.result
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "app_service" {
  source                  = "./modules/app_service"
  name_prefix             = var.name_prefix
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  acr_login_server        = module.container_registry.acr_login_server
  image_name              = var.image_name
  image_tag               = var.image_tag
  subnet_app_id           = module.network.subnet_app_id
}

module "database" {
  source              = "./modules/db_service"
 resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  account_name        = "ARTOLEPISA_cosmos_db_account"
  database_name       = "ARTOLEPISA_database"
  subnet_id           = module.network.subnet_db.id
}