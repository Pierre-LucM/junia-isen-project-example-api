resource "azurerm_service_plan" "plan" {
  name                = "${var.name_prefix}-appserviceplan"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.name_prefix}-webapp"
  resource_group_name = var.resource_group_name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      docker_image_name   = "${var.image_name}:${var.image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITE_PULL_IMAGE_OVER_VNET        = "true"
    WEBSITES_PORT                       = "5000"
  }

  https_only = true
}