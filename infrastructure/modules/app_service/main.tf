resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-appserviceplan"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                          = "${var.name_prefix}-webapp-service"
  resource_group_name           = var.resource_group_name
  location                      = azurerm_service_plan.plan.location
  service_plan_id               = azurerm_service_plan.plan.id
  public_network_access_enabled = true

  site_config {
    application_stack {
      docker_image_name        = "${var.image_name}:${var.image_tag}"
      docker_registry_url      = "https://${var.acr_login_server}"
      docker_registry_password = var.acr_password
      docker_registry_username = var.acr_username
    }
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = var.subnet_app_id

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITE_PULL_IMAGE_OVER_VNET        = "true"
    "NEW_RELIC_LICENSE_KEY"             = var.newrelic_license_key
    "NEW_RELIC_APP_NAME"                = var.newrelic_app_name
  }

  https_only = true
}
