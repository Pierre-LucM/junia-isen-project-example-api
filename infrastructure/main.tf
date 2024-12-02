resource "azurerm_resource_group" "example" {
  name     = "shop-app-rg"
  location = "East US"
}

resource "azurerm_app_service_plan" "example" {
  name                = "shop-app-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "shop-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
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
