resource "azurerm_container_registry" "acr" {
  name                   = "${var.name_prefix}containerregistry"
  resource_group_name    = var.resource_group_name
  location               = var.resource_group_location
  sku                    = "Standard"
  admin_enabled          = "false"
  anonymous_pull_enabled = "true"
}