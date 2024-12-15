resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.resource_group_location
}

module "network" {
  depends_on          = [module.resource_group]
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  vnet_name           = "${var.name_prefix}-vnet-secure"
  subnet_name_1       = "${var.name_prefix}-subnet_ip_gateway"
  subnet_name_2       = "${var.name_prefix}-subnet_app"
  ip_public_name      = "${var.name_prefix}-public-ip"
  nat_gateway_name    = "${var.name_prefix}-nat-gateway"
  subnet3_name        = "${var.name_prefix}-subnet_db"
}

module "container_registry" {
  depends_on              = [module.network]
  source                  = "./modules/container_registry"
  name_prefix             = var.name_prefix
  random_string           = random_string.random.result
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "app_service" {
  depends_on              = [module.container_registry]
  source                  = "./modules/app_service"
  name_prefix             = var.name_prefix
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  acr_login_server        = module.container_registry.acr_login_server
  image_name              = var.image_name
  image_tag               = var.image_tag
  acr_password            = var.acr_password
  acr_username            = var.acr_client_id
  subnet_app_id           = module.network.subnet_app_id
  newrelic_license_key    = var.new_relic_license_key
  newrelic_app_name       = var.new_relic_app_name
}

module "database" {
  depends_on          = [module.network]
  source              = "./modules/db_service"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  account_name        = "${var.name_prefix}-cosmos-db-account"
  database_name       = "${var.name_prefix}-database"
  subnet_id           = module.network.subnet_id
}


